function login(phone, password, client, response) {
	var sql = "select * from mmuser where phone = '" + phone + "'  and password = '" + password + "';";
	client.query(sql, function(err, result){
		if(err) {
			console.log(err);
			response.write(404,err);
			client.end();
			return;
		}
		console.log(result.rows);
		response.send(200, result.rows);
		next();
	})
}

function getFriends(id, client, response) {
	var sql = "SELECT userid, name, ava, sex from mmuser WHERE userid in (select userid from friend where friendid = "+ id +" union select friendid from friend where userid = "+ id + ")"
	client.query(sql, function(err, result){
		if(err) {
			console.log(err);
			response.write(404,err);
			client.end();
			return;
		}
		console.log(result.rows);
		response.send(200, result.rows);
		next();
	})
}
exports.login = login;
exports.getFriends = getFriends;