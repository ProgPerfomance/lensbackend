import 'package:mysql_client/mysql_client.dart';

Future<List> getMessagesFromSQL(
  cid,
) async {
  List messages = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM messages where chat_id = $cid",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    messages.add(
      {
        'id': data['id'],
        'chat_id': data['chat_id'],
        'uid': data['uid'],
        'msg_text': data['msg_text'],
        'creates_at': data['creates_at']
      },
    );
  }
  sql.close();
  return messages;
}
