import 'package:cloud_firestore/cloud_firestore.dart';
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
  Map<String, dynamic> postData = {};

  @override
  void initState() {
    //TODO: Part 1 - Instruction 1
   postData = {
	'userData': {
		'profileImg': 'https://picsum.photos/200/200',
		'email': 'microlearnable@gmail.com',
		'name': '_microlearnable',
  },
  'description': 'Micro Learnable is fun!!',
  'postImg': 'https://picsum.photos/400/400',
  'createdAt': Timestamp.now(),
  'likeList': ['james@gmail.com', 'andy@gmail.com'],
  'likeNum': 2,
};
    super.initState();
  }

  bool isLike = false;
  bool isBookmark = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GestureDetector(
        onTap: () {},
        child: Column(
          children: [
            //TODO: Part 1 - Instruction 2
            SizedBox(height: 20),
profileSection(context, postData['userData']),
SizedBox(height: 20),
imageSection(postData['postImg']),
contentSection(context, postData),
          ],
        ),
      ),
    );
  }

  Widget profileSection(BuildContext context, Map<String, dynamic> userData) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        children: [
          SizedBox(width: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(100), 
            child:Image.network(
              //TODO: Part 2 - Instruction 1
	userData['profileImg'],
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
            //TODO: Part 2 - Instruction 2
	userData['name'],
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

 Widget contentSection(BuildContext context, Map<String, dynamic> postData) {
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
              //TODO Part 3 - Instruction 1
              text: '${postData['likeNum']} ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF262626),
              ),
              children: [
                TextSpan(
                  //TODO Part 3 - Instruction 2
                  text: '${postData['likeNum'] == 1 ? 'like' : 'likes'}',
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
            text: TextSpan(
              //TODO Part 3 - Instruction 3
              text: postData['userData']['name'],
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF262626),
              ),
              children: [
                TextSpan(text: " "),
                TextSpan(
                  //TODO Part 3 - Instruction 4
                  text: postData['description'],
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
              'View all ${postData['likeNum']} comments',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF737373),
              ),
            ),
          ),
          Text(
            //TODO Part 3 - Instruction 5
            DateFormat('MMMM dd').format((postData['createdAt']).toDate()),
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