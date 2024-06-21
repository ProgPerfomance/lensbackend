import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:lens_backend/constants.dart';
import 'package:lens_backend/data/categories.dart';
import 'package:lens_backend/sql_connect/add_see_from_sql.dart';
import 'package:lens_backend/sql_connect/avito/create_adverd_from_sql.dart';
import 'package:lens_backend/sql_connect/avito/get_adverbs_list_from_sql.dart';
import 'package:lens_backend/sql_connect/chat/create_chat_from_sql.dart';
import 'package:lens_backend/sql_connect/chat/create_message_from_sql.dart';
import 'package:lens_backend/sql_connect/chat/get_chat_list_from_sql.dart';
import 'package:lens_backend/sql_connect/chat/get_messages_from_sql.dart';
import 'package:lens_backend/sql_connect/create_reponse_from_sql.dart';
import 'package:lens_backend/sql_connect/create_servise_sql.dart';
import 'package:lens_backend/sql_connect/order/accept_response_order_sql.dart';
import 'package:lens_backend/sql_connect/order/comleted_orders.dart';
import 'package:lens_backend/sql_connect/order/complete_order.dart';
import 'package:lens_backend/sql_connect/order/create_order_from_sql.dart';
import 'package:lens_backend/sql_connect/order/get_last_orders_list.dart';
import 'package:lens_backend/sql_connect/order/get_my_responses.dart';
import 'package:lens_backend/sql_connect/order/get_orders_from_category_sql.dart';
import 'package:lens_backend/sql_connect/review/review.dart';
import 'package:lens_backend/sql_connect/servises/booking_service.dart';
import 'package:lens_backend/sql_connect/servises/services.dart';
import 'package:lens_backend/sql_connect/user_sql.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

