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
        ChangeNotifierProvider(create: (context) => PostingProvider()),
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(useMaterial3: false),
        debugShowCheckedModeBanner: false,
        initialRoute: '/sign_in',
        routes: {
          '/update': (context) => UpdateScreen(),
          '/sign_in': (context) => SignInScreen(),
        },
      ),
    );
  }
}

class CloudFirestoreHelper {
  var _firestore = FirebaseFirestore.instance;

  void updateDocument(BuildContext context, String postId) async {
    final postingProvider =
        Provider.of<PostingProvider>(context, listen: false);
    final reference = _firestore.collection('Posts').doc(postId);
    reference.update(
      {
        'description': postingProvider.controller!.text,
      },
    );
  }

  void addPostingAndUser(BuildContext context) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final postRef = _firestore.collection('Posts');
    final userRef = _firestore.collection('Users');
    final List<Map<String, dynamic>> postingModel = postingData;
    final List<Map<String, dynamic>> userModel = userData;
    final myAccount = authProvider.myAccount!;
    final thisUserRef = _firestore.collection('Users').doc(myAccount.userId);

    for (int i = 0; i < postingModel.length; i++)
      postRef.doc('ms_post $i').set(postingModel[i]).whenComplete(() {
        print('ms_post');
      });

    for (int i = 0; i < userModel.length; i++)
      userRef.doc('ms_user $i').set(userModel[i]).whenComplete(() {
        print('user');
      });
    thisUserRef.update({
      'following': FieldValue.arrayUnion(userId),
    });
    thisUserRef.update({
      'bookmark_list': FieldValue.arrayUnion(postId),
      'like_list': FieldValue.arrayUnion(postId),
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOneUser(
      String userId) async {
    return _firestore.collection('Users').doc(userId).get();
  }
}

final CloudFirestoreHelper _cloudFirestoreHelper = CloudFirestoreHelper();

List<String> userId = [
  'ms_user 0',
  'ms_user 1',
];
List<String> postId = [
  'ms_post 0',
  'ms_post 1',
  'ms_post 2',
  'ms_post 3',
];
List<Map<String, dynamic>> userData = [
  {
    'bookmark_list': [],
    'email': 'jennylovedev@microlearnable.com',
    'followers': [],
    'following': [],
    'introduction': null,
    'is_deleted': false,
    'like_list': [],
    'name': 'Jenny',
    'profile_img':
        'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FJenny.jpg?alt=media&token=526471ae-c423-4843-af8a-4c3097e4c63e',
    'signup_at': Timestamp.fromDate(DateTime(2022, 10, 25)),
    'user_id': 'ms_user 0'
  },
  {
    'bookmark_list': [],
    'email': 'healthylife@microlearnable.com',
    'followers': [],
    'following': [],
    'introduction': null,
    'is_deleted': false,
    'like_list': [],
    'name': 'Mike',
    'profile_img':
        'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FMike.jpg?alt=media&token=9ecf3c20-3e28-4d35-b4d4-7fffbdb5e382',
    'signup_at': Timestamp.fromDate(DateTime(2023, 01, 03)),
    'user_id': 'ms_user 1'
  }
];

List<Map<String, dynamic>> postingData = [
  {
    'created_at':
        Timestamp.fromDate(DateTime.now().subtract(Duration(days: 10))),
    'description':
        '💼 Started a new job at a new company! With passion and determination, \nI\'m taking on new projects. Please cheer me on! #NewEmployee #FreshStart #Challenge',
    'like_list': [],
    'like_num': 750,
    'post_id': 'ms_post 0',
    'post_img':
        'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FPost1.jpg?alt=media&token=9fa4ebed-200c-476b-9e2a-9c28ed3efda3',
    'user_id': 'ms_user 0',
  },
  {
    'created_at':
        Timestamp.fromDate(DateTime.now().subtract(Duration(days: 3))),
    'description':
        '🖥 Diving into a new project at the cafe! It\'s a joyful coding session accompanied by great ideas. #ProjectWork #CodingRoutine #Creativity',
    'like_list': [],
    'like_num': 50,
    'post_id': 'ms_post 1',
    'post_img':
        'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FPost2.jpg?alt=media&token=61b8cdb8-002f-4cc4-9b0e-2c178a1168a7',
    'user_id': 'ms_user 0',
  },
  {
    'created_at':
        Timestamp.fromDate(DateTime.now().subtract(Duration(days: 12))),
    'description':
        '🚴‍♀️ Embracing the joy of cycling lately! Any favorite bike trails you\'d recommend? #CyclingAdventures #Fitness 🚴‍♂️',
    'like_list': [],
    'like_num': 580,
    'post_id': 'ms_post 2',
    'post_img':
        'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FPost4.jpg?alt=media&token=ed132cce-43a7-491a-8078-869cad37e36d',
    'user_id': 'ms_user 1',
  },
  {
    'created_at':
        Timestamp.fromDate(DateTime.now().subtract(Duration(days: 2))),
    'description':
        '🏞️ Escaping the city heat with a refreshing hike up the mountains! Nature\'s therapy at its finest. #MountainMagic #Adventure 🌄',
    'like_list': [],
    'like_num': 20,
    'post_id': 'ms_post 3',
    'post_img':
        'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FPost3.jpg?alt=media&token=7c1aec7c-51ea-478c-9196-36cd7a5fb257',
    'user_id': 'ms_user 1',
  },
];

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CloudFirestoreHelper _cloudFirestoreHelper = CloudFirestoreHelper();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppLogo(),
              SizedBox(height: 60),
              Text(
                "To learn Chapter 7, you'll need to add a variety of users, popular posts, and more.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 22),
              Text(
                "Click the button below to add the users and posts you need to your database.",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              SignInElevatedButton(
                onPressed: () async {
                  _cloudFirestoreHelper.addPostingAndUser(context);
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Center(
                      child: AlertDialog(
                        actionsAlignment: MainAxisAlignment.center,
                        titleTextStyle: TextStyle(fontSize: 16),
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Successfully uploaded.',
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
                },
                buttonName: 'Upload',
              ),
            ],
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
                final res = await _authHelper.signInEmailAndPassword(
                  context,
                  _emailController.text,
                  _passwordController.text,
                );
                if (res) {
                  Navigator.pushNamed(context, '/update');
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

class PostModel {
  final String postId;
  final String userId;
  final String description;
  final String postImg;
  final Timestamp createdAt;
  final List<String> likeList;
  final int likeNum;

  const PostModel({
    required this.postId,
    required this.userId,
    required this.description,
    required this.postImg,
    required this.createdAt,
    required this.likeList,
    required this.likeNum,
  });

  PostModel copyWith({
    String? postId,
    String? userId,
    String? description,
    String? postImg,
    Timestamp? createdAt,
    List<String>? likeList,
    int? likeNum,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      postImg: postImg ?? this.postImg,
      createdAt: createdAt ?? this.createdAt,
      likeList: likeList ?? List.from(this.likeList),
      likeNum: likeNum ?? this.likeNum,
    );
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      postId: map['post_id'],
      userId: map['user_id'],
      description: map['description'],
      postImg: map['post_img'],
      createdAt: map['created_at'],
      likeList: List<String>.from(map['like_list'] as List<dynamic>),
      likeNum: map['like_num'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'post_id': postId,
      'user_id': userId,
      'description': description,
      'post_img': postImg,
      'created_at': createdAt,
      'like_list': likeList,
      'like_num': likeNum,
    };
  }
}

class CommentModel {
  final String commentId;
  final String userId;
  final String description;
  final Timestamp createdAt;

  const CommentModel({
    required this.commentId,
    required this.userId,
    required this.description,
    required this.createdAt,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      commentId: map['comment_id'],
      userId: map['user_id'],
      description: map['description'],
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'comment_id': commentId,
      'user_id': userId,
      'description': description,
      'created_at': createdAt,
    };
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

class PostingProvider with ChangeNotifier {
  String? imageUrl;
  TextEditingController? controller;

  void initData() {
    imageUrl = null;
    controller = TextEditingController();
    notifyListeners();
  }

  void changeImageUrl(String url) {
    imageUrl = url;
    notifyListeners();
  }

  void changeDescription(String description) {
    controller?.text = '';
  }
}

class AuthenticationProvider with ChangeNotifier {
  UserModel? myAccount;

  void changeMyAccount(UserModel value) {
    myAccount = value;
    notifyListeners();
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
        final res = await _firestoreHelper.getOneUser(credential.user!.uid);
        final UserModel user =
            UserModel.fromMap(res.data() as Map<String, dynamic>);
        Provider.of<AuthenticationProvider>(context, listen: false)
            .changeMyAccount(user);
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }
}
