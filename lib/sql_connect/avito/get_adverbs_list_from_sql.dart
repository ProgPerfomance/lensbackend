import 'dart:io';

import 'package:mysql_client/mysql_client.dart';

Future<List> getLastAdverbs() async {
  List adverbs = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  print(sql.connected);
  final response = await sql.execute(
    "SELECT * FROM ads",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    final userRow = await sql.execute('select * from users where id = ${data['uid']}');
    final user = userRow.rows.first.assoc();
    final reviewsRow = await sql.execute('select * from reviews where uid = ${data['uid']}');
    Directory directory = Directory('images/${data['ccid']}');
    adverbs.add(
      {
        'id': data['id'],
        'name': data['name'],
        'uid': data['uid'],
        'timestamp': data['timestamp'],
        'category': data['category'],
        'category_id': data['category_id'],
        'price': data['price'],
        'address': data['address'],
        'description': data['description'],
        'phone': data['phone'],
        'messages': data['messages'],
        'state': data['state'],
        'type': data['type'],
        'ccid': data['ccid'],
        'brand': data['brand'],
        'model': data['model'],
        'color': data['color'],
        'engine': data['engine'],
        'hp': data['hp'],
        'nm': data['nm'],
        'killometrs': data['killometrs'],
        'drive_type': data['drive_type'],
        'transmission': data['transmission'],
        'year': data['year'],
        'engine_volume': data['engine_volume'],
        'engine_cylinders': data['engine_cylinders'],
        'gears': data['gears'],
        'tact_nubmers': data['tact_nubmers'],
        'fuel_supply': data['fuel_supply'],
        'build_type': data['build_type'],
        'order_type': data['order_type'],
        'flour': data['flour'],
        'rights': data['rights'],
        'repair': data['repair'],
        'square': data['square'],
        'cpu': data['cpu'],
        'gpu': data['gpu'],
        'ram': data['ram'],
        'memory_hard': data['memory_hard'],
        'sex': data['sex'],
        'age': data['age'],
        'size': data['size'],
        'screen_size': data['screen_size'],
        'images': directory.listSync().length,
        'user_name': user['username'],
        'user_rating': user['rating'],
        'user_reviews': reviewsRow.length,
      },
    );
  }
  await sql.close();
  return List.from(adverbs.reversed);
}

Future<List> getMyAdverbs(int uid) async {
  List myAdverbs = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  final response = await sql.execute(
    "SELECT * FROM ads where uid = $uid",
    {},
  );
  for (final row in response.rows) {
    var data = row.assoc();
    final userRow = await sql.execute('select * from users where id = ${data['uid']}');
    final user = userRow.rows.first.assoc();
    Directory directory = Directory('images/${data['ccid']}');
    final reviewsRow = await sql.execute('select * from reviews where uid = ${data['uid']}');
    myAdverbs.add(
      {
        'id': data['id'],
        'uid': data['uid'],
        'name': data['name'],
        'timestamp': data['timestamp'],
        'category': data['category'],
        'category_id': data['category_id'],
        'price': data['price'],
        'address': data['address'],
        'description': data['description'],
        'phone': data['phone'],
        'messages': data['messages'],
        'state': data['state'],
        'type': data['type'],
        'brand': data['brand'],
        'model': data['model'],
        'color': data['color'],
        'engine': data['engine'],
        'hp': data['hp'],
        'nm': data['nm'],
        'killometrs': data['killometrs'],
        'drive_type': data['drive_type'],
        'transmission': data['transmission'],
        'year': data['year'],
        'engine_volume': data['engine_volume'],
        'engine_cylinders': data['engine_cylinders'],
        'gears': data['gears'],
        'tact_nubmers': data['tact_nubmers'],
        'fuel_supply': data['fuel_supply'],
        'build_type': data['build_type'],
        'order_type': data['order_type'],
        'flour': data['flour'],
        'ccid': data['ccid'],
        'rights': data['rights'],
        'repair': data['repair'],
        'square': data['square'],
        'cpu': data['cpu'],
        'gpu': data['gpu'],
        'ram': data['ram'],
        'memory_hard': data['memory_hard'],
        'sex': data['sex'],
        'age': data['age'],
        'size': data['size'],
        'screen_size': data['screen_size'],
        'images': directory.listSync().length,
        'user_name': user['username'],
        'user_rating': user['rating'],
        'user_reviews': reviewsRow.length,
      },
    );
  }
  await sql.close();
  return List.from(myAdverbs.reversed);
}
//id, uid,timestamp,category,category_id,price,address,description,phone,messages,state,type,brand,model,color,engine,hp,nm,killometrs,drive_type,transmission,year,engine_volume,engine_cylinders,gears,tact_nubmers,fuel_supply,build_type,order_type,flour,rights,repair,square,cpu,gpu,ram,memory_hard,sex,age,size,screen_size


