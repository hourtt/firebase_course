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

class AllPostingsScreen extends StatelessWidget {
  AllPostingsScreen({super.key});

  final List<Map<String, dynamic>> postings = [
{
'user_name': 'Jacob',
'created_at': DateTime(2023, 12, 10),
'description': 'I\'m in a bad mood today',
'like_num': 10,
},
{
'user_name': 'Hannah',
'created_at': DateTime(2023, 12, 11),
'description': 'the weather is so nice here',
'like_num': 11,
},
{
'user_name': 'Ashley',
'created_at': DateTime(2023, 12, 12),
'description': 'Please follow me~ Follow me back',
'like_num': 12,
},
{
'user_name': 'Andrew',
'created_at': DateTime(2023, 12, 13),
'description': 'I\'m studying hard for Microlearnable today too',
'like_num': 13,
},
];

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
        itemCount: postings.length,
        itemBuilder: (_, index) {
          return Posting(posting: postings[index]);
        },
      ),
    );
  }
}

class Posting extends StatefulWidget {
  Posting({
    super.key,
    required this.posting,
  });

  final Map<String, dynamic> posting;

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
          profileSection(context, widget.posting['user_name']),
          SizedBox(height: 20),
          imageSection(),
          contentSection(context, widget.posting),
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

  Widget contentSection(BuildContext context, Map<String, dynamic> posting) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PostButtons(),
          SizedBox(height: 8),
          RichText(
            text: TextSpan(
                //TODO: Part 1 - Instruction 2
              text:'${posting['like_num']}',
              style:TextStyle(
                fontSize:14,
                fontWeight:FontWeight.w500,
                color:Color(0xFF262626),
              ),
                //TODO: Part 1 - Instruction 3
              children:[
                TextSpan(
                  text:'${posting['like_num']==1? 'like':'likes'}',
                  style:TextStyle(
                    fontSize:14,
                    fontWeight:FontWeight.w400,
                    color:Color(0xFF262626),
                  ),
                ),
              ],
          ),
        ), 
          SizedBox(height: 8),
          //TODO: Part 1 - Instruction 4
            Text(
              posting['user_name'],
              style:TextStyle(
                fontSize:14,
                fontWeight:FontWeight.w600,
                color:Color(0xFF262626),
              ),
            ),
          SizedBox(height: 8),
          //TODO: Part 1 - Instruction 5
            Text(
              posting['description'],
              style:TextStyle(
                fontSize:14,
                fontWeight:FontWeight.w400,
                color:Color(0xFF262626),
              ),
            ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Text(
              'View all ${posting['like_num']} comments',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF737373),
              ),
            ),
          ),
          //TODO: Part 1 - Instruction 6
            Text(
              '${DateFormat('MMMM dd').format(posting['created_at'])}',
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
}

class PostButtons extends StatefulWidget {
  const PostButtons({super.key});

  @override
  State<PostButtons> createState() => _PostButtonsState();
}

class _PostButtonsState extends State<PostButtons> {
  bool isLike = false;
  bool isBookmark = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buttons(
          onTap: () async {
            setState(() {
              isLike = !isLike;
            });
          },
          icon:
              isLike ? Icons.favorite_outlined : Icons.favorite_border_outlined,
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
    );
  }

  Widget buttons({required Function() onTap, required IconData icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon),
    );
  }
}



