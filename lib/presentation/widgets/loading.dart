import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Loading extends StatefulWidget {
  final double size;
  final Duration duration;

  const Loading({
    super.key,
    this.size = 60.0,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SvgPicture.string(_getSVGString(), fit: BoxFit.contain),
    );
  }

  String _getSVGString() {
    return '''
<svg width="50" height="50" viewBox="0 0 50 50" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M24.725 12.363c-6.827 0 -12.362 5.535 -12.362 12.362s5.535 12.363 12.362 12.363V49.45C11.07 49.45 0 38.381 0 24.725 0 11.07 11.07 0 24.725 0z" fill="url(#blueGradient)"/><path d="M25.275 0C38.93 0 50 11.07 50 24.725S38.93 50 25.275 50V37.088c6.827 0 12.362 -5.535 12.362 -12.363s-5.535 -12.362 -12.362 -12.362z" fill="url(#yellowGradient)"/><path cx="35" cy="8.65385" r="8.65385" fill="#194D4D" d="M31.181 6.181A6.181 6.181 0 0 1 25 12.363A6.181 6.181 0 0 1 18.819 6.181A6.181 6.181 0 0 1 31.181 6.181z"/><path cx="35" cy="61.34615" r="8.65385" fill="#F7BD42" d="M31.181 43.819A6.181 6.181 0 0 1 25 50A6.181 6.181 0 0 1 18.819 43.819A6.181 6.181 0 0 1 31.181 43.819z"/><defs><radialGradient id="blueGradient" cx="50%" cy="100%" r="100%"><stop offset="0%" stop-color="#74DED0"/><stop offset="80%" stop-color="#194D4D"/></radialGradient><radialGradient id="yellowGradient" cx="50%" cy="0%" r="100%"><stop offset="0%" stop-color="#F9D75C"/><stop offset="80%" stop-color="#F7BD42"/></radialGradient></defs></svg>

''';
  }
}
