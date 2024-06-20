import 'package:mysql_client/mysql_client.dart';

Future<void> createReponseFromSQL({
  required var pid,
  required var uid,
  required var price,
  required var comment,
  required var date_and_time,
  required var timestamp,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  var resul = await sql.execute(
    "SELECT * FROM  responseorders",
    {},
  );
  String id = resul.rows.last.assoc()['id'].toString();
  int id_int = int.parse(id);
  sql.execute(
      "insert into responseorders (id, pid, uid, price, comment, date_and_time, timestamp) values (${id_int + 1}, $pid, $uid, $price, '$comment', '$date_and_time', '$timestamp')");
  await sql.close();
}
