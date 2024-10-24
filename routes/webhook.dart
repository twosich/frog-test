import 'dart:async';
import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.body();
    final data = jsonDecode(body);

    if (data['attachments'] == null) {
      return Response.json(
          body: {'error': 'No hay contenido o adjuntos en el mensaje.'},
          statusCode: 400);
    }

    final List<String> imageLinks = (data['attachments'] as List)
        .where((attachment) =>
            attachment['content_type'] != null &&
            attachment['content_type'].toString().startsWith('image'))
        .map((attachment) => attachment['url'].toString())
        .toList();

    if (imageLinks.isNotEmpty) {
      print('Links de imágenes: $imageLinks');
    } else {
      print('No hay imágenes en este mensaje.');
    }

    return Response.json(
        body: {'message': 'Recibido', 'image_links': imageLinks});
  }

  return Response(body: 'Método no permitido', statusCode: 405);
}
