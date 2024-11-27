import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: false),
        debugShowCheckedModeBanner: false,
        initialRoute: '/sign_in',
        routes: {
          '/my_account': (context) => MyAccountScreen(),
          '/sign_in': (context) => SignInScreen(),
        },
      ),
    );
  }
}

class AuthenticationProvider with ChangeNotifier {
  UserModel? myAccount;

  void changeMyAccount(UserModel value) {
    myAccount = value;
    notifyListeners();
  }
}

class MyAccountScreen extends StatefulWidget {
  MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _introductionController;

  @override
  void initState() {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    //TODO: Part 3 - Instruction 1
    _emailController = TextEditingController(
      text:authProvider.myAccount!.email
    );
    _nameController = TextEditingController(
      text:authProvider.myAccount!.name,
    );
    _introductionController = TextEditingController(
      text:authProvider.myAccount!.introduction
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Edit profile',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF262626),
          ),
        ),
        leading: TextButton(
          onPressed: () {},
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF151515),
            ),
          ),
        ),
        leadingWidth: 80,
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Done',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Consumer<AuthenticationProvider>(builder: (_, provider, __) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Stack(
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD9D9D9),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          '',
                          width: 82,
                          height: 82,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Icon(
                              Icons.person_outline,
                              size: 44,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: Color(0xFFD3D3D3), width: 1.5),
                          color: Colors.white,
                        ),
                        child: GestureDetector(
                          onTap: () async {},
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 18,
                            color: Color(0xFF707070),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                profileSection('Email', _emailController, enable: false),
                profileSection('Username', _nameController),
                profileSection('Bio', _introductionController),
                SizedBox(height: 30),
                signOutButton(
                  title: 'Log out',
                  onTap: () {},
                  color: Color(0xFFEA333E),
                ),
                SizedBox(height: 20),
                signOutButton(
                  title: 'Delete account',
                  onTap: () {},
                  color: Color(0xFF737373),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget profileSection(
    String title,
    TextEditingController controller, {
    bool? enable = true,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 94,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF262626),
            ),
          ),
        ),
        Spacer(),
        SizedBox(
          width: 240,
          child: TextField(
            enabled: enable,
            controller: controller,
          ),
        ),
      ],
    );
  }

  Widget signOutButton({
    required String title,
    required Function() onTap,
    required Color color,
  }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ),
    );
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
                final response = await _authHelper.signInEmailAndPassword(
                  context,
                  _emailController.text,
                  _passwordController.text,
                );
                if (response) {
                  Navigator.pushNamed(context, '/my_account');
                }
              },
              buttonName: 'Log in',
            ),
            SizedBox(height: 21),
            SignInTextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/password_reset');
              },
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/sign_up');
                  },
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
          fontWeight: FontWeight.w600,
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

class UserModel {
  final String userId;
  final String? name;
  final String email;
  final String? introduction;
  final String? profileImg;
  final List<String> followers;
  final List<String> following;
  final bool isDeleted;
  final Timestamp signupAt;
  final List<String> bookmarkList;
  final List<String> likeList;

  const UserModel({
    required this.userId,
    this.name,
    required this.email,
    this.introduction,
    this.profileImg,
    required this.followers,
    required this.following,
    required this.isDeleted,
    required this.signupAt,
    required this.bookmarkList,
    required this.likeList,
  });

  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? introduction,
    String? profileImg,
    List<String>? followers,
    List<String>? following,
    bool? isDeleted,
    Timestamp? signupAt,
    List<String>? bookmarkList,
    List<String>? likeList,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      introduction: introduction ?? this.introduction,
      profileImg: profileImg ?? this.profileImg,
      followers: followers ?? List.from(this.followers),
      following: following ?? List.from(this.following),
      isDeleted: isDeleted ?? this.isDeleted,
      signupAt: signupAt ?? this.signupAt,
      bookmarkList: bookmarkList ?? List.from(this.bookmarkList),
      likeList: likeList ?? List.from(this.likeList),
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      //TODO: Part 2 - Instruction 3
      userId: map['user_id'],
      name: map['name'],
      email: map['email'],
      introduction: map['introduction'],
      profileImg: map['profile_img'],
      followers: List<String>.from(map['followers'] as List<dynamic>),
      following: List<String>.from(map['following'] as List<dynamic>),
      isDeleted: map['is_deleted'],
      signupAt: map['signup_at'],
      bookmarkList: List<String>.from(map['bookmark_list'] as List<dynamic>),
      likeList: List<String>.from(map['like_list'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_id': userId,
      'name': name,
      'email': email,
      'introduction': introduction,
      'profile_img': profileImg,
      'followers': followers,
      'following': following,
      'is_deleted': isDeleted,
      'signup_at': signupAt,
      'bookmark_list': bookmarkList,
      'like_list': likeList,
    };
  }
}

class CloudFirestoreHelper {
  var _firestore = FirebaseFirestore.instance;
  //TODO: Part 1 - Instruction 1
  Future<DocumentSnapshot<Map<String,dynamic>>> getOneUser(String userId) async {
    //TODO: Part 1 - Instruction 2
    return _firestore.collection('Users').doc(userId).get();
  }
}

class AuthHelper {
  var _auth = FirebaseAuth.instance;
  final CloudFirestoreHelper _firestoreHelper = CloudFirestoreHelper();

  Future<bool> signInEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        //TODO: Part 2 - Instruction 1
        final response = await _firestoreHelper.getOneUser(credential.user!.uid);
        //TODO: Part 2 - Instruction 2
        final UserModel user =UserModel.fromMap(response.data() as Map<String,dynamic>);
        //TODO: Part 2 - Instruction 4
       Provider.of<AuthenticationProvider>(context,listen:false).changeMyAccount(user);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
