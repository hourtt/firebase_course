// ignore_for_file: deprecated_member_use, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
      debugShowCheckedModeBanner: false,
      theme: MlTheme,
      home: const SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({
    super.key,
  });

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  AuthHelper authHelper = AuthHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 160),
            SizedBox(
              width: 50,
              height: 50,
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FMicrobook.png?alt=media&token=900d2c5c-f787-4cee-9174-dad973861f62',
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return const Text('Could not load image');
                },
              ),
            ),
            const SizedBox(height: 85),
            SizedBox(
              width: 268,
              height: 46,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffFAFAFA),
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xffDBE0E5), width: 1.0),
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 268,
              height: 46,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xffFAFAFA),
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: Color(0xffDBE0E5), width: 1.0),
                  ),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 268,
              height: 36,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0064E0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () async {
                  await authHelper
                      .signInEmailAndPassword(
                          emailController.text, passwordController.text)
                      .then((value) => authHelper.auth.currentUser != null
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInCompletePage(
                                  email: emailController.text,
                                  authHelper: authHelper,
                                ),
                              ),
                            )
                          : print('Sign in failed'));
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PasswordResetPage(
                      authHelper: authHelper,
                    ),
                  ),
                );
              },
              child: const Text(
                'Forgot password?',
                style: TextStyle(color: Color(0xff4F5D65), fontSize: 14),
              ),
            ),
            const SizedBox(height: 110),
            SizedBox(
              width: 268,
              height: 36,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  side: const BorderSide(color: Color(0xff267CE4)),
                ),
                child: const Text(
                  'Create new account',
                  style: TextStyle(
                      color: Color(0xff267CE4),
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({
    super.key,
    required this.authHelper,
  });
  final AuthHelper authHelper;

  @override
  State<PasswordResetPage> createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xffF0F2F5),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 53.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 256,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Find your account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 256,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Enter your email address.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 268,
                height: 46,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffFAFAFA),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color(0xffDBE0E5), width: 1.0),
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 21),
              SizedBox(
                width: 268,
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0064E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () async {
                    //TODO: Part 1 - Instruction 4
                    //Call the resetPassword method inside the onPressed property of the Next button
                    String email = emailController.text; // Assuming you have a TextEditingController
                    widget.authHelper.resetPassword(email);
//                     await auth.sendPasswordResetEmail(email:emailController.text);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const PasswordResetCompletePage(),
//                       ),
//                     );
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordResetCompletePage extends StatefulWidget {
  const PasswordResetCompletePage({
    super.key,
  });
  @override
  State<PasswordResetCompletePage> createState() =>
      _PasswordResetCompletePageState();
}

class _PasswordResetCompletePageState extends State<PasswordResetCompletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 53.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 256,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Confirm your account",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 256,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "We sent a link to your email. Reset your password through the link",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              SizedBox(
                width: 268,
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0064E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignInCompletePage extends StatefulWidget {
  const SignInCompletePage({
    super.key,
    required this.email,
    required this.authHelper,
  });
  final String email;
  final AuthHelper authHelper;

  @override
  State<SignInCompletePage> createState() => _SignInCompletePageState();
}

class _SignInCompletePageState extends State<SignInCompletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 53.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 256,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Welcome to Microbook",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 256,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Connect with friends, family, and communities of people who share your interests in Microbook!",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 100),
              SizedBox(
                width: 268,
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0064E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SetUpPage(
                          email: widget.email,
                          authHelper: widget.authHelper,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Set up your profile',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetUpPage extends StatefulWidget {
  const SetUpPage({super.key, required this.email, required this.authHelper});

  final String email;
  final AuthHelper authHelper;

  @override
  State<SetUpPage> createState() => _SetUpPageState();
}

class _SetUpPageState extends State<SetUpPage> {
  final TextEditingController emailController = TextEditingController();
  bool isSuccess = false;
  var auth = FirebaseAuth.instance;

  @override
  void initState() {
    emailController.text = widget.email;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 53.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 256,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Set up your profile",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: 256,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Name",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 9),
              SizedBox(
                width: 268,
                height: 46,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffFAFAFA),
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color(0xffDBE0E5), width: 1.0),
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 9),
              Container(
                width: 256,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Email",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 9),
              SizedBox(
                width: 268,
                height: 46,
                child: TextField(
                  controller: emailController,
                  enabled: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffFAFAFA),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color(0xffDBE0E5), width: 1.0),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xffDBE0E5)),
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 9),
              Container(
                width: 256,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Contact",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 9),
              SizedBox(
                width: 268,
                height: 46,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffFAFAFA),
                    hintText: 'Contact',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color(0xffDBE0E5), width: 1.0),
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 9),
              Container(
                width: 256,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Language",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 9),
              SizedBox(
                width: 268,
                height: 46,
                child: TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffFAFAFA),
                    hintText: 'Language',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color(0xffDBE0E5), width: 1.0),
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 268,
                height: 36,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0064E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                  width: 256,
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    child: const Text(
                      "Log out",
                      style: TextStyle(color: Color(0xff4F5D65), fontSize: 14),
                    ),
                    onPressed: () {
                      try {
                        //TODO: Part 2 - Instruction 2
                        //Call the logOut method in the try syntax within onPressed
                        widget.authHelper.logOut();
                        isSuccess = true;
                      } catch (e) {
                        print(e);
                      }
                      if (isSuccess) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                        isSuccess = false;
                      }
                    },
                  )),
              const SizedBox(
                height: 10,
              ),
              Container(
                  width: 256,
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    child: const Text(
                      "Delete Account",
                      style: TextStyle(color: Color(0xff4F5D65), fontSize: 14),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                        fontSize: 16, color: Color(0xff0064E0)),
                                  )),
                              TextButton(
                                onPressed:() {
                                  try {
                                    //TODO: Part 3 - Instruction 3
                                    //call the deleteAccount method in the try syntax within onPressed
                                    widget.authHelper.deleteAccount();
                                    isSuccess = true;
                                  } catch (e) {
                                    print(e);
                                  }
                                  if (isSuccess) {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInPage(),
                                      ),
                                    );
                                    isSuccess = false;
                                  }
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff1C2B33)),
                                ),
                              ),
                            ],
                            content: const Text(
                              'Are you sure you want\nto delete your account?',
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      );
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class AuthHelper {
  var auth = FirebaseAuth.instance;

  Future<void> logOut() async {
    //TODO: Part 2 - Instruction 1
    //Call the signOut method ini the logOut method of the AuthHelper class
    auth.signOut();
  }

  Future<void> deleteAccount() async {
    //TODO: Part 3 - Instruction 1
    //add currentUser!.delete() inside the deleteAccount method to delete the current user
    await auth.currentUser!.delete();
    //TODO: Part 3 - Instruction 2
    //add the signOut method inside the deleteAccount mehod to sign out
    await auth.signOut();
  }

  //TODO: Part 1 - Instruction 1
  //add the email parameter to the resetPassword method of the AuthHelper class
  Future<void> resetPassword(String email) async {
    //TODO: Part 1 - Instruction 2, 3
    //TODO: Part 1 - Instruction 2
    //Create a form of the resetPassword method using the try{} and catch {} syntax
    try{
      //TODO: Part 1 - Instruction 3
      //Call the sendPasswordResetEmail method to send an email with a link to reset the password
      await auth.sendPasswordResetEmail(email:email);
    }catch(e){
      print(e);
    }
  }

  Future<void> signInEmailAndPassword(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e);
    }
  }
}

final MlTheme = ThemeData(
  fontFamily: 'Noto Sans',
  scaffoldBackgroundColor: const Color(0xffF0F2F5),
  disabledColor: Colors.black,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    background: Color(0xffffffff),
    onBackground: Color(0xff000000),
    primary: Color(0xff0064E0),
    onPrimary: Color(0xffffffff),
    secondary: Color(0xffffffff),
    onSecondary: Color(0xff2196F3),
    error: Color(0xffEE0000),
    onError: Color(0xffffffff),
    surface: Color(0xff2196F3),
    onSurface: Color(0xffffffff),
  ),
  appBarTheme: const AppBarTheme(
      color: Color(0xffF0F2F5), centerTitle: false, elevation: 0),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
  ),
  dividerTheme: const DividerThemeData(
    thickness: 1,
    color: Color(0xffE0E0E0),
    space: 0,
  ),
  outlinedButtonTheme: const OutlinedButtonThemeData(
    style: ButtonStyle(
      padding: MaterialStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      side: MaterialStatePropertyAll(BorderSide(color: Color(0x20000000))),
      textStyle: MaterialStatePropertyAll(
        TextStyle(
          fontSize: 14,
          height: 16 / 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
      ),
    ),
  ),
);






