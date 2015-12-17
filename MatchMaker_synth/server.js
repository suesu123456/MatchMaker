var http = require("http");
var url = require("url");

function start(client, route, handle) {
	//创建Http服务器
	http.createServer(function(request, response){
		var pathname = url.parse(request.url).pathname;
		route(client,handle,pathname,response);
	}).listen(3008);
	console.log('server启动');
}