import 'dart:async';
import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

List<String> imageLinks = [];

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.body();
    final data = jsonDecode(body);

    // Verifica si hay adjuntos
    if (data['attachments'] == null) {
      return Response.json(
        body: {'error': 'No hay contenido o adjuntos en el mensaje.'},
        statusCode: 400,
      );
    }

    // Filtra y extrae los enlaces de las imágenes
    final List<String> newImageLinks = (data['attachments'] as List)
        .where((attachment) =>
            attachment['content_type'] != null &&
            attachment['content_type'].toString().startsWith('image'))
        .map((attachment) => attachment['url'].toString())
        .toList();

    // Agrega los nuevos enlaces de imagen
    imageLinks.addAll(newImageLinks);

    if (newImageLinks.isNotEmpty) {
      print('Links de imágenes: $newImageLinks');
    } else {
      print('No hay imágenes en este mensaje.');
    }

    return Response.json(
      body: {
        'message': 'Recibido',
        'image_links': newImageLinks,
      },
      statusCode: 200,
    );
  }

  if (context.request.method == HttpMethod.get) {
    // Retorna todos los enlaces de imágenes almacenados
    return Response.json(body: {'image_links': imageLinks});
  }

  return Response(body: 'Método no permitido', statusCode: 405);
}
