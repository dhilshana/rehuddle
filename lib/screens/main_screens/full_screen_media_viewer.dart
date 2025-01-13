import 'package:flutter/material.dart';

class FullScreenMediaViewer extends StatelessWidget {
  String url;
  FullScreenMediaViewer({super.key,required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.network(url),
      ),
    );
  }
}