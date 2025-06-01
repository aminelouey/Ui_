import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HostInfo {
  final String ip;
  final int port;

  HostInfo(this.ip, this.port);

  @override
  String toString() => '$ip:$port';
}

class DoctorClient {
  DoctorClient();

  Future<Map<String, HostInfo>> gaussDiscover() async {
    final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
    socket.broadcastEnabled = true;

    final hostMap = <String, HostInfo>{};

    socket.send(
      utf8.encode('DOCTOR_DISCOVER_HOST'),
      InternetAddress('255.255.255.255'),
      5353,
    );

    final subscription = socket.listen((RawSocketEvent event) async {
      if (event == RawSocketEvent.read) {
        final datagram = socket.receive();
        if (datagram != null) {
          try {
            final message = utf8.decode(datagram.data);
            final data = jsonDecode(message);

            final name = data['name'];
            final port = data['port'];
            final ip = datagram.address.address;

            print('ip:$ip  port: $port');

            if (name != null && port != null) {
              hostMap[name] = HostInfo(ip, port);
            }
          } catch (e) {
            print('Error parsing datagram: $e');
          }
        }
      }
    });

    await Future.delayed(Duration(seconds: 2));
    await subscription.cancel();
    socket.close();

    return hostMap;
  }

  static Future<List<dynamic>?> galileoReply(HostInfo hostInfo) async {
    try {
      final uri = Uri.http('${hostInfo.ip}:${hostInfo.port}', '/get');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  static Stream<List<dynamic>?> galileoStream(HostInfo hostInfo) async* {
    final uri = Uri.parse('ws://${hostInfo.ip}:${hostInfo.port}/events');
    WebSocket? socket;
    try {
      socket = await WebSocket.connect(uri.toString());

      await for (final message in socket) {
        try {
          yield jsonDecode(message);
        } catch (_) {
          continue;
        }
      }
    } catch (e) {
      print('WebSocket error: $e');
    } finally {
      await socket?.close();
    }
  }
}
