import 'package:first_app/Modules/on_boarding.dart';
import 'package:first_app/Shared/Components/components.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  AnimationController _controller ;
  Animation <double> _animation;
  @override
  void initState()
  {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.repeat();

    Future.delayed(Duration(seconds:3)).then((value) {
      navigateTo(context,OnBoardingScreen());
    });

    super.initState();
  }
  @override
  void dispose()
  {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:ScaleTransition(
        scale: _animation ,
        child: Center(
          child: Image.asset(
            'assets/Na_Dec_19.jpg',
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}