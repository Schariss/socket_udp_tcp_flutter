import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//Socket which we can use to establish a connection to a server as a client.
//The second is ServerSocket which we will use to create a server, and accept client connections.
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  int port = 3000;

  List<int> dataToSend = utf8.encode("Hello Adnane");
  RawDatagramSocket udpSocServ;
  RawDatagramSocket udpSocClient;
  Socket _socket;

  initState() {
    tcpServer();
    //tcpClient();
    // udp();
  }

  void tcpServer() {
    //accept connection coming from any ip adress
    ServerSocket.bind(InternetAddress.anyIPv4, 4567)
        .then((ServerSocket server) {
      server.listen(handleClient);
    });
    Socket.connect(InternetAddress.loopbackIPv4, 4567).then((socket) {
      print('Connected to: '
          '${socket.remoteAddress.address}:${socket.remotePort}');
      socket.listen((data) {}, onDone: () {
        print("Done");
        socket.destroy();
      });
      _socket = socket;
    });
  }

  void handleClient(Socket client) {
    print('Connection from '
        '${client.remoteAddress.address}:${client.remotePort}');
    client.listen((event) {
      String clientData = new String.fromCharCodes(event).trim();
      print(clientData);
      if (clientData.isNotEmpty) {
        setState(() {
          _counter++;
        });
      }
    });
    // client.close();
  }

  void tcpClient() {
    _socket.write("Increment the counter");
    //String indexRequest = 'GET / HTTP/1.1\nConnection: close\n\n';
    //opening a connection to google.com on port 80
    // Socket.connect("google.com", 80).then((socket) {
    //   print('Connected to: '
    //       '${socket.remoteAddress.address}:${socket.remotePort}');
    //   //Establish the onData, and onDone callbacks
    //   socket.listen((data) {
    //     print(new String.fromCharCodes(data).trim());
    //   }, onDone: () {
    //     print("Done");
    //     socket.destroy();
    //   });
    //   //Send the request
    //   socket.write(indexRequest);
    // });
  }

  // void udp() async {
  //   //server
  //   udpSocServ =
  //       await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, port);
  //   //client
  //   udpSocClient =
  //       await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, 0);
  //   udpSocServ.listen((RawSocketEvent event) {
  //     if (event == RawSocketEvent.READ) {
  //       Datagram dg = udpSocServ.receive();
  //       setState(() {
  //         _counter++;
  //       });
  //       print(utf8.decode(dg.data));
  //       print('${dg.address.address} : ${dg.port.toString()}');
  //     }
  //   });
  // }

  // void udpSocket() async {
  //   //client
  //   udpSocClient.send(dataToSend, InternetAddress.LOOPBACK_IP_V4, port);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _counter != 0
                ? Text('$_counter', style: TextStyle(fontSize: 22))
                : Text(''),
            SizedBox(height: 30),
            FlatButton(
                onPressed: () {
                  //udpSocket();
                  tcpClient();
                },
                child: Text(
                  "Send Notification",
                  style: TextStyle(fontSize: 18),
                ),
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25))),
          ],
        ),
      ),
    );
  }
}
