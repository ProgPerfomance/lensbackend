import 'package:mysql_client/mysql_client.dart';

Future<List> getResponsesFromOrders(pid) async {
  List responses = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM responseorders WHERE pid = $pid",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    final freelancer = await sql.execute(
      "SELECT * FROM users WHERE id = ${data['uid']}",
      {},
    );
    responses.add(
      {
       'id': data['id'],
        'uid': data['uid'],
        'pid': data['pid'],
        'comment': data['comment'],
        'price': data['price'],
        'date_and_time': data['date_and_time'],
        'timestamp': data['timestamp'],
       'freelancer_name': freelancer.rows.first.assoc()['username'],
      },
    );
  }
  await sql.close();
  return responses;
}
