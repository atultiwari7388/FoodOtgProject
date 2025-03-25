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
      child: Center(
        child: Lottie.asset(
          animationUrl,
          onLoaded: (composition) {
            Future.delayed(duration, onCompleted);
          },
          fit: BoxFit.contain,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
