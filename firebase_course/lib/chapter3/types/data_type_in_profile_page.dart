import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/my_account',
      routes: {
        '/my_account': (context) => MyAccountScreen(),
      },
    );
  }
}

class MyAccountScreen extends StatefulWidget {
  MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _introductionController;

  @override
  void initState() {
    final userData = {
      //TODO: Part 2 - Instruction 1
      'email': 'microlearnable@gmail.com',
'name': 'Micro Learnable',
'bio': 'hello world~',
    };
    _emailController =
        TextEditingController(text: userData['email'] ?? 'email');
    _nameController =
        TextEditingController(text: userData['name'] ?? 'username');
    _introductionController =
        TextEditingController(text: userData['bio'] ?? 'bio');
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
        leading: TextButton(
          onPressed: () {},
          child: Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF151515),
            ),
          ),
        ),
        leadingWidth: 80,
        actions: [
          TextButton(
            onPressed: () {},
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
        child: Padding(
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
                        '',
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
                        border:
                            Border.all(color: Color(0xFFD3D3D3), width: 1.5),
                        color: Colors.white,
                      ),
                      child: GestureDetector(
                        onTap: () async {},
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
              //TODO: Part 1 - Instruction 1
               profileSection('Email',_emailController,enable:false),
               profileSection('Username',_nameController),
               profileSection('Bio',_introductionController),
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
          width: 90,
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
          width: 230,
          child: TextField(
              //TODO: Part 1 - Instruction 2
            enabled:enable,
            controller:controller,
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