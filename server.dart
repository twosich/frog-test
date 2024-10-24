import 'dart:io';

Future<void> main() async {

  var server = await HttpServer.bind(
    InternetAddress.anyIPv4, 
    3000,
  );
  print('Server in http://${server.address.host}:${server.port}');

  await for (HttpRequest request in server) {
    request.response
      ..headers.contentType = ContentType.text
      ..write('Hello World')
      ..close();
  }
}
