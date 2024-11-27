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
      initialRoute: '/sign_in',
      routes: {
        '/sign_in': (context) => SignInScreen(),
      },
    );
  }
}

class AuthHelper {
  var _auth = FirebaseAuth.instance;

  //TODO: Part 1 - Instruction 1, 2
 Future<Map<String,dynamic>> signInEmailAndPassword(String email, String password) async {
    //TODO: Part 1 - Instruction 3
   try{
     //exception
  //TODO: Part 1 - Instruction 4
    final credential = await _auth.signInWithEmailAndPassword(
     email:email,
     password:password,
     );
  
     
     //TODO: Part 1 - Instruction 5
     if(credential.user!=null){
         //TODO: Part 1 - Instruction 6
       final User user = credential.user!;
       final Map<String,dynamic> map={
         'email':user.email,
         'uid':user.uid,
         'emailVerified':user.emailVerified,
         };
       //TODO: Part 1 - Instruction 7
       return map;
     }
   }catch(e){
     print(e);
   }
    return {};
  }
}

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

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
            SizedBox(height: 10),
            SignInTextField(
              controller: _passwordController,
              obscureText: true,
              hintText: 'Password',
            ),
            SizedBox(height: 21),
            SignInElevatedButton(
              onPressed: () async {
                //TODO: Part 2 - Instruction 1
                final response = await _authHelper.signInEmailAndPassword(
  _emailController.text,
  _passwordController.text,
);
                //TODO: Part 2 - Instruction 2
if (response.isNotEmpty) {
    //TODO: Part 2 - Instruction 3
  // Code for successful sign-in
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => Center(
      child: Container(
        width: 312,
        height: 205,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          backgroundColor: Colors.white,
          content: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Log in Successed', style: TextStyle(fontSize: 10)),
                Text('Email: ' + response['email'], style: TextStyle(fontSize: 10)),
                Text('uid: ' + response['uid'], style: TextStyle(fontSize: 10)),
                Text('Authentication: ' + '${response['emailVerified'] ? 'Y' : 'N'}', style: TextStyle(fontSize: 10)),
                Divider(),
                TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () => Navigator.pop(context, 'OK'),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}else {
  //TODO: Part 2 - instruction 4
    // Code for falied sign-in

  showDialog<String>(
    context: context,
    builder: (BuildContext context) => Center(
      child: AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        titleTextStyle: TextStyle(fontSize: 16),
        backgroundColor: Colors.white,
        title: const Text(
          'Login Failed',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          Divider(),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
              },
              buttonName: 'Log in',
            ),
            SizedBox(height: 21),
            SignInTextButton(
              onPressed: () {},
              buttonName: 'Forgot password?',
              color: Color(0xFF113767),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Don\'t have an account? ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SignInTextButton(
                  onPressed: () {},
                  buttonName: 'Sign up',
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
