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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
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
                onPressed: () {},
                child: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpEmailPage(),
                    ),
                  );
                },
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

class SignUpEmailPage extends StatefulWidget {
  const SignUpEmailPage({
    super.key,
  });
  @override
  State<SignUpEmailPage> createState() => _SignUpEmailPageState();
}

class _SignUpEmailPageState extends State<SignUpEmailPage> {
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
                  "What's your email?",
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
                  "Enter the email where you can be contacted. No one will see this on your profile.",
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPasswordPage(
                          email: emailController.text,
                        ),
                      ),
                    );
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

class SignUpPasswordPage extends StatefulWidget {
  const SignUpPasswordPage({
    super.key,
    required this.email,
  });
  final String email;
  @override
  State<SignUpPasswordPage> createState() => _SignUpPasswordPageState();
}

class _SignUpPasswordPageState extends State<SignUpPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  AuthHelper authHelper = AuthHelper();
  var auth = FirebaseAuth.instance;
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
                  "Create a password",
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
                  "Create a password with at least 6 letters or numbers. It should be something others can’t guess.",
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
                     await authHelper.signUpEmailAndPassword(
                      //* Use Widget.email instead of emailController.text
                        widget.email,
                        passwordController.text,
                     );
                    //TODO: Part 2 - Instruction 3
                    if (auth.currentUser!= null) {
                      //TODO: Part 2 - Instruction 4
                      auth.currentUser!.sendEmailVerification();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpVerificationPage(
                            authHelper: authHelper,
                          ),
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Sign up failed.\nPlease check the console',
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Divider(),
                                SizedBox(
                                  height: 12,
                                ),
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
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

class SignUpVerificationPage extends StatefulWidget {
  const SignUpVerificationPage({
    super.key,
    required this.authHelper,
  });
  final AuthHelper authHelper;

  @override
  State<SignUpVerificationPage> createState() => _SignUpVerificationPageState();
}

class _SignUpVerificationPageState extends State<SignUpVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
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
                  "Email verification",
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
                  "To confirm your account, complete the email verification sent to your email.",
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
                    widget.authHelper.auth.currentUser!.reload();
                    if (widget.authHelper.auth.currentUser!.emailVerified) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpCompletePage(),
                        ),
                      );
                    } else {
                      //에러 dialog
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Please complete the email \nverification',
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Divider(),
                                SizedBox(
                                  height: 12,
                                ),
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
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

class SignUpCompletePage extends StatefulWidget {
  const SignUpCompletePage({
    super.key,
  });
  @override
  State<SignUpCompletePage> createState() => _SignUpCompletePageState();
}

class _SignUpCompletePageState extends State<SignUpCompletePage> {
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
                  "Sign up completed!",
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
                  onPressed: () {},
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

class AuthHelper {
  var auth = FirebaseAuth.instance;

  Future<void> sendEmailVerification() async {
//TODO: Part 2 - Instruction 1
  try{
    //TODO: Part 2 - Instruction 2
     await auth.currentUser!.sendEmailVerification();
  }catch(e){
    print(e);
  } 
  }

//TODO: Part 1 - Instruction 1
  Future<void> signUpEmailAndPassword(String email, String password) async {
//TODO: Part 1 - Instruction 2, 3
   //TODO: Part 1 - Instruction 2
    try{
      //TODO: Part 1 - Instruction 3
      await auth.createUserWithEmailAndPassword(
        email:email,
        password:password,
      );
    }catch(e){
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





