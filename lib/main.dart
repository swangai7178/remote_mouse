import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(MouseApp());
}

class MouseApp extends StatelessWidget {
  const MouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MouseControlPage(),
    );
  }
}

class MouseControlPage extends StatefulWidget {
  const MouseControlPage({super.key});

  @override
  _MouseControlPageState createState() => _MouseControlPageState();
}

class _MouseControlPageState extends State<MouseControlPage> {
final channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.4:3000')); 
// Ensure this IP is correct and accessible

  Offset? lastPosition;

  void _sendMessage(String action, {Offset? delta}) {
    final message = {
      "action": action,
      "dx": delta?.dx ?? 0,
      "dy": delta?.dy ?? 0,
    };
    channel.sink.add(jsonEncode(message)); // Use jsonEncode for proper JSON formatting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onPanStart: (details) {
          lastPosition = details.localPosition;
        },
        onPanUpdate: (details) {
          if (lastPosition != null) {
            final delta = details.localPosition - lastPosition!;
            _sendMessage("move", delta: delta);
            lastPosition = details.localPosition;
          }
        },
        onTap: () => _sendMessage("click"),
        child: Center(
          child: Text("Swipe to move, tap to click", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
}
