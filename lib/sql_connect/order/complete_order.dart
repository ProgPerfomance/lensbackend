import 'package:mysql_client/mysql_client.dart';

Future<void> completeOrderFreelancer({required id}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  await sql.execute("update orders set approve_freelancer = 1 where id=$id");
  final response = await sql.execute('select * from orders where id=$id');
  response.rows.first.assoc()['approve_customer'] == '1' ||
          response.rows.first.assoc()['approve_customer'] == 1
      ? sql.execute("update orders set order_status='closed' where id=$id")
      : null;
  await sql.close();
}

Future<void> completeOrderCustomer({required id}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  await sql.execute("update orders set approve_customer = 1 where id=$id");
  final response = await sql.execute('select * from orders where id=$id');
  response.rows.first.assoc()['approve_freelancer'] == '1' ||
          response.rows.first.assoc()['approve_customer'] == 1
      ? sql.execute("update orders set order_status='closed' where id=$id")
      : null;
  await sql.close();
}
