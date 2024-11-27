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
          '/comment': (context) => CommentScreen(),
          '/posting': (context) => OnePostingScreen(),
          '/my_postings': (context) => MyPostingsScreen(),
          '/sign_in': (context) => SignInScreen(),
        },
      ),
    );
  }
}

class CloudFirestoreHelper {
  var _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getComments(String postId) async {
    return _firestore
        .collection('Posts')
        .doc(postId)
        .collection('Comments')
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCommentsStream(String postId) {
    //TODO: Part 1 - Instruction 1
    return _firestore.collection('Posts').doc(postId).collection('Comments').orderBy('created_at').snapshots();
  }

  void addComment(
    BuildContext context, {
    required String content,
    required String postId,
  }) async {
    final myAccount =
        Provider.of<AuthenticationProvider>(context, listen: false).myAccount!;
    final reference =
        _firestore.collection('Posts').doc(postId).collection('Comments').doc();
    final CommentModel model = CommentModel(
      commentId: reference.id,
      userId: myAccount.userId,
      description: content,
      createdAt: Timestamp.now(),
    );
    reference.set(model.toMap());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOnePosting(
      String postId) async {
    return _firestore.collection('Posts').doc(postId).get();
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
      Navigator.pop(context);
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getOneUser(
      String userId) async {
    return _firestore.collection('Users').doc(userId).get();
  }
}

class CommentScreen extends StatelessWidget {
  CommentScreen({super.key});

  final CloudFirestoreHelper _cloudFirestoreHelper = CloudFirestoreHelper();

  @override
  Widget build(BuildContext context) {
    final model = ModalRoute.of(context)!.settings.arguments as PostModel;
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
          'Comments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF262626),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 16, 15, 12),
              child: postSection(context, model),
            ),
            Divider(),
            commentSection(context, model),
          ],
        ),
      ),
      bottomSheet: commentInputSection(context, model),
    );
  }

  Widget postSection(BuildContext context, PostModel model) {
    return FutureBuilder(
      future: _cloudFirestoreHelper.getOneUser(model.userId),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        final user =
            UserModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name ?? user.email,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF262626),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  model.description,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF262626),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget commentSection(BuildContext context, PostModel model) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 86),
      //TODO: Part 2 - Instruction 1, 2, 3, 4
      child: StreamBuilder(
        stream:_cloudFirestoreHelper.getCommentsStream(model.postId),
        builder:(_,snapshot){
          //TODO: Part 2 - Instruction 2
          if(!snapshot.hasData){
            return Container();
          }
          //TODO: Part 2 - Instruction 3
          final comments = snapshot.data!.docs.map((e)=>CommentModel.fromMap(e.data())).toList();
  //TODO: Part 2 - Instruction 4
          return Column(
            children:List.generate(
              comments.length,
              (index)=>FutureBuilder(
              future:_cloudFirestoreHelper.getOneUser(comments[index].userId),
                builder:(_,snapshot){
                  if(!snapshot.hasData || snapshot.data!.data()==null){
                    return Container();
                  }
                  final user = UserModel.fromMap(snapshot.data!.data() as Map<String,dynamic>);
                  return Padding(
                    padding:EdgeInsets.only(bottom:16),
                    child:Row(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children:[
                        ClipRRect(
                          borderRadius:BorderRadius.circular(100),
                          child:Image.network(
                            user.profileImg??'',
                            width:40,
                            height:40,
                            fit:BoxFit.cover,
                            errorBuilder:(_,__,___){
                              return Container(
                                decoration:BoxDecoration(
                                  shape:BoxShape.circle,
                                  color:Color(0xFFD9D9D9),
                                ),
                                child:Icon(
                                  Icons.person_outline,
                                  size:40,
                                  color:Colors.white,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width:14),
                        Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children:[
                            Text(
                              user.name ?? user.email,
                              style:TextStyle(
                                fontSize:14,
                                fontWeight:FontWeight.w600,
                                color:Color(0xFF262626),
                              ),
                            ),
                            SizedBox(height:12),
                            SizedBox(
                              width:265,
                              child:Text(
                                comments[index].description,
                                style:TextStyle(
                                  fontSize:14,
                                  fontWeight:FontWeight.w400,
                                  color:Color(0xFF262626),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
//In micro, they suggest us to use Provider.of<AuthProvider> but it's doesn't work so i use 
//Provider.of<AuthenticationProvider> instead
                        Provider.of<AuthenticationProvider>(context,listen:false).myAccount!.userId == user.userId ? GestureDetector(
                          onTap:(){}, 
                          child:Icon(Icons.delete_outline,size:18),
                        ) : SizedBox(),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        }
      ),
    );
  }

  Widget commentInputSection(BuildContext context, PostModel model) {
    final TextEditingController _commentController = TextEditingController();
    return Consumer<AuthenticationProvider>(
      builder: (_, provider, __) {
        return Container(
          height: 70,
          width: 375,
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(16, 0, 16, 30),
          child: Row(
            children: [
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
              SizedBox(width: 16),
              SizedBox(
                width: 287,
                child: TextField(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF737373),
                  ),
                  controller: _commentController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDBDBDB)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFDBDBDB)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hoverColor: Colors.transparent,
                    hintText: 'Add a comment...',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF737373),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    suffixIcon: TextButton(
                      onPressed: () {
                        _cloudFirestoreHelper.addComment(
                          context,
                          content: _commentController.text,
                          postId: model.postId,
                        );
                        _commentController.clear();
                      },
                      child: Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3C95EF),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
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
            } else {
              Navigator.pushNamed(context, '/other_postings', arguments: user);
            }
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
                    onTap: () {
                      Navigator.pushNamed(context, '/comment',
                          arguments: model);
                    },
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
                    onTap: () =>
                        Navigator.pushNamed(context, '/bookmark_postings'),
                  ),
                  PopupMenuModel(
                    icon: Icons.offline_bolt_outlined,
                    title: 'Likes',
                    onTap: () => Navigator.pushNamed(context, '/like_postings'),
                  ),
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

class MyAccountScreen extends StatefulWidget {
  MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final CloudFirestoreHelper _cloudFirestoreHelper = CloudFirestoreHelper();

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
              Navigator.pushNamed(context, '/my_postings');
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
                            provider.myAccount!.profileImg ?? '',
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
                            border: Border.all(
                                color: Color(0xFFD3D3D3), width: 1.5),
                            color: Colors.white,
                          ),
                          child: GestureDetector(
                            onTap: () {},
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
  UserModel? myAccount = UserModel.init();

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
