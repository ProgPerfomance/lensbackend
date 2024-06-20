import 'package:mysql_client/mysql_client.dart';

Future<List> getUserChats({
  required uid,
}) async {
  List chats = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM chats where uid1 = $uid or uid2 = $uid",
    {},
  );


  for (final row in response.rows) {
    var data = row.assoc();
    var subject;
    if(data['type'] == '0') {
      subject = await sql.execute(
        "SELECT * FROM orders where id = ${data['chat_subject']}",
        {},
      );
    }
    else {
      subject = await sql.execute(
        "SELECT * FROM ads where id = ${data['chat_subject']}",
        {},
      );
    }
    final user = await sql.execute(
      "SELECT * FROM users where id = ${data['uid1'] != uid.toString() ? data['uid1'] : data['uid2']}",
      {},
    );
    var lastMessage;
    var lastMessageId;
    var creates_at;
    try {
      final message = await sql.execute(
        "SELECT * FROM messages where chat_id = ${data['id']}");
      lastMessage = message.rows.last.assoc()['msg_text'];
      lastMessageId = message.rows.last.assoc()['id'];
      creates_at = message.rows.last.assoc()['creates_at'];
      }catch (e) {
      lastMessage= '';
      lastMessageId =0;
      creates_at = '';
    }
    chats.add(
      {
        'cid': data['id'],
        'type': data['type'],
        'uid_opponent': data['uid1'] != uid.toString() ? data['uid1'] : data['uid2'],
        'opponent_name': user.rows.first.assoc()['username'],
        'avatar': data['uid2'],
        'chat_subject': data['chat_subject'],
        'subject_name': data['type'] == '0' ?subject.rows.first.assoc()['name'] : subject.rows.first.assoc()['age'],
        'chat_timestamp': data['chat_timestamp'],
        'last_message': lastMessage,
        'last_messate_time': creates_at,
        'message_id': int.parse(lastMessageId.toString()),
      },
    );
  }
  chats.sort((a, b) => (b['message_id'] ?? 0).compareTo(a['message_id'] ?? 0));
  sql.close();
  print(chats);
  return chats;
}


Future<List> getChatFromCid({
  required uid,
}) async {
  List chats = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM chats where uid1 = $uid or uid2 = $uid",
    {},
  );


  for (final row in response.rows) {
    var data = row.assoc();
    var subject = await sql.execute(
      "SELECT * FROM orders where id = ${data['chat_subject']}",
      {},
    );
    final user = await sql.execute(
      "SELECT * FROM users where id = ${data['uid1'] != uid ? data['uid1'] : data['uid2']}",
      {},
    );
    chats.add(
      {
        'cid': data['id'],
        'uid_opponent': data['uid1'] != uid ? data['uid1'] : data['uid2'],
        'opponent_name': user.rows.first.assoc()['name'],
        'avatar': data['uid2'],
        'chat_subject': data['chat_subject'],
        'subject_name': subject.rows.first.assoc()['name'],
        'chat_timestamp': data['chat_timestamp'],
        'last_message': data['last_message'],
      },
    );
  }
  sql.close();
  return chats;
}
