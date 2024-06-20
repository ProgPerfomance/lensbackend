import 'package:mysql_client/mysql_client.dart';

Future<void> bookService({
  required uid,
  required sid,
  required date,
  required description,
  required freelancerId,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
    int idInt;
  try {
    var resul = await sql.execute(
      "SELECT * FROM  service_request",
      {},
    );
    String id = resul.rows.last.assoc()['id'].toString();
    idInt = int.parse(id);
  }
  catch (e) {
    idInt = 0;
  }

  await sql.execute("insert into service_request (id, uid, sid, date, description, freelancer_id) values (${idInt+1}, $uid, $sid, '$date', '$description', $freelancerId)");
  await sql.close();
}

Future<List> getFreelancerBooking(uid) async{
  List booking = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
 final dataRow = await sql.execute("select * from service_request where freelancer_id = $uid");
 for(var item in dataRow.rows) {
   var data = item.assoc();
   final customerRow = await sql.execute("select * from users where id = ${data['uid']}");
   final serviceRow = await sql.execute("select * from servises where id = ${data['sid']}");
   booking.add({
     'id': data['id'],
     'uid': data['uid'],
     'sid': data['sid'],
     'service_name': serviceRow.rows.first.assoc()['name'],
     'service_category': serviceRow.rows.first.assoc()['category_name'],
     'customer_name': customerRow.rows.first.assoc()['username'],
     'customer_rating': customerRow.rows.first.assoc()['rating'],
     'date': data['date'],
     'status': data['status'],
     'description': data['description'],
   });
 }
  return List.from(booking.reversed);
}

Future<List> getCustomerBooking(uid) async{
  List booking = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  final dataRow = await sql.execute("select * from service_request where uid = $uid");
  for(var item in dataRow.rows) {
    var data = item.assoc();
   // final freelancerRow = await sql.execute("select * from users where id = ${data['uid']}");
    final serviceRow = await sql.execute("select * from servises where id = ${data['sid']}");
    booking.add({
      'id': data['id'],
      'uid': data['uid'],
      'sid': data['sid'],
      'service_name': serviceRow.rows.first.assoc()['name'],
      'service_category': serviceRow.rows.first.assoc()['category_name'],
      // 'customer_name': freelancerRow.rows.first.assoc()['username'],
      // 'customer_rating': freelancerRow.rows.first.assoc()['rating'],
      'date': data['date'],
      'status': data['status'],
      'description': data['description'],
    });
  }
  return List.from(booking.reversed);
}