import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'database.dart';


class AssitantHost {
  final String hostname;
  final int port;
  final AppDatabase adb;
  List<WebSocket> keplers = [];

  AssitantHost._(this.hostname, this.port, this.adb);

  static Future<AssitantHost> create(String hostname, AppDatabase adb) async {
    final port = await getPort();
    if (port == null) {
      throw Exception("Unable to host without closed & free ports, abort!");
    }
    return AssitantHost._(hostname, port, adb);
  }

  static Future<bool> chkPort(int port) async {
    try {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, port);
      await server.close();
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<int?> getPort() async {
    for (var port = 59401; port <= 65535; port++) {
      if (await chkPort(port)) {
        return port;
      }
    }
    return null;
  }

  Future<void> gauss() async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 5353);
    socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = socket.receive();
        if (datagram == null) return;

        final message = utf8.decode(datagram.data);
        if (message == 'DOCTOR_DISCOVER_HOST') {
          final response = jsonEncode({'name': hostname, 'port': port});
          socket.send(utf8.encode(response), datagram.address, datagram.port);
        }
      }
    });
  }
  
  void kepler() {
    keplers.removeWhere((c) => c.closeCode != null);
    final adbjs = adb.getAppointmentsFormatted();
    for (var client in keplers) {
      client.add(jsonEncode(adbjs));
    }
  }

  Future<void> galileo(HttpRequest request) async {
    // Log the request (similar to logRequests middleware)
    /*
    final startTime = DateTime.now();
    print('${DateTime.now().toIso8601String()}  ${DateTime.now().difference(startTime).toString().padLeft(12)} ${request.method.padRight(7)} [${request.response.statusCode}] ${request.uri.path}');
    */
    // Handle GET requests
    if (request.method == 'GET' && request.uri.path == '/get') {
      final adbjs = adb.getAppointmentsFormatted(); // Assume this is defined elsewhere
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(adbjs))
        ..close();
      return;
    }
    
    // This is for debugging purposes, please remove when merging 
    // Testing data updating with kepler call.
    /*if (request.method == 'POST' && request.uri.path == '/add') {
      final body = await utf8.decoder.bind(request).join();
      final data = jsonDecode(body);
      adb.add(data['content']);
      kepler();
      request.response
        ..statusCode = HttpStatus.ok
        ..headers.contentType = ContentType.text
        ..write('Note added!')
        ..close();
      return;
    }*/

    // Handle WebSocket upgrade requests
    if (request.uri.path == '/events') {
      // Upgrade to WebSocket
      try {
        WebSocket socket = await WebSocketTransformer.upgrade(request);
        keplers.add(socket);
        socket.listen(
          (_) {},
          onDone: () {
            keplers.remove(socket);
          },
          onError: (err) {
            keplers.remove(socket);
          },
          cancelOnError: true,
        );
        return;
      } catch (e) {
        // Error handling for WebSocket upgrade
        request.response
          ..statusCode = HttpStatus.internalServerError
          ..write('WebSocket upgrade failed: $e')
          ..close();
        return;
      }
    }

    // If no matching route, return 404
    request.response
      ..statusCode = HttpStatus.notFound
      ..write('Not Found')
      ..close();
  }

  Future<bool> start() async {
    final server = await HttpServer.bind('0.0.0.0', port);
    // Handle incoming requests
    Future(() async {
      await for (HttpRequest request in server) {
        await galileo(request);
      }
    });

    // Optionally call gauss or other methods after the server starts
    await gauss(); 
    return true;
  }
}
