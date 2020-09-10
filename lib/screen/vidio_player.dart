import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VidioPlayerScreen extends StatefulWidget {
  final YoutubePlayerController controller;
  VidioPlayerScreen({Key key, @required this.controller}) : super(key : key);
  @override
  _VidioPlayerScreenState createState() => _VidioPlayerScreenState(controller);
}

class _VidioPlayerScreenState extends State<VidioPlayerScreen> {
  final YoutubePlayerController controller;
  _VidioPlayerScreenState(this.controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: YoutubePlayer(controller: controller),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: Icon(EvaIcons.closeCircle), 
              color: Colors.white,
              onPressed: (){
                Navigator.pop(context);
              }
              ),
          )
        ],
      ),
      
    );
  }
}