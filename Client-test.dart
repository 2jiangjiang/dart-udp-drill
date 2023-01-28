import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  RawDatagramSocket.bind(InternetAddress.anyIPv4, 0).then((RawDatagramSocket socket){
    print('Sending from ${socket.address.address}:${socket.port}');
    int port = 9000;
    socket.send('Hello from UDP land!\n'.codeUnits,
        InternetAddress("101.85.134.95"), port);
    socket.listen((RawSocketEvent e) {
      Datagram? d = socket.receive();
      if (d == null) return;
      String message = String.fromCharCodes(d.data).trim();
      if (message.startsWith("[")) {
        var ip = JsonDecoder().convert(message);
        print('Datagram from ${d.address.address}:${d.port}: ${message}');
        socket.send(
            'Hello from UDP test!\n'.codeUnits, InternetAddress(ip[0]), ip[1]);
      }else{
        print(message);
      }
    });
  });
}