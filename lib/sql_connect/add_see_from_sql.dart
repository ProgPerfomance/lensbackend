import 'package:mysql_client/mysql_client.dart';

Future<List> addOrderSee(String id) async {
  List orders = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM orders WHERE id = $id",
    {},
  );
  var sees = int.parse(response.rows.first.assoc()['sees'].toString());
  await sql.execute(
    "update orders set sees=${sees+1} WHERE id = $id",
    {},
  );

  await sql.close();
  return orders;
}
