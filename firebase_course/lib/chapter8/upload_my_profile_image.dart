import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

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
          '/sign_in': (context) => SignInScreen(),
          '/my_account': (context) => MyAccountScreen(),
          '/album': (context) => AlbumScreen(),
        },
      ),
    );
  }
}

class StorageHelper {
  var storage = FirebaseStorage.instance;
  final StreamController<String> streamController = StreamController<String>();

  Future<void> downloadProfileImage(String? imageUrl) async {
    if (imageUrl == null) return null;
    final imageRef = storage.ref().child(imageUrl);
    try {
      final url = await imageRef.getDownloadURL();
      streamController.add(url);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<Uint8List?> getImage({String? url}) async {
    //TODO: Part 1 - Instruction 1, 2, 3
    try {
      //TODO: Part 1 - Instruction 2
      final res =
          await http.get(Uri.parse(url ?? 'https://picsum.photos/300/200'));
      //TODO: Part 1 - Instruction 3
      if (res.statusCode == 200) {
        return res.bodyBytes;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> uploadProfileImage(String imageName, String imageUrl) async {
    //TODO: Part 2 - Instruction 1
    final imageRef = storage.ref().child("profile_image/$imageName.jpg");
    //TODO: Part 2 - Instruction 2
    final data = await getImage(url: imageUrl);
    //TODO: Part 2 - Instruction 3
    if (data == null) return null;
    //TODO: Part 2 - Instruction 4, 5, 6
    try {
      //TODO: Part 2 - Instruction 5
      await imageRef.putData(data, SettableMetadata(contentType: 'image/jpg'));
      //TODO: Part 2 - Instruction 6
      final url = await imageRef.getDownloadURL();
      streamController.add(url);
      return "profile_image/$imageName.jpg";
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class MyAccountScreen extends StatefulWidget {
  MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final CloudFirestoreHelper _cloudFirestoreHelper = CloudFirestoreHelper();
  final _storageHelper = StorageHelper();

  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _introductionController;

  @override
  void initState() {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    _emailController =
        TextEditingController(text: authProvider.myAccount!.email);
    _nameController = TextEditingController(text: authProvider.myAccount!.name);
    _introductionController =
        TextEditingController(text: authProvider.myAccount!.introduction);
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
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF151515),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _cloudFirestoreHelper.updateMyAccount(
                context,
                name: _nameController.text.isNotEmpty
                    ? _nameController.text
                    : null,
                introduction: _introductionController.text.isNotEmpty
                    ? _introductionController.text
                    : null,
              );
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => Center(
                  child: Container(
                    width: 312.16,
                    height: 167,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      backgroundColor: Colors.white,
                      content: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Your profile has been saved successfully',
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            Divider(),
                            TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: Size.zero,
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () => Navigator.pop(context, 'Done'),
                              child: const Text(
                                'Done',
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
            },
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
        child: Consumer<AuthenticationProvider>(
          builder: (_, provider, __) {
            _storageHelper.downloadProfileImage(provider.myAccount!.profileImg);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final image =
                              await Navigator.pushNamed(context, '/album');
                          if (image == null) {
                            return;
                          } else {
                            final imageUrl = image.toString();
                            _cloudFirestoreHelper.updateMyAccount(
                              context,
                              imageUrl: imageUrl,
                            );
                          }
                        },
                        child: Container(
                          width: 82,
                          height: 82,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFD9D9D9),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: StreamBuilder(
                                stream: _storageHelper.streamController.stream,
                                builder: (context, snapshot) {
                                  return Image.network(
                                    snapshot.data ?? '',
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
                                  );
                                }),
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
                            border: Border.all(
                                color: Color(0xFFD3D3D3), width: 1.5),
                            color: Colors.white,
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: 18,
                            color: Color(0xFF707070),
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
          },
        ),
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
                final res = await _authHelper.signInEmailAndPassword(
                  context,
                  _emailController.text,
                  _passwordController.text,
                );
                if (res) {
                  Navigator.pushNamed(context, '/my_account');
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

class CloudFirestoreHelper {
  var _firestore = FirebaseFirestore.instance;

  final StorageHelper _storageHelper = StorageHelper();

  Future<DocumentSnapshot<Map<String, dynamic>>> getOneUser(
      String userId) async {
    return _firestore.collection('Users').doc(userId).get();
  }

  void createAccount({
    required UserModel userModel,
  }) {
    _firestore.collection('Users').doc(userModel.userId).set(userModel.toMap());
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostings(String uid) async {
    return _firestore
        .collection('Posts')
        .where('user_id', isEqualTo: uid)
        .get();
  }

  void updateMyAccount(
    BuildContext context, {
    String? name,
    String? introduction,
    String? imageUrl,
  }) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final UserModel myAccount = authProvider.myAccount!;
    name = name ?? myAccount.name;
    introduction = introduction ?? myAccount.introduction;
    imageUrl = imageUrl ?? myAccount.profileImg;
    String? profileImg;
    if (imageUrl != null) {
      profileImg = await _storageHelper.uploadProfileImage(
        Timestamp.now().microsecondsSinceEpoch.toString(),
        imageUrl,
      );
    }
    final reference = _firestore.collection('Users').doc(myAccount.userId);
    reference.set({
      'name': name,
      'introduction': introduction,
      'profile_img': profileImg,
    }, SetOptions(merge: true)).whenComplete(() {
      authProvider.changeMyAccount(myAccount.copyWith(
        name: name,
        introduction: introduction,
        profileImg: profileImg,
      ));
    });
  }
}

class AuthenticationProvider with ChangeNotifier {
  UserModel? myAccount = UserModel.init();

  void changeMyAccount(UserModel value) {
    myAccount = value;
    notifyListeners();
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

  static UserModel init() => UserModel(
        userId: 'RWTgiOqE50b6hgh0Yh5Y1eCNymW2',
        email: 'email',
        followers: [],
        following: [],
        isDeleted: false,
        signupAt: Timestamp.now(),
        bookmarkList: [],
        likeList: [],
      );
}

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  int selectedIndex = -1;

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
          'Select Photo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF262626),
          ),
        ),
        leadingWidth: 80,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF151515),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, albumImages[selectedIndex]);
            },
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: GridView.builder(
            itemCount: albumImages.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (_, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: Container(
                  decoration: selectedIndex == index
                      ? BoxDecoration(
                          border: Border.all(color: Colors.red, width: 4))
                      : BoxDecoration(),
                  child: Image.network(
                    albumImages[index],
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

var albumImages = [
  'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage1.jpg?alt=media&token=c1511475-a259-48f1-80c7-6b9cb1087522',
  'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage2.jpg?alt=media&token=1dd26e16-b6e3-4c28-8f97-28747b086dae',
  'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage3.jpg?alt=media&token=c4732759-d336-4b61-b13a-8c4920764eaa',
  'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage4.jpg?alt=media&token=23953feb-163d-4466-80db-4afcaebe0809',
  'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage5.jpg?alt=media&token=ba823291-846c-406c-b701-965d2ba93d28',
  'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage6.jpg?alt=media&token=72b08192-ebad-475b-ad8a-9840e2a580f5',
  'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage7.jpg?alt=media&token=0576453c-5f2b-4406-870a-84175761c2ef',
];
var defaultImg =
    "https://firebasestorage.googleapis.com/v0/b/new-ml-6c02d.appspot.com/o/assets%2FDefaultImage.png?alt=media&token=bac50693-0a69-4d60-90d9-3b92883ae9c0";
