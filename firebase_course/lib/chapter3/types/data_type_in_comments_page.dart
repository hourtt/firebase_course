import 'dart:math';

import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/comment',
      routes: {
        '/comment': (context) => CommentScreen(),
      },
    );
  }
}

class CommentScreen extends StatelessWidget {
  CommentScreen({super.key});
  final List<Map<String, dynamic>> comments = [
    //TODO: Part 2 - Instruction 1
  {'name': 'Jacob', 'description': "I'm in a bad mood today"},
  {'name': 'Hannah', 'description': 'the weather is so nice here'},
  {'name': 'Ashley', 'description': 'Please follow me~ Follow me back'},
  {'name': 'Andrew', 'description': "I'm studying hard for Microlearnable today too"},
  ];

  @override
  Widget build(BuildContext context) {
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
              child: postSection(context),
            ),
            Divider(),
            commentSection(context, comments),
          ],
        ),
      ),
      bottomSheet: commentInputSection(context),
    );
  }

  Widget postSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            'https://picsum.photos/200/200',
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
              '_microlearnable',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF262626),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'microlearnable is fun.\nIs everyone doing well?',
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
  }

  Widget commentSection(
      BuildContext context, List<Map<String, dynamic>> comments) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 86),
      child: Column(
        children: List.generate(
          comments.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SizedBox(width: 14),
                SizedBox(
                  width: 265,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO: Part 1 - Instruction 1
                      Text(
                        '${comments[index]['name']}',
                        style:TextStyle(
                          fontSize:14,
                          fontWeight:FontWeight.w600,
                          color:Color(0xFF262626),
                        ),
                      ),
                      SizedBox(height: 12),
                      //TODO: Part 1 - Instruction 2
                      Text(
                        '${comments[index]['description']}',
                        style:TextStyle(
                          fontSize:14,
                          fontWeight:FontWeight.w400,
                          color:Color(0xFF262626),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget commentInputSection(BuildContext context) {
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
          SizedBox(width: 16),
          SizedBox(
            width: 287,
            child: TextField(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF737373),
              ),
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
                  onPressed: () {},
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
  }
}



