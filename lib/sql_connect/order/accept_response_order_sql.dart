
import 'package:mysql_client/mysql_client.dart';

Future<void> acceptResponse({
  required var pid,
  required var uid,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  await sql.execute("update orders set freelancer = $uid, order_status = 'worked'  where id = $pid");
  await sql.close();
}

Future<void> deleteMyOrder(pid) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  await sql.execute(
      "delete from orders where id =$pid;");
  await sql.close();
}