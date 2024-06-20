import 'package:mysql_client/mysql_client.dart';

Future<List> getMyResponses(String uid) async {
  List orders = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM responseorders where uid = $uid",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    final order = await sql.execute(
      "SELECT * FROM orders WHERE id = ${data['pid']}",
      {},
    );
    order.rows.first.assoc()['freelancer'] == 'null' ?
    orders.add(
      {
        'order_name': order.rows.first.assoc()['name'],
        'order_price_min': order.rows.first.assoc()['price_min'],
        'order_price_max': order.rows.first.assoc()['price_max'],
        'order_address': order.rows.first.assoc()['city'],
        'order_category': order.rows.first.assoc()['category'],
        'order_date_and_time': order.rows.first.assoc()['date_and_time'],
        'id': data['id'],
        'pid': data['pid'],
        'comment': data['comment'],
        'price': data['price'],
        'date_time': data['date_and_time'],
      },
    ) : null;
  }
  await sql.close();
  return List.from(orders.reversed);
}

Future<void> deleteMyResponse(pid) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  await sql.execute(
      "delete from responseorders where id =$pid;");
  await sql.close();
}