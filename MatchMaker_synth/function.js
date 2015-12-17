function select(client, response) {
	console.log('select was called');
	//执行相应的sql语句
	client.query("select * from mmuser;", function(error, results){
		if(error) {
			console.log('getdata error' + error.message);
			client.end();
			return;
		}
		if(results.rowCount > 0) {
			console.log(results);
			response.write(JSON.stringify(results));
			response.end();
		}
	});
}
exports.select = select;