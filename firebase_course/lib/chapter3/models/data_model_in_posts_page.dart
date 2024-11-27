import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/all_postings',
      routes: {
        '/all_postings': (context) => AllPostingsScreen(),
      },
    );
  }
}

class AllPostingsScreen extends StatefulWidget {
  AllPostingsScreen({super.key});

  @override
  State<AllPostingsScreen> createState() => _AllPostingsScreenState();
}

class _AllPostingsScreenState extends State<AllPostingsScreen> {
  late List<PostModel> postingModels;

  @override
  void initState() {
    //TODO: Part 2 - Instruction 1
    final List<Map<String, dynamic>> postingData = [
      {
        'user_data': {
          'email': 'Jacob@gmail.com',
          'name': 'Jacob',
          'introduction': "hello. I'm Jacob.",
          'profile_img': 'https://picsum.photos/200/200',
        },
        'description': "I'm in a bad mood today",
        'post_img': 'https://picsum.photos/400/400',
        'created_at': DateTime(2023, 12, 15),
        'like_list': ['Hannah', 'Ashley', 'Andrew'],
        'like_num': 3,
      },
      {
        'user_data': {
          'email': 'Hannah@gmail.com',
          'name': 'Hannah',
          'introduction': "hello. I'm Hannah.",
          'profile_img': "https://picsum.photos/200/200",
        },
        'description': 'the weather is so nice here',
        'post_img': 'https://picsum.photos/400/400',
        'created_at': DateTime(2023, 12, 11),
        'like_list': ['Ashley', 'Andrew'],
        'like_num': 2,
      },
      {
        'user_data': {
          'email': 'Ashley@gmail.com',
          'name': 'Ashley',
          'introduction': "hello. I'm Ashley.",
          'profile_img': 'https://picsum.photos/200/200',
        },
        'description': 'Please follow me~ Follow me back',
        'post_img': 'https://picsum.photos/400/400',
        'created_at': DateTime(2023, 12, 7),
        'like_list': ['Jacob', 'Hannah'],
        'like_num': 2,
      },
      {
        'user_data': {
          'email': 'Andrew@gmail.com',
          'name': 'Andrew',
          'introduction': "hello. I'm Andrew.",
          'profile_img': 'https://picsum.photos/200/200',
        },
        'description': "I'm studying hard for Microlearnable today too",
        'post_img': 'https://picsum.photos/400/400',
        'created_at': DateTime(2023, 12, 5),
        'like_list': ['Hannah'],
        'like_num': 1,
      },
    ];
    postingModels =
        postingData.map((posting) => PostModel.fromMap(posting)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        centerTitle: false,
        title: Image.network(
          'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FMicrogram_logo.png?alt=media&token=bb3f7b8b-9275-47cf-9c30-22fee3069465',
          width: 118,
          height: 34,
        ),
        actions: [
          Icon(Icons.filter_alt_outlined, color: Colors.black),
        ],
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: postingModels.length,
        itemBuilder: (_, index) {
          return Posting(postModel: postingModels[index]);
        },
      ),
    );
  }
}

class Posting extends StatefulWidget {
  Posting({
    super.key,
    required this.postModel,
  });

  final PostModel postModel;

  @override
  State<Posting> createState() => _PostingState();
}

