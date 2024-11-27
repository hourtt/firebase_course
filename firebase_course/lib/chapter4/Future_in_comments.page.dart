import 'dart:math';

import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  Widget refreshButton() {
    //TODO: Part 1 - Instruction 1, 2, 3
    return IconButton(
      onPressed:(){
        setState((){
          
        });
      },
        icon:Icon(Icons.refresh),
        color:Colors.black,
     );
  }

  Future<List<CommentModel>> getComments() async {
    //TODO: Part 2 - Instruction 1
   await  Future.delayed(Duration(seconds:Random().nextInt(4)+2));
    //TODO: Part 2 - Instruction 2
    presetComments.sort((a,b)=>a.createdAt.compareTo(b.createdAt),);
//TODO: Part 2 - Instruction 3
    return presetComments;
//     return [];
  }

  Widget commentSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 86),
      //TODO: Part 3 - Instruction 1
      child: FutureBuilder(
        future:getComments(),
        builder:(_,snapshot){
          //TODO: Part 3 - Instruction 2
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(
             child: CircularProgressIndicator(),
            );
          }
          //TODO: Part 3 - Instruction 3
          final loadedComments = snapshot.data!;
          //TODO: Part 3 - Instruction 4
          return commentList(loadedComments);
        },
      ),
    );
  }

  void addComment({
    required String comment,
  }) async {
    final CommentModel model = CommentModel(
      name: 'Me',
      description: comment,
      createdAt: DateTime.now(),
      image: 'https://picsum.photos/id/$randomImageId/200/200',
    );
    presetComments.add(model);
  }

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
          'Comments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF262626),
          ),
        ),
        actions: [
          refreshButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(15, 16, 15, 12),
              child: postSection(context),
            ),
            Divider(),
            commentSection(context),
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
            'https://picsum.photos/id/675/200/200',
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
              'MicroLearnable',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF262626),
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Let\'s communicate',
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

  Widget commentList(List<CommentModel> loadedComments) {
    return Column(
      children: List.generate(
        loadedComments.length,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  '${loadedComments[index].image}',
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
                    Text(
                      '${loadedComments[index].name}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF262626),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      loadedComments[index].description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF262626),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget commentInputSection(BuildContext context) {
    final TextEditingController _commentController = TextEditingController();
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
              'https://picsum.photos/id/$randomImageId/200/200',
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
                    addComment(comment: _commentController.text);
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
  }
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

void main() async {
  runApp(MyApp());
}

class CommentModel {
  final String name;
  final String description;
  final DateTime createdAt;
  final String image;

  const CommentModel({
    required this.name,
    required this.description,
    required this.createdAt,
    required this.image,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      name: map['name'],
      description: map['description'],
      createdAt: map['created_at'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'created_at': createdAt,
      'image': image,
    };
  }
}

List<CommentModel> presetComments = [
  CommentModel(
    name: 'James',
    description: 'I\'m in a bad mood today',
    createdAt: DateTime(2023, 5, 30),
    image: 'https://picsum.photos/id/128/200/200',
  ),
  CommentModel(
    name: 'Andy',
    description: 'the weather is so nice here',
    createdAt: DateTime(2023, 4, 8),
    image: 'https://picsum.photos/id/442/200/200',
  ),
  CommentModel(
    name: 'Olivia',
    description: 'I\'m studying hard for Microlearnable today too',
    createdAt: DateTime(2024, 1, 3),
    image: 'https://picsum.photos/id/154/200/200',
  ),
];

final randomImageId = 100 + Random().nextInt(23) * 7;