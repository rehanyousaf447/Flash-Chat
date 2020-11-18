import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flash_chatt/screens/login_screen.dart';
import 'package:flash_chatt/screens/registration_screen.dart';
import 'package:flash_chatt/components/Rounded_Button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcomescreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      //animationBehavior: this,
      vsync: this,
    );

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.decelerate);

// animation=BorderRadiusTween(
//   begin: BorderRadius.circular(10),
//   end: BorderRadius.circular(40),
// ).animate(animationController);

    animation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(animationController);

    animationController.forward();

    animation.addStatusListener((status) {
      // if(status==AnimationStatus.completed){
      //   animationController.reverse(from: 1.0);
      // }
      // else if(status==AnimationStatus.dismissed){
      //   animationController.forward();
      // }
    });

    animationController.addListener(() {
      setState(() {});
      print(animation.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
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
                    height: 60,
                  ),
                ),
                SizedBox(
                  width: 250.0,
                  child: TypewriterAnimatedTextKit(
                    text: ["FLASH CHAT"],
                    textStyle: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Agne",
                    ),
                    totalRepeatCount: 10,
                    speed: Duration(milliseconds: 500),
                    pause: Duration(milliseconds: 100),
                    textAlign: TextAlign.start,
                    alignment:
                        AlignmentDirectional.topStart, // or Alignment.topLeft
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              onPress: () {
                //Go to login screen.
                Navigator.pushNamed(context, LoginScreen.id);
              },
              color: Colors.lightBlueAccent,
              title: "Log In",
            ),
            RoundedButton(
              onPress: () {
                //Go to registration screen.
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              title: 'Register',
              color: Colors.blueAccent,
            ),
          ],
        ),
      ),
    );
  }
}