class _PostingState extends State<Posting> {
  bool isLike = false;
  bool isBookmark = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          profileSection(context, widget.postModel.userModel.name),
          SizedBox(height: 20),
          imageSection(),
          contentSection(context, widget.postModel),
        ],
      ),
    );
  }

  Widget profileSection(BuildContext context, String userName) {
    return Row(
      children: [
        SizedBox(width: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            'https://picsum.photos/id/${Random().nextInt(1000)}/200/200',
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
        //TODO: Part 1 - Instruction 1
        Text(
          userName,
          style:TextStyle(
            fontSize:14,
            fontWeight:FontWeight.w600,
            color:Color(0xFF262626),
          ),
        ),
        Spacer(),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz_outlined)),
        SizedBox(width: 16),
      ],
    );
  }

  Widget imageSection() {
    return Image.network(
      'https://picsum.photos/id/${Random().nextInt(1000)}/400/400',
      width: 375,
      height: 340,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          width: 375,
          height: 340,
          color: Colors.grey,
        );
      },
    );
  }

  Widget contentSection(BuildContext context, PostModel postModel) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              buttons(
                onTap: () async {
                  setState(() {
                    isLike = !isLike;
                  });
                },
                icon: isLike
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
                onTap: () {
                  setState(() {
                    isBookmark = !isBookmark;
                  });
                },
                icon: isBookmark ? Icons.bookmark : Icons.bookmark_outline,
              ),
            ],
          ),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
                //TODO: Part 1 - Instruction 2
              text:'${postModel.likeNum}',
              style:TextStyle(
                  fontSize:14,
                  fontWeight:FontWeight.w500,
                  color:Color(0xFF262626),
                ),
                children: [
                  //TODO: Part 1 - Instruction 3
                  TextSpan(
                    text: postModel.likeNum == 1 ? 'like' :'likes',
                    style:TextStyle(
                      fontSize:14,
                      fontWeight:FontWeight.w400,
                      color:Color(0xFF262626),
                    ),
                  ),
                ]),
          ),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
                //TODO: Part 1 - Instruction 4
              text:postModel.userModel.name,
              style:TextStyle(
                fontSize:14,
                fontWeight:FontWeight.w400,
                color:Color(0xFF262626),
              ),
                children: [
                  TextSpan(text: ' '),
                  TextSpan(
                      //TODO: Part 1 - Instruction 5
                    text:postModel.description,
                    style:TextStyle(
                      fontSize:14,
                      fontWeight:FontWeight.w400,
                      color:Color(0xFF262626),
                    ),
                      ),
                ]),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Text(
              'View all ${postModel.likeNum} comments',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF737373),
              ),
            ),
          ),
          //TODO: Part 1 - Instruction 6
          Text(
            '${DateFormat('MMMM dd').format(postModel.createdAt)}',
            style:TextStyle(
              fontSize:12,
              fontWeight:FontWeight.w500,
              color:Color(0xFF737373),
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

class UserModel {
  final String name;
  final String email;
  final String introduction;
  final String profileImg;

  const UserModel({
    required this.name,
    required this.email,
    required this.introduction,
    required this.profileImg,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? introduction,
    String? profileImg,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      introduction: introduction ?? this.introduction,
      profileImg: profileImg ?? this.profileImg,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    //TODO: Part 2 - Instruction 2
    return UserModel(
      name:map['name'],
      email:map['email'],
      introduction:map['introduction'],
      profileImg:map['profile_img'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'introduction': introduction,
      'profile_img': profileImg,
    };
  }

  static UserModel init() => UserModel(
        name: 'name',
        email: 'email',
        introduction: 'introduction',
        profileImg: 'profile_img',
      );
}

class PostModel {
  final UserModel userModel;
  final String description;
  final String postImg;
  final DateTime createdAt;
  final List<String> likeList;
  final int likeNum;

  const PostModel({
    required this.userModel,
    required this.description,
    required this.postImg,
    required this.createdAt,
    required this.likeList,
    required this.likeNum,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    //TODO: Part 2 - Instruction 3
    return PostModel(
      userModel:UserModel.fromMap(map['user_data']),
      description:map['description'],
      postImg:map['post_img'],
      createdAt:map['created_at'],
      likeList:List<String>.from(map['like_list'] as List<dynamic>),
      likeNum:map['like_num'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user_data': userModel,
      'description': description,
      'post_img': postImg,
      'created_at': createdAt,
      'like_list': likeList,
      'like_num': likeNum,
    };
  }

  static PostModel init() => PostModel(
        userModel: UserModel.init(),
        description: 'description',
        postImg: 'post_img',
        createdAt: DateTime.now(),
        likeList: [],
        likeNum: 0,
      );
}