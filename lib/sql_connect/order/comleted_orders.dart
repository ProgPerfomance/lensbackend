import 'package:mysql_client/mysql_client.dart';

Future<List> getCompleteOrders(String uid) async {
  List orders = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM responseorders where uid = $uid",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    try {
      final order = await sql.execute(
        "SELECT * FROM orders WHERE id = ${data['pid']} and order_status = 'closed' and freelancer = $uid",
      );
      orders.add(
        {
          'order_name': order.rows.first.assoc()['name'],
          'order_uid': order.rows.first.assoc()['uid'],
          'order_price_min': order.rows.first.assoc()['price_min'],
          'order_price_max': order.rows.first.assoc()['price_max'],
          'order_address': order.rows.first.assoc()['city'],
          'order_category': order.rows.first.assoc()['category'],
          'order_date_and_time': order.rows.first.assoc()['date_and_time'],
          'freelancer_approve': order.rows.first.assoc()['approve_freelancer'],
          'customer_approve': order.rows.first.assoc()['approve_customer'],
          'review_customer': order.rows.first.assoc()['review_customer'],
          'review_freelancer':order.rows.first.assoc()['review_freelancer'],
          'id': data['id'],
          'pid': data['pid'],
          'comment': data['comment'],
          'price': data['price'],
          'date_time': data['date_and_time'],
        },
      );
    }catch (e){}
  }
  await sql.close();
  return List.from(orders.reversed);
}
