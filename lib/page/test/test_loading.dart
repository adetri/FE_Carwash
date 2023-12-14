import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TestLoading extends StatelessWidget {
  const TestLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoadingAnimationWidget.fourRotatingDots(
          size: 200,
          color: Colors.blue,
        ),
      ),
    );
  }
}
