import 'package:mysql_client/mysql_client.dart';

Future<void> createAdverbFromSQL({
  required name,
  required size,
  required price,
  required phone,
  required hp,
  required messages,
  required category,
  required uid,
  required year,
  required sex,
  required age,
  required color,
  required timestamp,
  required description,
  required address,
  required model,
  required brand,
  required engine,
  required state,
  required build_type,
  required category_id,
  required cpu,
  required drive_type,
  required engine_cylinders,
  required engine_volume,
  required flour,
  required fuel_supply,
  required gears,
  required gpu,
  required killometrs,
  required memory_hard,
  required nm,
  required order_type,
  required ram,
  required repair,
  required rights,
  required screen_size,
  required square,
  required tact_numbers,
  required transmission,
  required type,
  required ccid,
}) async {
  var sql = await MySQLConnection.createConnection(
      host: 'localhost',
      port: 3306,
      userName: 'root',
      password: '1234567890',
      databaseName: 'lensnew');
  await sql.connect();
  var resul = await sql.execute(
    "SELECT * FROM ads",
    {},
  );
  String id = resul.rows.last.assoc()['id'] as String;
  int id_int = int.parse(id);
  var result = await sql.execute("insert into ads (id, uid,timestamp,category,category_id,price,address,description,phone,messages,state,type,brand,model,color,engine,hp,nm,killometrs,drive_type,transmission,year,engine_volume,engine_cylinders,gears,tact_nubmers,fuel_supply,build_type,order_type,flour,rights,repair,square,cpu,gpu,ram,memory_hard,sex,age,size,screen_size,ccid, name) values (${id_int+1}, $uid, '$timestamp', '$category', $category_id, $price, '$address', '$description', $phone, $messages, '$state', '$type', '$brand', '$model', '$color', '$engine', $hp, $nm, $killometrs, '$drive_type', '$transmission', $year, $engine_volume, $engine_cylinders, $gears, $tact_numbers, '$fuel_supply', '$build_type', '$order_type', $flour, $rights, '$repair', $square, '$cpu', '$gpu', $ram, '$memory_hard', '$sex', '$age', '$size', $screen_size, '$ccid', '$name')");
  await sql.close();
}
