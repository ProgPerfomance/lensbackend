import 'package:mysql_client/mysql_client.dart';

Future<void> createMessageFromSQL(
{required cid, required uid, required msg}
    ) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  var resul = await sql.execute(
    "SELECT * FROM messages",
    {},
  );

  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  var result = await sql.execute(
      "insert into messages (id, chat_id, uid, msg_text, creates_at, updated_at, is_seen) values (${id_int+1}, $cid, $uid, '$msg', '${DateTime.now()}', '', false)");
  await sql.close();
}