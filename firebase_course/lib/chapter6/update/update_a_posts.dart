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
          '/update_posting': (context) => UpdatePostingScreen(),
          '/posting': (context) => OnePostingScreen(),
          '/sign_in': (context) => SignInScreen(),
        },
      ),
    );
  }
}

class CloudFirestoreHelper {
  var _firestore = FirebaseFirestore.instance;

  void updateDocument(BuildContext context, String postId) async {
    //TODO: Part 1 - Instruction 1
    final postingProvider = Provider.of<PostingProvider>(context,listen:false);
    //TODO: Part 1 - Instruction 2
    final reference = _firestore.collection('Posts').doc(postId);
    //TODO: Part 1 - Instruction 3
    reference.update({
      'description':postingProvider.controller!.text,
    },).whenComplete((){
      Navigator.pop(context);
    });
  }

  void addPosting(BuildContext context) async {
    final postingProvider =
        Provider.of<PostingProvider>(context, listen: false);
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final reference = _firestore.collection('Posts').doc();
    final PostModel model = PostModel(
      postId: reference.id,
      userId: authProvider.myAccount!.userId,
      description: postingProvider.controller!.text,
      postImg: "",
      createdAt: Timestamp.now(),
      likeList: [],
      likeNum: 0,
    );
    reference.set(model.toMap()).whenComplete(() {
      Navigator.popAndPushNamed(context, '/posting', arguments: reference.id);
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPostings(String uid) async {
    return _firestore
        .collection('Posts')
        .where('user_id', isEqualTo: uid)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOneUser(
      String userId) async {
    return _firestore.collection('Users').doc(userId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOnePosting(
      String postId) async {
    return _firestore.collection('Posts').doc(postId).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getComments(String postId) async {
    return _firestore
        .collection('Posts')
        .doc(postId)
        .collection('Comments')
        .get();
  }
}

class UpdatePostingScreen extends StatelessWidget {
  UpdatePostingScreen({super.key});

  final CloudFirestoreHelper _cloudFirestoreHelper = CloudFirestoreHelper();

  @override
  Widget build(BuildContext context) {
    //TODO: Part 2 - Instruction 1, 2
//     final model = ModalRoute.of(context)!.settings.arguments;
    final model = ModalRoute.of(context)!.settings.arguments as PostModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Edit Post',
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
              //TODO: Part 2 - Instruction 3
             _cloudFirestoreHelper.updateDocument(context,model.postId);
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
        child: Column(
          children: [
            SizedBox(height: 20),
            profileSection(context),
            SizedBox(height: 20),
            imageSection(context),
            textFieldSection(context),
          ],
        ),
      ),
    );
  }

  Widget profileSection(BuildContext context) {
    return Consumer<AuthenticationProvider>(
      builder: (_, provider, __) {
        return Row(
          children: [
            SizedBox(width: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                provider.myAccount!.profileImg ?? '',
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFD9D9D9),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 40,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
            SizedBox(width: 10),
            Text(
              provider.myAccount!.name ?? provider.myAccount!.email,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF262626),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget imageSection(BuildContext context) {
    return Consumer<PostingProvider>(
      builder: (_, provider, __) {
        return Container(
          width: 375,
          height: 340,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFFD9D9D9),
            image: DecorationImage(
              image: NetworkImage(
                provider.imageUrl ?? '',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: InkWell(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFFD3D3D3), width: 2),
                color: Colors.white.withOpacity(0.72),
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget textFieldSection(BuildContext context) {
    return Container(
      width: 375,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<PostingProvider>(
          builder: (_, provider, __) {
            return TextField(
              controller: provider.controller,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFF262626),
              ),
              decoration: InputDecoration(
                hintText: 'Write a caption...',
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF737373),
                ),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyPostingsScreen extends StatelessWidget {
  MyPostingsScreen({super.key});

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
            actions: [
              PopupMenu(
                items: [
                  PopupMenuModel(
                      icon: Icons.bookmark_outline,
                      title: 'Saved',
                      onTap: () {}),
                  PopupMenuModel(
                      icon: Icons.offline_bolt_outlined,
                      title: 'Likes',
                      onTap: () {}),
                ],
              ),
            ],
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
              future: _cloudFirestoreHelper.getPostings(model.userId),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return numbers(0, 'Posts');
                }
                final postings =
                    snapshot.data!.docs.map((e) => e.data()).toList();
                return numbers(postings.length, 'Posts');
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
        onPressed: () {},
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

  Widget postings(BuildContext context, String uid) {
    return FutureBuilder(
      future: _cloudFirestoreHelper.getPostings(uid),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
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
        final postings = snapshot.data!.docs.map((e) => e.data()).toList();
        if (postings.isEmpty) {
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
              onTap: () {
                Navigator.pushNamed(context, '/posting',
                    arguments: postings[index]['post_id']);
              },
              child: Image.network(
                postings[index]['post_img'],
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
      },
    );
  }
}

class PopupMenu extends StatelessWidget {
  const PopupMenu({
    super.key,
    required this.items,
    this.icon = Icons.filter_alt_outlined,
  });

  final List<PopupMenuModel> items;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        icon,
        color: Colors.black,
      ),
      iconSize: 24,
      offset: const Offset(0, -10),
      padding: const EdgeInsets.all(0),
      elevation: 25,
      constraints: const BoxConstraints(maxHeight: 100, maxWidth: 120),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFDBDBDB), width: 0.7),
        borderRadius: BorderRadius.circular(5),
      ),
      onSelected: (String value) {
        final PopupMenuModel model =
            items[items.indexWhere((element) => element.title == value)];
        model.onTap();
      },
      itemBuilder: (context) {
        final popups = <PopupMenuEntry<String>>[];
        for (final PopupMenuModel item in items) {
          popups.add(
            PopupMenuItem<String>(
              value: item.title,
              height: 28,
              textStyle: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              child: Text(
                item.title,
              ),
            ),
          );
          if (item != items.last) {
            popups.add(const PopupMenuDivider(height: 0.7));
          }
        }
        return popups;
      },
    );
  }
}

class PopupMenuModel {
  final IconData icon;
  final String title;
  final Function() onTap;

  PopupMenuModel({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}

class OnePostingScreen extends StatelessWidget {
  OnePostingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postId = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
        ),
        centerTitle: true,
        title: Text(
          'Posts',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF262626),
          ),
        ),
      ),
      body: Posting(postId: postId),
    );
  }
}

class Posting extends StatefulWidget {
  Posting({
    super.key,
    required this.postId,
  });

  final String postId;

  @override
  State<Posting> createState() => _PostingState();
}

class _PostingState extends State<Posting> {
  final CloudFirestoreHelper _cloudFirestoreHelper = CloudFirestoreHelper();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _cloudFirestoreHelper.getOnePosting(widget.postId),
      builder: (_, snapshot) {
        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return Container();
        }
        final post =
            PostModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
        return SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              if (ModalRoute.of(context)!.settings.name! == '/posting') return;
              Navigator.pushNamed(context, '/posting', arguments: post.postId);
            },
            child: Column(
              children: [
                SizedBox(height: 20),
                profileSection(context, post),
                SizedBox(height: 20),
                imageSection(post.postImg),
                contentSection(context, post),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget profileSection(BuildContext context, PostModel model) {
    return FutureBuilder(
      future: _cloudFirestoreHelper.getOneUser(model.userId),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final user =
            UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
        return GestureDetector(
          onTap: () {
            if (Provider.of<AuthenticationProvider>(context, listen: false)
                    .myAccount!
                    .userId ==
                user.userId) {
              Navigator.pushNamed(context, '/my_postings');
            } else {}
          },
          child: Row(
            children: [
              SizedBox(width: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  user.profileImg ?? '',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFD9D9D9),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 40,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 10),
              Text(
                user.name ?? user.email,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF262626),
                ),
              ),
              Spacer(),
              Provider.of<AuthenticationProvider>(context, listen: false)
                          .myAccount!
                          .userId ==
                      user.userId
                  ? PopupMenu(
                      items: [
                        PopupMenuModel(
                          icon: Icons.edit_outlined,
                          title: 'Edit',
                          onTap: () {
                            Provider.of<PostingProvider>(context, listen: false)
                                .changeDescription(model.postImg,
                                    description: model.description);
                            Navigator.pushNamed(
                              context,
                              '/update_posting',
                              arguments: model,
                            );
                          },
                        ),
                        PopupMenuModel(
                          icon: Icons.delete_outline,
                          title: 'Delete',
                          onTap: () {},
                        ),
                      ],
                      icon: Icons.more_horiz_outlined,
                    )
                  : SizedBox(),
              SizedBox(width: 16),
            ],
          ),
        );
      },
    );
  }

  Widget imageSection(String url) {
    return Image.network(
      url,
      width: 375,
      height: 340,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Image.network(
          defaultImg,
          width: 375,
          height: 340,
          fit: BoxFit.cover,
        );
      },
    );
  }

  Widget contentSection(BuildContext context, PostModel model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer<AuthenticationProvider>(
            builder: (_, provider, __) {
              final myAccount = provider.myAccount!;
              return Row(
                children: [
                  buttons(
                    onTap: () async {},
                    icon: myAccount.likeList.contains(model.postId)
                        ? Icons.favorite_outlined
                        : Icons.favorite_border_outlined,
                  ),
                  SizedBox(width: 12),
                  buttons(
                    onTap: () {},
                    icon: Icons.mode_comment_outlined,
                  ),
                  Spacer(),
                  buttons(
                    onTap: () {},
                    icon: myAccount.bookmarkList.contains(model.postId)
                        ? Icons.bookmark
                        : Icons.bookmark_outline,
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
                text: '${model.likeNum} ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF262626),
                ),
                children: [
                  TextSpan(
                    text: '${model.likeNum == 1 ? 'like' : 'likes'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF262626),
                    ),
                  ),
                ]),
          ),
          SizedBox(height: 8),
          FutureBuilder(
            future: _cloudFirestoreHelper.getOneUser(model.userId),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              final user = UserModel.fromMap(
                  snapshot.data!.data() as Map<String, dynamic>);
              return Text(
                user.name ?? user.email,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF262626),
                ),
              );
            },
          ),
          SizedBox(height: 8),
          Text(
            model.description,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF262626),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/comment', arguments: model);
            },
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: FutureBuilder(
              future: _cloudFirestoreHelper.getComments(model.postId),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return Text(
                    'View all 0 comments',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF737373),
                    ),
                  );
                }
                final comments = snapshot.data!.docs
                    .map((e) => CommentModel.fromMap(e.data()))
                    .toList();

                return Text(
                  'View all ${comments.length} comments',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF737373),
                  ),
                );
              },
            ),
          ),
          Text(
            '${DateFormat('MMMM dd').format(model.createdAt.toDate())}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF737373),
            ),
          ),
        ],
      ),
    );
  }

  Widget buttons({required Function() onTap, required IconData icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon),
    );
  }
}

class PostingProvider with ChangeNotifier {
  String? imageUrl;
  TextEditingController? controller;

  PostingProvider() {
    initData();
  }

  void initData() {
    imageUrl = '';
    controller = TextEditingController();
    notifyListeners();
  }

  void changeDescription(String url, {String? description}) {
    imageUrl = url;
    controller?.text = description ?? '';
    notifyListeners();
  }
}

class AuthenticationProvider with ChangeNotifier {
  UserModel? myAccount = UserModel.init();

  void changeMyAccount(UserModel value) {
    myAccount = value;
    notifyListeners();
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
