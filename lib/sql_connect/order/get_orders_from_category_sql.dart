

import 'package:mysql_client/mysql_client.dart';

Future<List> getOrdersFromCategorySQl(category) async {
  List sortorders = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM orders where category_sup = $category",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    sortorders.add(
      {
        'name': data['name'],
        'uid': data['uid'],
        'id': data['id'],
        'fix_price': data['fix_price'],
        'not_price': data['not_price'],
        'date_and_time':data['date_and_time'],
        'category': data['category'],
        'price_min': data['price_min'],
        'price_max': data['price_max'],
        'wishes': data['wishes'],
        'username': data['usename'],
        'order_status': data['order_status'],
        'email': data['email'],
        'sees': data['sees'],
        'remotely': data['remotely'],
        'city': data['city']
      },
    );
  }
  await sql.close();
  return sortorders;
}

