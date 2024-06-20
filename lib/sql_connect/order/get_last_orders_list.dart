import 'dart:io';

import 'package:lens_backend/sql_connect/order/get_responses_from_order_from_sql.dart';
import 'package:mysql_client/mysql_client.dart';


Future<List> getLastOrdes() async {
  List orders = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM orders where order_status = 'active'",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    List responsesList = [];
    try {
      final responses = await sql.execute('select * from responseorders where pid=${data['id']}');
      for(var item in responses.rows) {
        responsesList.add({
          'uid': item.assoc()['uid'],
        });
      }
    } catch(e){

    }
    Directory directory = Directory('images/${data['ccid']}');
    orders.add(
      {
        'description': data['description'],
        'name': data['name'],
        'uid': data['uid'],
        'id': data['id'],
        'geo_x': data['geo_x'],
        'geo_y': data['get_y'],
        'fix_price': data['fix_price'],
        'not_price': data['not_price'],
        'category': data['category'],
        'price_min': data['price_min'],
        'price_max': data['price_max'],
        'address': data['address'],
        'wishes': data['wishes'],
        'username': data['username'],
        'order_status': data['order_status'],
        'email': data['email'],
        'sees': data['sees'],
        'date_and_time':data['date_and_time'],
        'ccid': data['ccid'],
        'freelancer': data['freelancer'],
        'remotely': data['remotely'],
        'city': data['city'],
        'images': directory.listSync().length,
        'responses': responsesList,
      },
    );
  }
  await sql.close();
  orders = List.from(orders.reversed);
  return orders;
}

Future<List> getUserActiveOrders(uid) async {
  List orders = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM orders WHERE uid = $uid and order_status = 'active' or uid = $uid and order_status = 'worked';",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    int pid = int.parse(data['id'] as String);
    var freelancerName;
    if (data['freelancer'] != null && data['freelancer'] != 'null') {
      final user = await sql.execute(
        "SELECT * FROM users WHERE id = ${data['freelancer']}",
        {},
      );
      freelancerName = await user.rows.first.assoc()['username'];
    }
    orders.add(
      {
        'name': data['name'],
        'uid': data['uid'],
        'id': data['id'],
        'geo_x': data['geo_x'],
        'geo_y': data['get_y'],
        'category': data['category'],
        'price_min': data['price_min'],
        'price_max': data['price_max'],
        'wishes': data['wishes'],
        'username': data['username'],
        'fix_price': data['fix_price'],
        'not_price': data['not_price'],
        'order_status': data['order_status'],
        'date_and_time':data['date_and_time'],
        'email': data['email'],
        'sees': data['sees'],
        'description': data['description'],
        'remotely': data['remotely'],
        'city': data['city'],
        'address': data['address'],
        'freelancer': data['freelancer'],
        'review_freelancer': data['review_freelancer'],
        'review_customer': data['review_customer'],
        'freelancer_name': freelancerName,
        'responses': await getResponsesFromOrders(pid),
      },
    );
  }
  await sql.close();
  orders = List.from(orders.reversed);
  return orders;
}

Future<List> getUserArchiveOrders(uid) async {
  List orders = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM orders WHERE uid = $uid and order_status = 'closed'",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    int pid = int.parse(data['id'] as String);
    var freelancerName;
    if (data['freelancer'] != null && data['freelancer'] != 'null') {
      final user = await sql.execute(
        "SELECT * FROM users WHERE id = ${data['freelancer']}",
        {},
      );
      freelancerName = await user.rows.first.assoc()['username'];
    }
    orders.add(
      {
        'name': data['name'],
        'uid': data['uid'],
        'description': data['description'],
        'id': data['id'],
        'geo_x': data['geo_x'],
        'geo_y': data['get_y'],
        'category': data['category'],
        'price_min': data['price_min'],
        'fix_price': data['fix_price'],
        'address': data['address'],
        'not_price': data['not_price'],
        'price_max': data['price_max'],
        'wishes': data['wishes'],
        'username': data['username'],
        'order_status': data['order_status'],
        'date_and_time':data['date_and_time'],
        'email': data['email'],
        'review_freelancer': data['review_freelancer'],
        'review_customer': data['review_customer'],
        'sees': data['sees'],
        'remotely': data['remotely'],
        'city': data['city'],
        'freelancer': data['freelancer'],
        'freelancer_name': freelancerName,
        'responses': await getResponsesFromOrders(pid),
      },
    );
  }
  await sql.close();
  orders = List.from(orders.reversed);
  return orders;
}


