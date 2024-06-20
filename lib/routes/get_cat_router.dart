import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../constants.dart';

Router router = Router(
);
void get_cat() {
  router.get('/getcategories', (Request request) async {
   // developer.log(request.toString());
    return Response.ok(jsonEncode(cat));
  });
}