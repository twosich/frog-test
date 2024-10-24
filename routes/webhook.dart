import 'dart:async';
import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

List<String> imageLinks = [];

Future<Response> onRequest(RequestContext context) async {
  // Configura los encabezados CORS
  final corsHeaders = {
    'Access-Control-Allow-Origin': '*', // Permitir todas las orígenes, puedes restringir esto si es necesario
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS', // Métodos permitidos
    'Access-Control-Allow-Headers': 'Content-Type' // Encabezados permitidos
  };

  if (context.request.method == HttpMethod.options) {
    return Response(
      statusCode: 204,
      headers: corsHeaders,
    );
  }

  if (context.request.method == HttpMethod.post) {
    final body = await context.request.body();
    final data = jsonDecode(body);

    if (data['attachments'] == null) {
      return Response.json(
          body: {'error': 'No hay contenido o adjuntos en el mensaje.'},
          statusCode: 400,
          headers: corsHeaders);
    }

    final List<String> newImageLinks = (data['attachments'] as List)
        .where((attachment) =>
            attachment['content_type'] != null &&
            attachment['content_type'].toString().startsWith('image'))
        .map((attachment) => attachment['url'].toString())
        .toList();

    imageLinks.addAll(newImageLinks);

    if (newImageLinks.isNotEmpty) {
      print('Links de imágenes: $newImageLinks');
    } else {
      print('No hay imágenes en este mensaje.');
    }

    return Response.json(
        body: {'message': 'Recibido', 'image_links': newImageLinks},
        headers: corsHeaders);
  }

  if (context.request.method == HttpMethod.get) {
    return Response.json(body: {'image_links': imageLinks}, headers: corsHeaders);
  }

  return Response(body: 'Método no permitido', statusCode: 405, headers: corsHeaders);
}
