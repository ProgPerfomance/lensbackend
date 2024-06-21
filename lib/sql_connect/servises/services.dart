import 'package:mysql_client/mysql_client.dart';

Future<List> getAllServicesByCategory(categoryName) async {
  List services = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM servises where category_name = '$categoryName'",
    {},
  );

  for (final row in response.rows) {
    var data = row.assoc();
    final freelancer = await sql.execute('SELECT * from users where id = ${data['uid']}');
    final freelancerData = freelancer.rows.first.assoc();
    services.add(
      {
        'id': data['id'],
        'uid': data['uid'],
        'name': data['name'],
        'category_id': data['category_id'],
        'category_name': data['category_name'],
        'description': data['description'],
        'price_min': data['price_min'],
        'price_max': data['price_max'],
        'time': data['time'],
        'monday': data['monday'],
        'tuesday': data['tuesday'],
        'wednesday': data['wednesday'],
        'thursday': data['thursday'],
        'friday': data['friday'],
        'saturday': data['saturday'],
        'sunday': data['sunday'],
        'fixPrice': data['fix_price'],
        'hourPrice': data['hour_price'],
        'freelancer_name':  freelancerData['username'],
        'freelancer_rating': freelancerData['rating'],
        'freelancer_city': freelancerData['city'],
      },
    );
    print(row.assoc());
  }
  await sql.close();
  return List.from(services.reversed);
}


Future<void> archiveService(id) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  await sql.execute('update servises set status = 0 where id = $id');
  await sql.close();
}

Future<void> activateService(id) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  await sql.execute('update servises set status = 1 where id = $id');
  await sql.close();
}