Future<List> getAdverbsByCategory(category, priceMin, priceMax) async {
  List myAdverbs = [];
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  var response;
  if(category != 'null') {
    response = await sql.execute(
      "SELECT * FROM ads where category = '$category' and price < $priceMax and price > $priceMin",
      {},);
  } else {
    response = await sql.execute(
      "SELECT * FROM ads where price < $priceMax and price > $priceMin",
      {},);
  }
  for (final row in response.rows) {
    var data = row.assoc();
    final userRow = await sql.execute('select * from users where id = ${data['uid']}');
    final user = userRow.rows.first.assoc();
    Directory directory = Directory('images/${data['ccid']}');
    final reviewsRow = await sql.execute('select * from reviews where uid = ${data['uid']}');
    myAdverbs.add(
      {
        'id': data['id'],
        'uid': data['uid'],
        'name': data['name'],
        'timestamp': data['timestamp'],
        'category': data['category'],
        'category_id': data['category_id'],
        'price': data['price'],
        'address': data['address'],
        'description': data['description'],
        'phone': data['phone'],
        'messages': data['messages'],
        'state': data['state'],
        'type': data['type'],
        'brand': data['brand'],
        'model': data['model'],
        'color': data['color'],
        'engine': data['engine'],
        'hp': data['hp'],
        'nm': data['nm'],
        'killometrs': data['killometrs'],
        'drive_type': data['drive_type'],
        'transmission': data['transmission'],
        'year': data['year'],
        'engine_volume': data['engine_volume'],
        'engine_cylinders': data['engine_cylinders'],
        'gears': data['gears'],
        'tact_nubmers': data['tact_nubmers'],
        'fuel_supply': data['fuel_supply'],
        'build_type': data['build_type'],
        'order_type': data['order_type'],
        'flour': data['flour'],
        'ccid': data['ccid'],
        'rights': data['rights'],
        'repair': data['repair'],
        'square': data['square'],
        'cpu': data['cpu'],
        'gpu': data['gpu'],
        'ram': data['ram'],
        'memory_hard': data['memory_hard'],
        'sex': data['sex'],
        'age': data['age'],
        'size': data['size'],
        'screen_size': data['screen_size'],
        'images': directory.listSync().length,
        'user_name': user['username'],
        'user_rating': user['rating'],
        'user_reviews': reviewsRow.length,
      },
    );
  }
  await sql.close();
  return List.from(myAdverbs.reversed);
}
//id, uid,timestamp,category,category_id,price,address,description,phone,messages,state,type,brand,model,color,engine,hp,nm,killometrs,drive_type,transmission,year,engine_volume,engine_cylinders,gears,tact_nubmers,fuel_supply,build_type,order_type,flour,rights,repair,square,cpu,gpu,ram,memory_hard,sex,age,size,screen_size


Future<Map> getAd (id) async {
  Map ad = {};
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  var response = await sql.execute(
    "SELECT * FROM ads where id = $id",
    {},);
  var data = response.rows.first.assoc();
  Directory directory = Directory('images/${data['ccid']}');
  ad = {
    'id': data['id'],
    'name': data['name'],
    'uid': data['uid'],
    'timestamp': data['timestamp'],
    'category': data['category'],
    'category_id': data['category_id'],
    'price': data['price'],
    'address': data['address'],
    'description': data['description'],
    'phone': data['phone'],
    'messages': data['messages'],
    'state': data['state'],
    'type': data['type'],
    'ccid': data['ccid'],
    'brand': data['brand'],
    'model': data['model'],
    'color': data['color'],
    'engine': data['engine'],
    'hp': data['hp'],
    'nm': data['nm'],
    'killometrs': data['killometrs'],
    'drive_type': data['drive_type'],
    'transmission': data['transmission'],
    'year': data['year'],
    'engine_volume': data['engine_volume'],
    'engine_cylinders': data['engine_cylinders'],
    'gears': data['gears'],
    'tact_nubmers': data['tact_nubmers'],
    'fuel_supply': data['fuel_supply'],
    'build_type': data['build_type'],
    'order_type': data['order_type'],
    'flour': data['flour'],
    'rights': data['rights'],
    'repair': data['repair'],
    'square': data['square'],
    'cpu': data['cpu'],
    'gpu': data['gpu'],
    'ram': data['ram'],
    'memory_hard': data['memory_hard'],
    'sex': data['sex'],
    'age': data['age'],
    'size': data['size'],
    'screen_size': data['screen_size'],
    'images': directory
        .listSync()
        .length,
  };


  return ad;
}