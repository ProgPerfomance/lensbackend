import 'package:mysql_client/mysql_client.dart';

Future<void> createOrderFromSQL({
  required var id,
  required var uid,
  required var name,
  required var ccid,
  required var timestamp,
  required var category,
  required var category_sup,
  required var date_and_time,
  required var geo_x,
  required var geo_y,
  required var geo_del_x,
  required var geo_del_y,
  required var price_min,
  required var price_max,
  required var address,
  required var wishes,
  required var img1,
  required var img2,
  required var img3,
  required var img4,
  required var img5,
  required var img6,
  required var img7,
  required var img8,
  required var img9,
  required var img10,
  required var description,
  required var username,
  required var order_status,
  required var email,
  required var city,
  required var sees,
  required var remotely,
  required var categoryId,
  required var fix_price,
  required var not_price,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'profi');
  await sql.connect();
  var resul = await sql.execute(
    "SELECT * FROM orders",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  sql.execute(
      "insert into orders (id, description, uid, name, timestamp, category, category_sup, date_and_time, geo_x, get_y, geo_del_x, del_del_y, price_min, price_max, wishes, username, order_status, email, city, sees, remotely, category_id, fix_price, not_price, ccid, address) values (${id_int + 1}, '$description', $uid, '$name', '$timestamp', '$category', '$category_sup', '$date_and_time', $geo_x, $geo_y, $geo_del_x, $geo_del_y, $price_min, $price_max, '$wishes', '$username', '$order_status', '$email', '$city', 0, $remotely, $categoryId, $fix_price, $not_price, '$ccid', '$address')");
  // var result = sql.execute("insert into usertable (1, uid, name, timestamp, category, category_sup, date_and_time, geo_x, geo_y, geo_del_x, geo_del_y, price_min, price_max, wishes, username, order_status, email, city, sees, remotely) values ()");
  await sql.close();
}
