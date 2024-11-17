import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../db/db.dart';

Future<Response> onRequest(RequestContext context) async {
  final db = await Database.connect();
  final collection = Database.getCollection('rox');

  switch (context.request.method) {
    case HttpMethod.get:
      final rox = await collection.find().toList();
      return Response.json(body: rox);

    case HttpMethod.post:
      final data = await context.request.body();
      final nuevoUsuario = jsonDecode(data);

      await collection.insertOne(createRox);
      return Response.json(
          body: {'message': 'Usuario creado', 'user': nuevoUsuario},
          statusCode: 201);

      await collection.Insert()
      return 

    default:
      return Response.json(
          body: {'error': 'Método no permitido'}, statusCode: 405);
  }
}
