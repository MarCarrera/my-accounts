import 'package:flutter/material.dart';

class LoadingDots extends StatefulWidget {
  @override
  _LoadingDotsState createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(
              opacity: _animation.value,
              child: Text(
                '.',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Opacity(
              opacity: _animation.value > 0.5 ? 1 : 0,
              child: Text(
                '.',
                style: TextStyle(fontSize: 24),
              ),
            ),
            Opacity(
              opacity: _animation.value > 0.75 ? 1 : 0,
              child: Text(
                '.',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        );
      },
    );
  }
}
