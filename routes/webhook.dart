import 'dart:async';
import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';

List<String> imageLinks =
    []; // Lista para almacenar los enlaces de las imágenes

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.post) {
    final body = await context.request.body();
    final data = jsonDecode(body);

    if (data['attachments'] == null) {
      return Response.json(
          body: {'error': 'No hay contenido o adjuntos en el mensaje.'},
          statusCode: 400);
    }

    // Filtrar enlaces de imágenes y agregar a la lista
    final List<String> newImageLinks = (data['attachments'] as List)
        .where((attachment) =>
            attachment['content_type'] != null &&
            attachment['content_type'].toString().startsWith('image'))
        .map((attachment) => attachment['url'].toString())
        .toList();

    imageLinks.addAll(newImageLinks); // Almacenar enlaces en la lista

    if (newImageLinks.isNotEmpty) {
      print('Links de imágenes: $newImageLinks');
    } else {
      print('No hay imágenes en este mensaje.');
    }

    return Response.json(
        body: {'message': 'Recibido', 'image_links': newImageLinks});
  }

  // Manejar solicitudes GET para obtener los enlaces de las imágenes
  if (context.request.method == HttpMethod.get) {
    return Response.json(body: {'image_links': imageLinks});
  }

  return Response(body: 'Método no permitido', statusCode: 405);
}
