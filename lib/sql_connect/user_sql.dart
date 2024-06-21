import 'dart:developer';

import 'package:mysql_client/mysql_client.dart';
import 'package:uuid/uuid.dart';

Future<String> checkUserUUID(uuid) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response =
      await sql.execute("SELECT * FROM users where uuid = '$uuid}");
  try {
    String a = response.rows.first.assoc()['uuid']!;
    return a;
  } catch (e) {
    return 'invalid token';
  }
}

Future<Map<String, dynamic>> authUser(String email, String password) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM users",
    {},
  );
  log('authUser run');
  for (final row in response.rows) {
    var data = row.assoc();
    if (data['email'] == email && data['password_hash'] == password) {
      return {'success': true, 'uid': row.assoc()['id']};
    }
  }
  return {'success': false};
}

Future<int> createUserFromSQL({
  required var name,
  required var email,
  required var age,
  required var freelancer,
  required var last_login,
  required var password_hash,
  required var city,
  required var country,
  required var date_of_burn,
  required var avatar,
  required var spheres,
  required var skills,
  required var education,
  required var experience,
  required var about_me,
  required var client_visiting,
  required var servises,
  required var rating,
  required var reviews,
  required var email_succes,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  var resul = await sql.execute(
    "SELECT * FROM users",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  var uuid = Uuid();
  String uuidString = uuid.v1();
  uuid.v1();
  if(freelancer == true) {
    for(var item in spheres) {
      var count = await sql.execute(
        "SELECT * FROM user_categories",
        {},
      );
      String cot = count.rows.last.assoc()['id'] as String;
      int count_int = int.parse(cot);
      await sql.execute("insert into user_categories (id, uid, cid, name) values (${count_int+1}, ${id_int+1}, 0, '$item')");
    }
  }
  await sql.execute(
      "insert into users (id, username, password_hash, city, email, country, age, freelancer, last_login, date_of_burn, avatar, skills, education, experience, about_me, client_visiting, servises, rating, email_succes, uuid) values (${id_int + 1}, '$name', '$password_hash', '$city', '$email', '$country', $age, $freelancer, '$last_login', '$date_of_burn', '$avatar', '$skills', '$education', '$experience', '$about_me', '$client_visiting', $servises, 4.5, $email_succes, '${uuidString}');");
  await sql.close();
  return
   id_int + 1;

}

Future<Map<String, dynamic>> getUserData(int id) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM users WHERE id = $id",
    {},
  );
  var data = response.rows.first.assoc();
  await sql.close();
  return {
    'uid': data['id'],
    'name': data['username'],
    'email': data['email'],
    'age': data['age'],
    'freelancer': data['freelancer'],
    'last_login': data['last_login'],
    'city': data['city'],
    'country': data['country'],
    'date_of_burn': data['date_of_burn'],
    'avatar': data['avatar'],
    'spheres': data['spheres'],
    'skills': data['skills'],
    'education': data['education'],
    'experience': data['experience'],
    'about_me': data['about_me'],
    'client_visiting': data['client_visiting'],
    'servises': data['servises'],
    'rating': data['rating'],
    'reviews': data['reviews'],
    'email_succes': data['email_succes'],
  };
}

Future<Map<String, dynamic>> getOtherUserData(id) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM users WHERE id = $id",
    {},
  );
  var data = response.rows.first.assoc();
  await sql.close();
  return {
    'uid': data['id'],
    'name': data['username'],
    'age': data['age'],
    'freelancer': data['freelancer'],
    'city': data['city'],
    'skills': data['skills'],
    'education': data['education'],
    'experience': data['experience'],
    'about_me': data['about_me'],
    'client_visiting': data['client_visiting'],
    'rating': data['rating'],
    'email_succes': data['email_succes'],
  };
}

Future<void> updateUserProfile({
  required var uid,
  required name,
  required email,
  required city,
  required category,
  required dateOfBurn,
  required skills,
  required education,
  required experience,
  required aboutMe,
  required clientVisiting,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  var result = await sql.execute(
      "update users set username = '$name', email = '$email',  skills = '$skills',  city = '$city',  education = '$education', experience  = '$experience',  about_me  = '$aboutMe'  where id = $uid");
  await sql.close();
}

Future<Map> updateUserPassword({
  required var uid,
  required var lastPassword,
  required var newPassword,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  var lastPasswordSQL = await sql.execute('select * from users where id=$uid');
 if(lastPasswordSQL.rows.first.assoc()['password_hash'] == lastPassword) {
   var result = await sql.execute(
       "update users set password_hash = '$newPassword' where id = $uid");
   await sql.close();
   return {'success': true};
 }
 else{
   await sql.close();
   return {'success': false};
 }

}


Future<void> setFreelancer ({required uid, required categories}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
 await sql.execute('update users set freelancer = 1 where id=$uid');
await sql.close();

}

Future<void> changeCity(uid, city) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  await sql.execute("update users set city = '$city' where id = $uid");
  await sql.close();
}
