import 'package:flutter/material.dart';

class ExplicitAnimationExample extends StatefulWidget {
  const ExplicitAnimationExample({super.key});

  @override
  State<ExplicitAnimationExample> createState() => _ExplicitAnimationExampleState();
}

class _ExplicitAnimationExampleState extends State<ExplicitAnimationExample>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Tween<double> _tween;
  late Animation<double> _animation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Define a Tween to animate from 0 to 300
    _tween = Tween<double>(begin: 0, end: 300);

    // Create the animation using the controller and tween
    _animation = _tween.animate(_controller)
      ..addListener(() {
        // Manually set the state to trigger a rebuild
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
      if (_isAnimating) {
        _controller.forward();
      } else {
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explicit Animation Example'),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.network(
              'https://your-image-url-here.com/image.jpg', // Replace with a valid image URL
              fit: BoxFit.cover,
            ),
          ),
          // Animated container
          Center(
            child: Transform.translate(
              // Explicitly use the animation's value for the offset
              offset: Offset(_animation.value, 0),
              child: Container(
                width: 100,
                height: 100,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleAnimation,
        child: Icon(_isAnimating ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}

