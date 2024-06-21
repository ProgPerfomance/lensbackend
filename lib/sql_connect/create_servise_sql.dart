import 'package:mysql_client/mysql_client.dart';

Future<void> createServiceFromSQL({
  required var uid,
  required var name,
  required var category_id,
  required var global_category,
  required category_name,
  required description,
  required price_min,
  required time,
  required monday,
  required tuesday,
  required wednesday,
  required thursday,
  required friday,
  required saturday,
  required sunday,
  required fixPrice,
  required hourPrice,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  print(sql.connected);
  var resul = await sql.execute(
    "SELECT * FROM servises",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  print(id_int);
  await sql.execute(
      "insert into servises (id, uid, name, description, price_min, time,category_name, monday,tuesday,wednesday,thursday,friday,saturday,sunday,fix_price, hour_price) values (${id_int + 1}, $uid, '$name', '$description', $price_min, $time, '$category_name', $monday, $tuesday,$wednesday, $thursday, $friday, $saturday,$sunday,$fixPrice,$hourPrice)");
  await sql.close();
}

Future<List> getMyServices(String uid) async {
  List services = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM servises where uid = $uid",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    final freelancer =
        await sql.execute('SELECT * from users where id = ${data['uid']}');
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
        'freelancer_name': freelancerData['username'],
        'freelancer_rating': freelancerData['rating'],
        'freelancer_city': freelancerData['city'],
      },
    );
    print(row.assoc());
  }
  await sql.close();
  return List.from(services.reversed);
}

Future<List> getMyServicesShortList(String uid) async {
  List services = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM servises where uid = $uid",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    services.add(
      {
        'id': data['id'],
        'uid': data['uid'],
        'name': data['name'],
        'price_min': data['price_min'],
        'fixPrice': data['fix_price'],
        'hourPrice': data['hour_price'],
      },
    );
  }
  await sql.close();
  return List.from(services.reversed);
}


Future<List> getMyArchiveServices(String uid) async {
  List services = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM servises where uid = $uid and status = 0",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    final freelancer =
    await sql.execute('SELECT * from users where id = ${data['uid']}');
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
        'freelancer_name': freelancerData['username'],
        'freelancer_rating': freelancerData['rating'],
        'freelancer_city': freelancerData['city'],
      },
    );
    print(row.assoc());
  }
  await sql.close();
  return List.from(services.reversed);
}
Future<List> getAllServices({
  required priceMin,
  required priceMax,
  required ratingMin,
  required category,
  required str,
  required city,
}) async {
  List services = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  var response;
  if (str == '') {
    response = category == 'no' &&
        priceMax == '9999999' &&
        priceMin == '0' &&
        ratingMin == '0' && city == 'no'
        ? await sql.execute("SELECT * FROM servises where status = 1")
        : category == 'no'
        ? await sql.execute(
      "SELECT * FROM servises where price_min > $priceMin and price_min < $priceMax and status = 1",
    )
        : await sql.execute(
      "SELECT * FROM servises where price_min > $priceMin and price_min < $priceMax and category_name = '$category' and status = 1",
    );
  } else {
    response = category == 'no' &&
        priceMax == '9999999' &&
        priceMin == '0' &&
        ratingMin == '0'&& city == 'no'
        ? await sql.execute("SELECT * FROM servises")
        : category == 'no'
        ? await sql.execute(
      "SELECT * FROM servises where price_min > $priceMin and price_min < $priceMax and lower(name) = '${str.toString().toLowerCase()}' and status = 1",
    )
        : await sql.execute(
      "SELECT * FROM servises where price_min > $priceMin and price_min < $priceMax and category_name = '$category' and lower(name) = '${str.toString().toLowerCase()}'and status = 1",
    );
  }
  for (final row in response.rows) {
    print(response.rows.length);
    var data = row.assoc();
    try {
      if(city == 'no') {
        final freelancer = await sql.execute(
            'SELECT * from users where id = ${data['uid']} and rating > $ratingMin');
        final reviews =
        await sql.execute('SELECT * from reviews where uid = ${data['uid']}');
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
            'freelancer_name': freelancerData['username'],
            'freelancer_rating': freelancerData['rating'],
            'freelancer_city': freelancerData['city'],
            'reviews': reviews.rows.length,
          },
        );
      }
      else {
        final freelancer = await sql.execute(
            "SELECT * from users where id = ${data['uid']} and rating > $ratingMin and city = '$city'");
        final reviews =
        await sql.execute('SELECT * from reviews where uid = ${data['uid']}');
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
            'freelancer_name': freelancerData['username'],
            'freelancer_rating': freelancerData['rating'],
            'freelancer_city': freelancerData['city'],
            'reviews': reviews.rows.length,
          },
        );
      }
      print(services.length);
    } catch (_) {}
  }
  await sql.close();
  return List.from(services.reversed);
}
