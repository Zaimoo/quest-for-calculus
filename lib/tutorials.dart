import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;

  const StyledButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ).copyWith(backgroundColor: MaterialStateProperty.all(backgroundColor)),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontFamily: 'Rosario',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class Tutorials extends StatefulWidget {
  const Tutorials({Key? key}) : super(key: key);

  @override
  State<Tutorials> createState() => _TutorialsState();
}

class _TutorialsState extends State<Tutorials> {
  late CustomVideoPlayerController _customVideoPlayerController;

  String assetVideoPath = 'assets/videos/Theorem_1.mp4';
  String videoTitle = 'The Limit of a Function is Itself';
  String videoDescription = 'This is a tutorial on Theorem 1.';
  EdgeInsets videoPadding = EdgeInsets.symmetric(horizontal: 16);
  BorderRadius videoBorderRadius = BorderRadius.circular(8);

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer();
  }

  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tutorials')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ListTile(
                    title: Center(
                      child: Text(
                        videoTitle,
                        style: TextStyle(
                          fontFamily: 'Rosario',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromRGBO(3, 34, 77, 1.000),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: videoPadding,
                    child: ClipRRect(
                      borderRadius: videoBorderRadius,
                      child: CustomVideoPlayer(
                        customVideoPlayerController:
                            _customVideoPlayerController,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      videoDescription,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          StyledButton(
            text: 'The Limit of a Function is Itself',
            onPressed: () => changeVideo(
              'assets/videos/Theorem_1.mp4',
              'The Limit of a Function is Itself',
              'This is a tutorial on Theorem 1.',
            ),
            backgroundColor: Colors.white,
            textColor: Color.fromRGBO(3, 34, 77, 1.000),
          ),
          StyledButton(
            text: 'The Constant Multiple Theorem',
            onPressed: () => changeVideo(
              'assets/videos/Theorem_3.mp4',
              'The Constant Multiple Theorem',
              'This is a tutorial on Theorem 3.',
            ),
            backgroundColor: Colors.white,
            textColor: Color.fromRGBO(3, 34, 77, 1.000),
          ),
          StyledButton(
            text: 'The Multiplication Theorem',
            onPressed: () => changeVideo(
              'assets/videos/Theorem_5.mp4',
              'The Multiplication Theorem',
              'This is a tutorial on Theorem 5.',
            ),
            backgroundColor: Colors.white,
            textColor: Color.fromRGBO(3, 34, 77, 1.000),
          ),
          StyledButton(
            text: 'The Division Theorem',
            onPressed: () => changeVideo(
              'assets/videos/Theorem_6.mp4',
              'The Division Theorem',
              'This is a tutorial on Theorem 6.',
            ),
            backgroundColor: Colors.white,
            textColor: Color.fromRGBO(3, 34, 77, 1.000),
          ),
          StyledButton(
            text: 'The Power Theorem',
            onPressed: () => changeVideo(
              'assets/videos/Theorem_7.mp4',
              'The Power Theorem',
              'This is a tutorial on Theorem 7.',
            ),
            backgroundColor: Colors.white,
            textColor: Color.fromRGBO(3, 34, 77, 1.000),
          ),
          StyledButton(
            text: 'The Radical/Root Theorem',
            onPressed: () => changeVideo(
              'assets/videos/Theorem_8.mp4',
              'The Radical/Root Theorem',
              'This is a tutorial on Theorem 8.',
            ),
            backgroundColor: Colors.white,
            textColor: Color.fromRGBO(3, 34, 77, 1.000),
          ),
          StyledButton(
            text: 'Limit of a Polynomial Function',
            onPressed: () => changeVideo(
              'assets/videos/Theorem_9.mp4',
              'Limit of a Polynomial Function',
              'This is a tutorial on Theorem 9.',
            ),
            backgroundColor: Colors.white,
            textColor: Color.fromRGBO(3, 34, 77, 1.000),
          ),
        ],
      ),
    );
  }

  void initializeVideoPlayer() {
    VideoPlayerController _videoPlayerController;
    _videoPlayerController = VideoPlayerController.asset(assetVideoPath)
      ..initialize().then((_) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
    );
  }

  void changeVideo(String path, String title, String description) {
    setState(() {
      assetVideoPath = path;
      videoTitle = title;
      videoDescription = description;
    });
    initializeVideoPlayer();
  }
}
