import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/posting',
      routes: {
        '/posting': (context) => OnePostingScreen(),
      },
    );
  }
}

class OnePostingScreen extends StatelessWidget {
  OnePostingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {},
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
      body: Posting(),
    );
  }
}

class Posting extends StatefulWidget {
  Posting({
    super.key,
  });

  @override
  State<Posting> createState() => _PostingState();
}

class _PostingState extends State<Posting> {
  late PostModel postModel;
  late UserModel userModel;

  bool isLike = false;
  bool isBookmark = false;

  Map<String, dynamic> postData = {};
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    //TODO: Part 1 - Instruction 1
   userData = {
  'email': 'microlearnable@gmail.com',
  'name': '_microlearnable',
  'introduction': 'hello~',
  'profile_img': 'https://picsum.photos/200/200',
};
postData = {
  'description': 'microlearnable is fun!',
  'post_img': 'https://picsum.photos/400/400',
  'created_at': DateTime.now(),
  'like_list': ['user1', 'user2', 'user3'],
  'like_num': 3,
};

    postModel = PostModel.fromMap(postData);
    userModel = UserModel.fromMap(userData);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            //TODO: Part 1 - Instruction 4
            SizedBox(height: 20),
profileSection(context, userModel),
SizedBox(height: 20),
imageSection(postModel.postImg),
contentSection(context, postModel, userModel),
          ],
        ),
      ),
    );
  }

  Widget profileSection(BuildContext context, UserModel userModel) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            //TODO: Part 2 - Instruction 1
            child:Image.network(
  userModel.profileImg,
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
          //TODO: Part 2 - Instruction 2
          Text(
  userModel.name,
  style: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF262626),
  ),
),
          Spacer(),
          PopupMenu(
            items: [
              PopupMenuModel(
                title: 'Edit',
                onTap: () {},
              ),
              PopupMenuModel(
                title: 'Delete',
                onTap: () {},
              ),
            ],
            icon: Icons.more_horiz_outlined,
          ),
          SizedBox(width: 16),
        ],
      ),
    );
  }

  Widget imageSection(String url) {
    return Image.network(
      url,
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

  Widget contentSection(
      BuildContext context, PostModel postModel, UserModel userModel) {
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
            //TODO:Part 3 - Instruction 1
             text: TextSpan(
  text: '${postModel.likeNum} ',
  style: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFF262626),
  ),
  children: [
//TODO: Part 3 - Instruction 2
    TextSpan(
      text: postModel.likeNum == 1 ? 'like' : 'likes',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF262626),
      ),
    ),
  ],
),
          ),
          SizedBox(height: 8),
          RichText(
            //TODO: Part 3 - Instruction 3 
          text: TextSpan(
  text: userModel.name,
  style: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF262626),
  ),
  children: [
    //TODO: Part 3 - Instruction 4
    TextSpan(text: ' '),
    TextSpan(
      text: postModel.description,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF262626),
      ),
    ),
  ],
),

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
          //TODO: Part 3 - Instruction 5
          Text(
             '${DateFormat('MMMM dd').format(postModel.createdAt)}',
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
  final String title;
  final Function() onTap;

  PopupMenuModel({
    required this.title,
    required this.onTap,
  });
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
    //TODO: Part 1 - Instruction 2
    return UserModel(
  name: map['name'],
  email: map['email'],
  introduction: map['introduction'],
  profileImg: map['profile_img'],
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
        name: 'username',
        email: 'email',
        introduction: 'introduction',
        profileImg: 'profile_img',
      );
}

class PostModel {
  final String description;
  final String postImg;
  final DateTime createdAt;
  final List<String> likeList;
  final int likeNum;

  const PostModel({
    required this.description,
    required this.postImg,
    required this.createdAt,
    required this.likeList,
    required this.likeNum,
  });

  PostModel copyWith({
    String? description,
    String? postImg,
    DateTime? createdAt,
    List<String>? likeList,
    int? likeNum,
  }) {
    return PostModel(
      description: description ?? this.description,
      postImg: postImg ?? this.postImg,
      createdAt: createdAt ?? this.createdAt,
      likeList: likeList ?? List.from(this.likeList),
      likeNum: likeNum ?? this.likeNum,
    );
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    //TODO: Part 1 - Instruction 3
   return PostModel(
  description: map['description'],
  postImg: map['post_img'],
  createdAt: map['created_at'],
  likeList: List<String>.from(map['like_list'] as List<dynamic>),
  likeNum: map['like_num'],
);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'description': description,
      'post_img': postImg,
      'created_at': createdAt,
      'like_list': likeList,
      'like_num': likeNum,
    };
  }

  static PostModel init() => PostModel(
        description: 'description',
        postImg: 'post_img',
        createdAt: DateTime.now(),
        likeList: [],
        likeNum: 0,
      );
}