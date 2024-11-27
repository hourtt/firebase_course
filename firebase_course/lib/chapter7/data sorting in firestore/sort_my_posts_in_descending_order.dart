import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          '/my_postings': (context) => MyPostingsScreen(),
          '/sign_in': (context) => SignInScreen(),
        },
      ),
    );
  }
}

class CloudFirestoreHelper {
  var _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getOnePosting(
      String postId) async {
    return _firestore.collection('Posts').doc(postId).get();
  }

  Future<int> getPostingNum(String uid) async {
    final res = await _firestore
        .collection('Posts')
        .where('user_id', isEqualTo: uid)
        .get();
    return res.docs.length;
  }

  //TODO: Part 1 - Instruction 1
  Future<QuerySnapshot<Map<String,dynamic>>> getPostings(String uid) async {
    //TODO: Part 1 - Instruction 2
    return _firestore.collection('Posts').where('user_id',isEqualTo:uid).orderBy('created_at',descending:true).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOneUser(
      String userId) async {
    return _firestore.collection('Users').doc(userId).get();
  }
}

class MyPostingsScreen extends StatelessWidget {
  MyPostingsScreen({super.key});

  Widget postings(BuildContext context, String uid) {
    //TODO: Part 2 - Instruction 1, 2, 3, 4
    return FutureBuilder(
      future:_cloudFirestoreHelper.getPostings(uid),
      builder:(_,snapshot){
        //TODO: Part 2 - Instruction 2
        if(snapshot.connectionState ==ConnectionState.waiting ||!snapshot.hasData){
          return noPostings();
        }
        //TODO: Part 2 - Instruction 3
        final postings = snapshot.data!.docs.map((e)=>PostModel.fromMap(e.data())).toList();
        //TODO: Part 2 - Instruction 4
        if(postings.isEmpty){
          return noPostings();
        }
        return postingsGridView(postings);
      },
    );
  }

  final CloudFirestoreHelper _cloudFirestoreHelper = CloudFirestoreHelper();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (_, provider, __) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: true,
            title: Text(
              provider.myAccount!.name ?? provider.myAccount!.email,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF262626),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    accountInfo(provider.myAccount!),
                    SizedBox(height: 8),
                    profileEditButton(context),
                    SizedBox(height: 12),
                    postings(context, provider.myAccount!.userId),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget accountInfo(UserModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                  model.profileImg ?? '',
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
            SizedBox(width: 44),
            FutureBuilder(
              future: _cloudFirestoreHelper.getPostingNum(model.userId),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return numbers(0, 'Posts');
                }
                return numbers(snapshot.data ?? 0, 'Posts');
              },
            ),
            numbers(model.followers.length, 'Followers'),
            numbers(model.following.length, 'Following'),
          ],
        ),
        SizedBox(height: 7),
        Text(
          model.name ?? model.email,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF262626),
          ),
        ),
        SizedBox(height: 5),
        model.introduction != null
            ? Text(
                model.introduction!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF262626),
                ),
              )
            : SizedBox(),
      ],
    );
  }

  Widget numbers(int num, String title) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Text(
            NumberFormat('###,###,###', 'en_US').format(num),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF262626),
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF262626),
            ),
          ),
        ],
      ),
    );
  }

  Widget profileEditButton(BuildContext context) {
    return SizedBox(
      width: 343,
      height: 36,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/my_account');
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: Color(0xFF262626),
          backgroundColor: Color(0xFFEFEFEF),
          elevation: 0,
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: Text('Edit profile'),
      ),
    );
  }

  Widget postingsGridView(List<PostModel> postings) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: postings.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (_, index) {
        return InkWell(
          onTap: () {},
          child: Image.network(
            postings[index].postImg,
            width: 112,
            height: 112,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) {
              return Image.network(
                defaultImg,
                width: 112,
                height: 112,
                fit: BoxFit.cover,
              );
            },
          ),
        );
      },
    );
  }

  Widget noPostings() {
    return Padding(
      padding: EdgeInsets.only(top: 160),
      child: Text(
        'No posts yet',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
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
                  Navigator.pushNamed(context, '/my_postings');
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

var defaultImg =
    "https://firebasestorage.googleapis.com/v0/b/new-ml-6c02d.appspot.com/o/assets%2FDefaultImage.png?alt=media&token=bac50693-0a69-4d60-90d9-3b92883ae9c0";
