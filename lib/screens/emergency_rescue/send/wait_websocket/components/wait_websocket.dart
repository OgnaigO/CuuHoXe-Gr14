import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';


import '/config/constants.dart';
import '/helper/util.dart';

class WaitWebSocket extends StatefulWidget {
  String message;
  String destination;
  Function(StompFrame) callback;

  WaitWebSocket({
    required this.message,
    required this.destination,
    required this.callback,
    Key? key,
  }) : super(key: key);

  @override
  State<WaitWebSocket> createState() => _WaitWebSocketState();
}

class _WaitWebSocketState extends State<WaitWebSocket> {
  // Thay vì lấy baseApiUrl (http://...), ta phải chuyển thành ws:// và thêm '/websocket' phía sau.
  // Ví dụ baseApiUrl = "http://192.168.0.105:8080/", ta chuyển thành:
  final String socketUrl = baseApiUrl
      .replaceFirst('http://', 'ws://')
      .replaceFirst('https://', 'wss://') +
    'webSocket/websocket';

  StompClient? stompClient;

  @override
  void initState() {
    super.initState();

    if (stompClient == null) {
      stompClient = StompClient(
        config: StompConfig(
          url: socketUrl,
          onConnect: _onConnectCallback,
          onWebSocketError: (dynamic error) async {
            await Util.showDialogNotification(
              context: context,
              content: error.toString(),
            );
          },
        ),
      );
      stompClient!.activate();
    }
  }

  @override
  void dispose() {
    if (stompClient != null) {
      stompClient!.deactivate();
    }
    super.dispose();
  }

  void _onConnectCallback(StompFrame connectFrame) {
    // Khi đã kết nối thành công
    stompClient!.subscribe(
      destination: widget.destination,
      callback: widget.callback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 50),
          Text(
            widget.message,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
