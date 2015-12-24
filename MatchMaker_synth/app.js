var restify = require('restify');
var server = restify.createServer();
var pg = require('pg');
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

//socket
/*
	用户对象数组，记录在线用户
 */
var users = new Array();


io.on('connection', function(socket){
	var socketid = socket.id;
	
	socket.on('newUser', function(data){
		var flag = true;
		console.log('尝试新增用户' + data);
		for (var i = 0; i < users.length; i ++) {
			if (users[i].userId == data) {
				flag = false;
			}
		}
		if (flag) {
			var nodeUser = {};
			nodeUser.userId = data; //用户id
			nodeUser.scId = socketid;
			users.push(nodeUser);
			console.log('新增了上线用户' + data);
		}
		socket.emit('socketId', socketid);
	});

	socket.on('message', function(data){ // msg from to
		//发送消息
		var toscocketid;
		for (var i = 0; i < users.length; i ++) {
			if (users[i].userId == data[2]) {
				toscocketid = users[i].scId;
				console.log(data[1] + '要给' + data[2] + '发送消息：' + data[0]);
				socket.to(toscocketid).emit('receive', data[0]);
			}
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
	// socket.on('testtt', function(data){
	// 	console.log(data);
	// });
	// socket.emit('receive', ['peach','hello']);
});



