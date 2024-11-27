import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC5dgMU2uQtoN2sFleYf61dusC4898Pb6Q",
      authDomain: "micro-project-f8565.firebaseapp.com",
      projectId: "micro-project-f8565",
      storageBucket: "micro-project-f8565.firebasestorage.app",
      messagingSenderId: "143899323699",
      appId: "1:143899323699:web:8dfd16091dc1d4000a2246",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      debugShowCheckedModeBanner: false,
      initialRoute: '/sign_up',
      routes: {
        '/sign_up': (context) => SignUpScreen(),
        '/email_verification': (context) => EmailVerificationScreen(),
      },
    );
  }
}

class AuthHelper {
  var _auth = FirebaseAuth.instance;

  void sendEmailVerification() async {
    //TODO: Part 1 - Instruction 1
    await _auth.currentUser!.sendEmailVerification();
  }

  Future<bool> signUpEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final email = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogo(),
            SizedBox(height: 31),
            infoMessage(email),
            SizedBox(height: 29),
            SignInElevatedButton(
              onPressed: () {},
              buttonName: 'Return to Sign up',
            ),
          ],
        ),
      ),
    );
  }

  Widget infoMessage(String email) {
    return Container(
      width: 309,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFDBDBDB)),
        borderRadius: BorderRadius.circular(3),
        color: Color(0xFFFAFAFA),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Verify your email',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            'We have sent an email to ',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          Text(
            '$email',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Just click on the link in that email to complete your signup.',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SignInTextButton extends StatelessWidget {
  const SignInTextButton({
    super.key,
    required this.onPressed,
    required this.buttonName,
    required this.color,
  });

  final Function() onPressed;
  final String buttonName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: Text(
        buttonName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: color,
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FMicrogram_logo.png?alt=media&token=bb3f7b8b-9275-47cf-9c30-22fee3069465',
      width: 174,
      height: 50,
    );
  }
}

class SignInTextField extends StatelessWidget {
  const SignInTextField({
    super.key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
  });

  final TextEditingController controller;
  final bool obscureText;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 268,
      height: 38,
      child: TextField(
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFF737373),
        ),
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDBDBDB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDBDBDB)),
          ),
          filled: true,
          fillColor: Color(0xFFFAFAFA),
          hoverColor: Colors.transparent,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF737373),
          ),
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }
}

class SignInElevatedButton extends StatelessWidget {
  const SignInElevatedButton({
    super.key,
    required this.onPressed,
    required this.buttonName,
  });

  final Function() onPressed;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 268,
      height: 38,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          buttonName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthHelper _authHelper = AuthHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppLogo(),
            SizedBox(height: 34),
            SignInTextField(
              controller: _emailController,
              hintText: 'Email',
            ),
            SizedBox(height: 13),
            SignInTextField(
              controller: _passwordController,
              obscureText: true,
              hintText: 'Password',
            ),
            SizedBox(height: 34),
            SignInElevatedButton(
              onPressed: () async {
                final response = await _authHelper.signUpEmailAndPassword(
                  _emailController.text,
                  _passwordController.text,
                );
                if (response) {
                  //TODO: Part 2 - Instruction 1
                  _authHelper.sendEmailVerification();
                  Navigator.pushNamed(
                    context,'/email_verification',
                    arguments:_emailController.text,
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text('Sign Up Failed'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        )
                      ],
                    ),
                  );
                }
              },
              buttonName: 'Sign up',
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Have an account? ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SignInTextButton(
                  onPressed: () {},
                  buttonName: 'Sign in',
                  color: Color(0xFF3C95EF),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}