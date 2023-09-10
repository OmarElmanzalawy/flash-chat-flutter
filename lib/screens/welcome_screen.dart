import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/wdigets/RoundedButton.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin
 {

  AnimationController controller;
  Animation curvedAnimation;
  Animation colorChange;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(

    duration: Duration(seconds: 1),
    vsync: this,
  );

    curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.bounceOut);

    colorChange = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);

  controller.forward();

  controller.addListener(() { 
    setState(() {
      
    });
    print(curvedAnimation.value);
  });

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorChange.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: curvedAnimation.value *60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  text: ['Flash Chat'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.black
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.blue,
              onpressed: () => Navigator.pushNamed(context, LoginScreen.id),
              text: 'Login'
              ),
            RoundedButton(
              color: Colors.blue,
              text: 'Register',
              onpressed: () => Navigator.pushNamed(context, RegistrationScreen.id),
              ),
          ],
        ),
      ),
    );
  }
}