Future<List> getWorkOrders(String uid) async {
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
        "SELECT * FROM orders WHERE id = ${data['pid']} and order_status = 'worked'",
        {},
      );
      print('work orders');
      orders.add(
        {
          'order_name': order.rows.first.assoc()['name'],
          'order_price_min': order.rows.first.assoc()['price_min'],
          'order_price_max': order.rows.first.assoc()['price_max'],
          'order_address': order.rows.first.assoc()['city'],
          'order_category': order.rows.first.assoc()['category'],
          'order_date_and_time': order.rows.first.assoc()['date_and_time'],
          'freelancer_approve': order.rows.first.assoc()['approve_freelancer'],
          'customer_approve': order.rows.first.assoc()['approve_customer'],
          'id': data['id'],
          'pid': data['pid'],
          'comment': data['comment'],
          'price': data['price'],
          'date_time': data['date_and_time'],
        },
      );
    } catch(e){}
  }
  print('work orders: $orders');
  await sql.close();
  return List.from(orders.reversed);
}


Future<Map> getOrderInfo(id) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute("SELECT * FROM orders WHERE id = $id");
  var data = response.rows.first.assoc();
  var freelancerName;
  if (data['freelancer'] != null && data['freelancer'] != 'null') {
    final user = await sql.execute(
      "SELECT * FROM users WHERE id = ${data['freelancer']}",
      {},
    );
    freelancerName = await user.rows.first.assoc()['username'];
  }
  var dataMap = await {
    'name': data['name'],
    'uid': data['uid'],
    'description': data['description'],
    'id': data['id'],
    'geo_x': data['geo_x'],
    'geo_y': data['geo_y'],
    'category': data['category'],
    'price_min': data['price_min'],
    'fix_price': data['fix_price'],
    'address': data['address'],
    'not_price': data['not_price'],
    'price_max': data['price_max'],
    'wishes': data['wishes'],
    'username': data['username'],
    'order_status': data['order_status'],
    'date_and_time':data['date_and_time'],
    'email': data['email'],
    'review_freelancer': data['review_freelancer'],
    'review_customer': data['review_customer'],
    'sees': data['sees'],
    'remotely': data['remotely'],
    'city': data['city'],
    'freelancer': data['freelancer'],
    'freelancer_name': freelancerName,
    'responses': await getResponsesFromOrders(id),
  };
  await sql.close();
  return dataMap;
}


Future<List> getOrdersFromGlobalCategory(id) async {
  List orders = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM orders where order_status = 'active' and category_id=$id",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    Directory directory = Directory('images/${data['ccid']}');
    orders.add(
      {
        'description': data['description'],
        'name': data['name'],
        'uid': data['uid'],
        'id': data['id'],
        'geo_x': data['geo_x'],
        'geo_y': data['get_y'],
        'fix_price': data['fix_price'],
        'not_price': data['not_price'],
        'category': data['category'],
        'price_min': data['price_min'],
        'price_max': data['price_max'],
        'address': data['address'],
        'wishes': data['wishes'],
        'username': data['username'],
        'order_status': data['order_status'],
        'email': data['email'],
        'sees': data['sees'],
        'date_and_time':data['date_and_time'],
        'ccid': data['ccid'],
        'freelancer': data['freelancer'],
        'remotely': data['remotely'],
        'city': data['city'],
        'images': directory.listSync().length,
      },
    );
  }
  await sql.close();
  orders = List.from(orders.reversed);
  return orders;
}


//SOLID

//S -  оси
//О - си
//L - ожись