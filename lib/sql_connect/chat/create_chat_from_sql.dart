import 'package:mysql_client/mysql_client.dart';

Future<int> createChat({
  required uid1,
  required uid2,
  required chatSubject,
  required type,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  var resul = await sql.execute(
    "SELECT * FROM chats",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  var result = await sql.execute("insert into chats (id, uid1, uid2, chat_subject, chat_timestamp, type) values (${id_int+1}, $uid1, $uid2, $chatSubject, '${DateTime.now()}', $type)");
  sql.close();
  return id_int+1;
}
