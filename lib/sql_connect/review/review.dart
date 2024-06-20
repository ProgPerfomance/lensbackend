import 'dart:math';

import 'package:mysql_client/mysql_client.dart';

Future<void> createReviewFreelancer({
  required var pid,
  required var uid,
  required var rating,
  required var comment,
  required var timestamp,
  required var sender_uid,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  var resul = await sql.execute(
    "SELECT * FROM  reviews",
    {},
  );
  int reviewsSum = 0;
  for(var item in resul.rows) {
    reviewsSum += int.parse(item.assoc()['rating']!);
  }
  double newRating = reviewsSum / resul.length;
  print('new rating: $newRating');
  String id = resul.rows.last.assoc()['id'].toString();
  int id_int = int.parse(id);
 await sql.execute("update orders set review_freelancer = 1 where id = $pid");
 await sql.execute(
      "insert into reviews (id, uid, pid, rating, comment,timestamp, sender_uid) values (${id_int + 1}, $uid, $pid, $rating, '$comment', '$timestamp',$sender_uid)");
  await sql.close();
}

Future<void> createReviewCustomer({
  required var pid,
  required var uid,
  required var rating,
  required var comment,
  required var timestamp,
  required var sender_uid,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  var resul = await sql.execute(
    "SELECT * FROM reviews",
    {},
  );
  int reviewsSum = 0;
  for(var item in resul.rows) {
    reviewsSum += int.parse(item.assoc()['rating']!);
  }
  double newRating = reviewsSum / resul.length;
  print('new rating: $newRating');
  String id = resul.rows.last.assoc()['id'].toString();
  int id_int = int.parse(id);
 await sql.execute("update orders set review_customer = 1 where id = $pid");
  await sql.execute(
      "insert into reviews (id, uid, pid, rating, comment,timestamp,sender_uid) values (${id_int + 1}, $uid, $pid, $rating, '$comment', '$timestamp',$sender_uid)");
  await sql.close();
}



Future<List> getMyReviews(String uid) async {
  List reviews = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM reviews where uid = $uid",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    final order = await sql.execute(
      "SELECT * FROM orders WHERE id = ${data['pid']}",
      {},
    );
    final user = await sql.execute(
      "SELECT * FROM users WHERE id = ${data['sender_uid']}",
      {},
    );
    reviews.add(
      {
        'order_name': order.rows.first.assoc()['name'],
        'order_category': order.rows.first.assoc()['category'],
        'id': data['id'],
        'pid': data['pid'],
        'comment': data['comment'],
        'rating': data['rating'],
        'timestamp': data['timestamp'],
        'sender_name': user.rows.first.assoc()['username'],
        'sender_id': user.rows.first.assoc()['id'],
      },
    );
  }
  await sql.close();
  return List.from(reviews.reversed);
}


Future<Map> getReviewsFromId(String uid, String pid) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM reviews where uid = $uid and pid=$pid",
    {},
  );

    var data = response.rows.first.assoc();
  var  review =
      {
        'id': data['id'],
        'pid': data['pid'],
        'comment': data['comment'],
        'rating': data['rating'],
        'timestamp': data['timestamp'],
      };
  await sql.close();
  return review;
}

