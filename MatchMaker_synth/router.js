function route(client,handle,pathname,response) {
	if (typeof handle[pathname] === 'function') {
		handle[pathname](client, response);//执行对应函数
	}else{
		response.write('404 NOt Found');
		response.end();
	}

}
exports.route = route;