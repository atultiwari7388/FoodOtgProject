import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationOverlay extends StatelessWidget {
  final String animationUrl;
  final VoidCallback onCompleted;
  final Duration duration;

  LottieAnimationOverlay({
    required this.animationUrl,
    required this.onCompleted,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      child: Center(
        child: Lottie.network(
          animationUrl,
          onLoaded: (composition) {
            Future.delayed(duration, onCompleted);
          },
        ),
      ),
      // child: Center(
      //   child: Image.asset(animationUrl, fit: BoxFit.contain),
      // ),
    );
  }

  // ignore: override_on_non_overriding_member
  // @override
  // void initState() {
  //   Future.delayed(duration, onCompleted);
  // }
}
