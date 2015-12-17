var restify = require('restify');
var pg = require('pg');
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
var server = restify.createServer();
server.use(restify.queryParser());
server.use(restify.bodyParser());
server.use(restify.CORS());

server.post('/login', login);
server.post('/getFriends', getFriends);

server.listen(3008, function() {
  console.log('%s listening at %s', server.name, server.url);
});