Router router = Router();
void main() async {
  router.post('/createuser', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var name = data['name'];
    var email = data['email'];
    var age = data['age'];
    var freelancer = data['freelancer'];
    var password_hash = data['password_hash'];
    var city = data['city'];
    var country = data['country'];
    var date_of_burn = data['date_of_burn'];
    var avatar = data['avatar'];
    var spheres = data['categories'];
    var skills = data['skills'];
    var education = data['education'];
    var experience = data['experience'];
    var about_me = data['about_me'];
    var client_visiting = data['client_visiting'];
    var servises = data['servises'];
    var email_succes = data['email_succes'];
    int id = await createUserFromSQL(
      last_login: null,
      name: name,
      city: city,
      client_visiting: client_visiting,
      country: country,
      age: age,
      about_me: about_me,
      email: email,
      education: education,
      email_succes: email_succes,
      date_of_burn: date_of_burn,
      avatar: avatar,
      servises: servises,
      rating: 0,
      reviews: request,
      experience: experience,
      skills: skills,
      spheres: spheres,
      freelancer: freelancer,
      password_hash: password_hash,
    );

    return Response.ok(jsonEncode({'uid': id}));
  });

  router.post('/authuser', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var email = data['email'];
    var password = data['password'];
    var response = await authUser(email, password);
    var req = {'success': response['success'], 'uid': response['uid']};
    return Response.ok(jsonEncode(response));
  });
  // router.post('/getAd', (Request request) async {
  //   var json = await request.readAsString();
  //   var data = jsonDecode(json);
  //   Map response = await getAd(data['id']);
  //   return Response.ok(jsonEncode(response));
  // });

  router.get('/getuserdata', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var id = data['id'];
    var response = await getUserData(id);
    return Response.ok(jsonEncode(response));
  });

  router.get('/getallcitylist', (Request request) {
    return Response.ok(jsonEncode(allcitysList));
  });
  router.get('/popularallcitylist', (Request request) {
    return Response.ok(jsonEncode(popularcitys));
  });
  router.get('/categories', (Request request) {
    return Response.ok(jsonEncode(categories));
  });
  router.get('/getorders', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    List ordersList = await getLastOrdes();
    return Response.ok(jsonEncode(ordersList));
  });

  router.post('/getordersfromcat', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var cat = data['cat'];
    List ordersList = await getOrdersFromCategorySQl(cat);
    return Response.ok(jsonEncode(ordersList));
  });
  router.post('/getAdsFromCat', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var cat = data['category'];
    List ordersList =
    await getAdverbsByCategory(cat, data['priceMin'], data['priceMax']);
    return Response.ok(jsonEncode(ordersList));
  });
  router.post('/getFreelancerBooking', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    List freelancerBooking = await getFreelancerBooking(data['uid']);
    return Response.ok(jsonEncode(freelancerBooking));
  });
  router.post('/getCustomerBooking', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    List customerBooking = await getCustomerBooking(data['uid']);
    return Response.ok(jsonEncode(customerBooking));
  });
  router.post('/bookService', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    await bookService(
        uid: data['uid'],
        sid: data['sid'],
        date: data['date'],
        description: data['description'],
        freelancerId: data['freelancer_id']);
    return Response.ok('book');
  });
  router.post('/getOtherUserInfo', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var uid = data['uid'];
    Map response = await getOtherUserData(uid);
    return Response.ok(jsonEncode(response));
  });
  router.post('/deleteMyResponse', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    deleteMyResponse(data['pid']);
    return Response.ok('deleted');
  });

  router.get('/getUserActiveOrders', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var uid = data['uid'];
    var response = await getUserActiveOrders(uid);
    return Response.ok(jsonEncode(response));
  });
  router.get('/getMyArchiveOrders', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var uid = data['uid'];
    var response = await getUserArchiveOrders(uid);
    return Response.ok(jsonEncode(response));
  });
  router.get('/deleteOrder', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    await deleteMyOrder(data['pid']);
    return Response.ok('deleted');
  });
  router.post('/createadverb', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var images = data['images'];
    var folderName = request.headers['folder-name'];
    var newFolder = Directory('images/$folderName');
    if (!await newFolder.exists()) {
      await newFolder.create(recursive: true);
    }
    for (var i = 0; i < images.length; i++) {
      var imageData = images[i];
      var imageBytes = base64Decode(imageData['data']);
      var imageName = imageData['name'];
      var filePath = 'images/$folderName/$imageName';

      var file = File(filePath);
      await file.writeAsBytes(imageBytes);
    }
    createAdverbFromSQL(
        ccid: folderName,
        size: data['size'],
        price: data['price'],
        phone: data['phone'],
        name: data['name'],
        hp: data['hp'],
        messages: data['messages'],
        category: data['category'],
        uid: data['uid'],
        year: data['year'],
        sex: data['sex'],
        age: data['age'],
        color: data['color'],
        timestamp: data['timestamp'],
        description: data['description'],
        address: data['address'],
        model: data['model'],
        brand: data['brand'],
        engine: data['engine'],
        state: data['state'],
        build_type: data['build_type'],
        category_id: data['category_id'],
        cpu: data['cpu'],
        drive_type: data['drive_type'],
        engine_cylinders: data['engine_cylinders'],
        engine_volume: data['engine_volume'],
        flour: data['flour'],
        fuel_supply: data['fuel_supply'],
        gears: data['gears'],
        gpu: data['gpu'],
        killometrs: data['killometrs'],
        memory_hard: data['memory_hard'],
        nm: data['nm'],
        order_type: data['order_type'],
        ram: data['ram'],
        repair: data['repair'],
        rights: data['rights'],
        screen_size: data['screen_size'],
        square: data['square'],
        tact_numbers: data['tact_numbers'],
        transmission: data['transmission'],
        type: data['type']);
    developer.log(request.toString());
    return Response.ok('crated');
  });

  router.post('/getmyadverbs', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var uid = data['uid'];
    var response = await getMyAdverbs(int.parse(uid));
    developer.log(request.toString());
    return Response.ok(jsonEncode(response));
  });
  router.post('/getReviewFromId', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    final response = await getReviewsFromId(data['uid'], data['pid']);
    return Response.ok(jsonEncode(response));
  });

  router.get('/getadverbs', (Request request) async {
    var adv = await getLastAdverbs();
    return Response.ok(jsonEncode(adv));
  });

  router.post('/createorder', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var images = data['images'];
    var folderName = request.headers['folder-name'];
    var newFolder = Directory('images/$folderName');
    if (!await newFolder.exists()) {
      await newFolder.create(recursive: true);
    }
    for (var i = 0; i < images.length; i++) {
      var imageData = images[i];
      var imageBytes = base64Decode(imageData['data']);
      var imageName = imageData['name'];
      var filePath = 'images/$folderName/$imageName';

      var file = File(filePath);
      await file.writeAsBytes(imageBytes);
    }
    createOrderFromSQL(
        ccid: folderName,
        description: data['description'],
        id: data['id'],
        fix_price: data['fix_price'],
        not_price: data['not_price'],
        categoryId: data['category_id'],
        uid: data['uid'],
        name: data['name'],
        timestamp: data['timestamp'],
        category: data['category'],
        category_sup: data['category_sup'],
        date_and_time: data['date_and_time'],
        geo_x: data['geo_x'],
        geo_y: data['geo_y'],
        geo_del_x: data['geo_del_x'],
        geo_del_y: data['geo_del_y'],
        price_min: data['price_min'],
        address: data['address'],
        price_max: data['price_max'],
        wishes: data['wishes'],
        img1: data['img1'],
        img2: data['img2'],
        img3: data['img3'],
        img4: data['img4'],
        img5: data['img5'],
        img6: data['img6'],
        img7: data['img7'],
        img8: data['img8'],
        img9: data['img9'],
        img10: data['img10'],
        username: data['username'],
        order_status: data['order_status'],
        email: data['email'],
        city: data['city'],
        sees: data['sees'],
        remotely: data['remotely']);
    return Response.ok(jsonEncode({'status': 'ok'}));
  });

  router.post('/createresponse', (Request request) async {
    var json = await request.readAsString();
    var data = jsonDecode(json);
    createReponseFromSQL(
        pid: data['pid'],
        uid: data['uid'],
        price: data['price'],
        comment: data['comment'],
        date_and_time: data['date_and_time'],
        timestamp: data['timestamp']);
    return Response.ok('add');
  });

  router.post('/getmyresponses', (Request request) async {
    developer.log(request.toString());
    var json = await request.readAsString();
    var data = jsonDecode(json);
    var response = await getMyResponses(data['uid']);
    return Response.ok(jsonEncode(response));
  });

  router.post('/addseeorder', (Request request) async {
    developer.log(request.toString());
    var json = await request.readAsString();
    var data = jsonDecode(json);
    addOrderSee(data['id']);
    return Response.ok('add');
  });
  router.post('/add_avatar', (Request request) async {
    var requestBody = await request.readAsString();
    var data = jsonDecode(requestBody);
    var imageData = data['image'];
    var imageBytes = base64Decode(imageData['data']);
    var imageName = imageData['name'];
    var filePath = 'images/$imageName';
    var file = File(filePath);
    await file.writeAsBytes(imageBytes);
    return Response.ok('');
  });
  router.get('/get_photo', (Request request) async {
    String? path = request.url.queryParameters['path'];
    String? ind = request.url.queryParameters['ind'];
    var imagePathJpeg = 'images/$path/$ind.jpeg';
    var imagePathJpg = 'images/$path/$ind.jpg';
    try {
      var file = File(imagePathJpeg).existsSync()
          ? File(imagePathJpeg)
          : File(imagePathJpg);

      if (await file.exists()) {
        var bytes = await file.readAsBytes();

        return Response.ok(bytes, headers: {
          'Content-Type':
          File(imagePathJpeg).existsSync() ? 'image/jpeg' : 'image/jpg'
        });
      } else {
        return Response.notFound('File not found');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Error: $e');
    }
  });
  router.post('/updateUserPassword', (Request request) async {
    developer.log(request.toString());
    var json = await request.readAsString();
    var data = jsonDecode(json);
    Map response = await updateUserPassword(
        uid: data['uid'],
        lastPassword: data['lastPassword'],
        newPassword: data['newPassword']);
    return Response.ok(jsonEncode(response));
  });

  // router.post('/getorderfid', (Request request) async {
  //   developer.log(request.toString());
  //   var json = await request.readAsString();
  //   var data = await jsonDecode(json);
  //   var ind = await data['index'];
  //   var response = await getLastOrdes();
  //   return Response.ok(jsonEncode(response[ind]));
  // });
  router.post('/getworkorders', (Request request) async {
    developer.log(request.toString());
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var ind = await data['uid'];
    var response = await getWorkOrders(ind);
    return Response.ok(jsonEncode(response));
  });
  router.post('/getOrdersFromGlobalCategory', (Request request) async {
    developer.log(request.toString());
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var response = await getOrdersFromGlobalCategory(data['id']);
    return Response.ok(jsonEncode(response));
  });

  //чат
  router.post('/services', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final response = await getAllServices(
        city: data['city'],
        priceMin: data['price_min'],
        priceMax: data['price_max'],
        ratingMin: data['rating_min'],
        category: data['category'],
        str: data['str']);
    return Response.ok(jsonEncode(response));
  });
  router.post('/activateService', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await activateService(data['id']);
    return Response.ok('ok');
  });
  router.post('/archiveService', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await archiveService(data['id']);
    return Response.ok('ok');
  });
  router.post('/archiveServices', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final response = await getMyArchiveServices(data['uid']);
    return Response.ok(jsonEncode(response));
  });  //
  router.post('/createchat', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    int cid = await createChat(
        type: data['type'],
        uid1: int.parse(data['uid1']),
        uid2: int.parse(data['uid2']),
        chatSubject: int.parse(data['chat_subject']));
    return Response.ok(jsonEncode(cid));
  });

  router.post('/updateuserdata', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    updateUserProfile(
        uid: data['uid'],
        name: data['name'],
        email: data['email'],
        city: data['city'],
        category: data['category'],
        dateOfBurn: data['dateOfBurn'],
        skills: data['skills'],
        education: data['education'],
        experience: data['experience'],
        aboutMe: data['aboutMe'],
        clientVisiting: data['clientVisiting']);
    return Response.ok('Chat created');
  });
  router.post('/getchats', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var chats = await getUserChats(uid: int.parse(data['uid']));
    return Response.ok(jsonEncode(chats));
  });
  router.post('/updateOrder', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await updateOrder(data['id'], data['name'], data['min'], data['max'],
        data['desc'], data['location']);
    return Response.ok('good');
  });
  // router.get('/lastFreelancers', (Request request) async {
  //   List response = await getNewFreelancer();
  //   return Response.ok(jsonEncode(response));
  // });
  router.post('/sendmessage', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await createMessageFromSQL(
        cid: int.parse(data['cid']),
        uid: int.parse(data['uid']),
        msg: data['msg']);
    return Response.ok('success');
  });
  router.post('/getmessages', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    var msgs = await getMessagesFromSQL(int.parse(data['cid']));
    return Response.ok(jsonEncode(msgs));
  });
  router.post('/acceptresponseorder', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    acceptResponse(pid: data['pid'], uid: data['uid']);
    return Response.ok('');
  });
  router.post('/acceptresponseorder', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    acceptResponse(pid: data['pid'], uid: data['uid']);
    return Response.ok('');
  });

  router.post('/getMyServices', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final services = await getMyServices(data['uid']);
    return Response.ok(jsonEncode(services));
  });
  router.post('/completeFreelancer', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await completeOrderFreelancer(id: data['pid']);
    return Response.ok('updated');
  });
  router.post('/completeCustomer', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await completeOrderCustomer(id: data['pid']);
    return Response.ok('updated');
  });
  router.post('/getServicesByCategoryName', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final response = await getAllServicesByCategory(data['category_name']);
    return Response.ok(jsonEncode(response));
  });
  router.get('/avatar', (Request request) async {
    String? path = request.url.queryParameters['path'];
    var imagePathJpeg = 'images/$path.jpeg';
    var imagePathJpg = 'images/$path.jpg';
    try {
      var file = File(imagePathJpeg).existsSync()
          ? File(imagePathJpeg)
          : File(imagePathJpg);

      if (await file.exists()) {
        var bytes = await file.readAsBytes();

        return Response.ok(bytes, headers: {
          'Content-Type':
          File(imagePathJpeg).existsSync() ? 'image/jpeg' : 'image/jpg'
        });
      } else {
        return Response.notFound('File not found');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Error: $e');
    }
  });
  router.post('/getCompleteOrders', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final response = await getCompleteOrders(data['uid']);
    return Response.ok(jsonEncode(response));
  });
  router.post('/getMyServicesShort', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final services = await getMyServicesShortList(data['uid']);
    return Response.ok(jsonEncode(services));
  });
  router.post('/setFreelancer', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await setFreelancer(uid: data['uid'], categories: []);
    return Response.ok('success');
  });
  router.post('/getMyReviews', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final reviews = await getMyReviews(data['uid']);
    return Response.ok(jsonEncode(reviews));
  });
  router.post('/getOrderInfo', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final response = await getOrderInfo(data['id']);
    return Response.ok(jsonEncode(response));
  });
  router.post('/changeCity', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    await changeCity(data['uid'], data['city']);
    return Response.ok('changed');
  });
  router.post('/createReviewFreelancer', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final services = await createReviewFreelancer(
        pid: data['pid'],
        uid: data['uid'],
        rating: data['rating'],
        comment: data['comment'],
        timestamp: DateTime.now().toString(),
        sender_uid: data['sender_uid']);
    return Response.ok('created');
  });
  router.post('/getServicesByCategoryName', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final response = await getAllServicesByCategory(data['category_name']);
    return Response.ok(jsonEncode(response));
  });
  router.post('/createReviewCustomer', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    final services = await createReviewCustomer(
        pid: data['pid'],
        uid: data['uid'],
        rating: data['rating'],
        comment: data['comment'],
        timestamp: DateTime.now().toString(),
        sender_uid: data['sender_uid']);
    return Response.ok('created');
  });

  router.post('/createService', (Request request) async {
    var json = await request.readAsString();
    var data = await jsonDecode(json);
    createServiceFromSQL(
        uid: data['uid'],
        global_category: data['global_category'],
        name: data['name'],
        category_id: data['category_id'],
        category_name: data['category_name'],
        description: data['description'],
        price_min: data['price_min'],
        time: data['time'],
        monday: data['monday'],
        tuesday: data['tuesday'],
        wednesday: data['wednesday'],
        thursday: data['thursday'],
        friday: data['friday'],
        saturday: data['saturday'],
        sunday: data['sunday'],
        fixPrice: data['fixPrice'],
        hourPrice: data['hourPrice']);
    return Response.ok('');
  });
  router.get('/get_photo', (Request request) async {
    String? path = request.url.queryParameters['path'];
    String? ind = request.url.queryParameters['ind'];
    var imagePathJpeg = 'images/$path/$ind.jpeg';
    var imagePathJpg = 'images/$path/$ind.jpg';
    try {
      var file = File(imagePathJpeg).existsSync()
          ? File(imagePathJpeg)
          : File(imagePathJpg);

      if (await file.exists()) {
        var bytes = await file.readAsBytes();

        return Response.ok(bytes, headers: {
          'Content-Type':
          File(imagePathJpeg).existsSync() ? 'image/jpeg' : 'image/jpg'
        });
      } else {
        return Response.notFound('File not found');
      }
    } catch (e) {
      return Response.internalServerError(body: 'Error: $e');
    }
  });

  var server = await serve(router, '63.251.122.116', 2318);
  print('server started');
}
