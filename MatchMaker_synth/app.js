var restify = require('restify');
var server = restify.createServer();
var pg = require('pg');
var redis = require('redis');
var io = require('socket.io')(server.server);
var staticServer = require('node-static');
var file = new staticServer.Server('./node_modules');
require('http').createServer(function (res, req) {
	res.addListener('end', function () {
		file.serve(res, req);
	}).resume();
}).listen('3009');
//加载内部函数
var db = require('./db.js');

//构建一个数据库对象
var conString = "postgres://sue_sister:123456@127.0.0.1:5432/MatchMaker";
var client = new pg.Client(conString);
client.connect(function(error, result){
	if(error) {
		console.log('数据库连接失败' + error.message);
		client.end();
		return;
	}
	console.log('数据库连接成功');
	
})


//方法
function login(req, res, next) {
	console.log(req.params);
	//登陆
	db.login(req.params.phone, req.params.password, client, res);
	
}

function getFriends(req, res, next) {
	console.log(req.params);
	//获取好友
	db.getFriends(req.params.id, client, res);
	
}

//构建server
server.use(restify.queryParser());
server.use(restify.bodyParser());
server.use(restify.CORS());

server.post('/login', login);
server.post('/getFriends', getFriends);

server.listen(3008, function() {
  console.log('%s listening at %s', server.name, server.url);
});

server.get('/', function (req, res) {
	require('fs').readFile('./index.html', 'utf8', function (err, data) {
		res.writeHead(200, {'Content-Type': 'text/html'});
		res.write(data);
		res.end();
	});
});
//redis

var RDS_PORT = 6379,
	RDS_HOST = '127.0.0.1',
	RDS_PWD = 'porschev',
	RDS_OPTS = {},
	redis_client = redis.createClient(RDS_PORT, RDS_HOST, RDS_OPTS);

redis_client.auth(RDS_PWD, function(){
	console.log('redis通过认证');
});
redis_client.on('connect', function(){
	console.log('redis connect');
})

redis_client.on('error', function(error) {
	console.log(error);
});

redis_client.on('ready', function(res) {
	console.log('redis is ready');
});

//socket
/*
	用户对象数组，记录在线用户
 */
var users = new Array();
io.on('connection', function(socket){
	var socketid = socket.id;
	console.log('socket connection');
	socket.on('newUser', function(data){
		var flag = true;
		console.log('尝试新增用户' + data);
		for (var i = 0; i < users.length; i ++) {
			if (users[i].userId == data) {
				flag = false;
				break;
			}
		}
		if (flag) {
			var nodeUser = {};
			nodeUser.userId = data; //用户id
			nodeUser.scId = socketid;
			users.push(nodeUser);
			console.log('新增了上线用户' + data);
			//看下redis里面有没有它得未读消息，如果有就发送给他
			redis_client.hget("chat_history", data, function (e, v) {
				var list = [];
        		if (v) {
            		list = JSON.parse(v);
        			socket.emit('receive', list);
        			//发送成功之后删除该条消息
        			redis_client.hdel("chat_history", data, function(e, r){});
        		}
			});
		}
		socket.emit('socketId', socketid);
	});

	socket.on('message', function(data){ // msg from to
		//发送消息
		var toscocketid;
		var fromuserid;
		var time = new Date();
		data["sendtime"] = time.getTime();

		for (var i = 0; i < users.length; i ++) {
			if (users[i].userId == data.touserId) {
				toscocketid = users[i].scId;
				console.log(data.fromscId + '要给' + data.touserId + '发送消息：' + data.msg);
				socket.to(toscocketid).emit('receive_one', [{
					msg: data.msg,
					fromuserId: data.fromuserId,
					fromuserName: data.fromuserName,
					touserId: data.touserId,
					touserName: data.touserName,
					sendtime: data.sendtime + ''
				}]);
				break;
			}
			if (users[i].scId == data[1]) {
				fromuserid = users[i].userId;
			}
		}
		if (!toscocketid) {
			//该用户不在线，将消息存入redis中，上线之后再发出(接受者的userid, 信息，发送人的userid, )
			console.log(data.touserId + ',' + data.msg + ',' + data.fromuserId + ',' + data.fromuserName);
			saveOfflineMsg(data);
		}
	});
	socket.on('disconnect', function(){
		for (var i = 0; i < users.length; i ++) {
			if (users[i].scId == socketid) {
				users.splice(i,1);
				break;
			}
		}
	});
});

function saveOfflineMsg(msg) {
	var list = []
    redis_client.hget("chat_history", msg.touserId, function (e, v) {
        if (v) {
            list = JSON.parse(v);
        }
        list.push(msg);
        console.log('未读消息存进redis-----');
        console.log(list);
        var msglist = JSON.stringify(list);
        redis_client.hset("chat_history", msg.touserId, msglist, function (e, r) {
        	console.log(r);
        });
    });
}



