

import 'package:flutter/material.dart';

class MessageView extends StatefulWidget {
  final String id ;
  const MessageView({Key? key , required this.id}) : super(key: key);

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Message Screen' +widget.id)  ,
      ),
    );
  }
}