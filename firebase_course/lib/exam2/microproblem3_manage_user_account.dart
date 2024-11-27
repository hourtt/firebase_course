import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SetAccountDetailsPage(),
    );
  }
}

class SetAccountDetailsPage extends StatelessWidget {
  final bool isEditing;
  String docId;
  SetAccountDetailsPage({this.isEditing = false, this.docId = ""});

  final CloudFirestoreHelper firestore = CloudFirestoreHelper();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Image.network(
              "https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FMicroshop.png?alt=media&token=793898ba-7450-4e6c-8eef-bd9650e3f4e5"),
          onPressed: () => {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_sharp, color: Colors.black),
            onPressed: () => {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () => {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () => {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => {},
          ),
        ],
      ),
      body: Column(
        children: [
          AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(
              isEditing ? 'Edit My Account Details' : 'Add My Account Details',
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            leading: isEditing
                ? IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_sharp,
                        color: Colors.black),
                    onPressed: () => {Navigator.pop(context)},
                  )
                : Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 156,
                  height: 156,
                  decoration: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person_outline_outlined,
                    color: Colors.white,
                    size: 90,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Change image',
                  style: TextStyle(fontSize: 12, color: Color(0xff494949)),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: 268,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabeledTextField(
                          label: "Name", controller: nameController),
                      LabeledTextField(
                          label: "Email", controller: emailController),
                      LabeledTextField(
                          label: "Phone number", controller: phoneController),
                      LabeledTextField(
                          label: "Location", controller: locationController),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
                BlackElevatedButton(
                    label: "Save",
                    onPressed: () async => {
                          if (isEditing)
                            {
                              //TODO: Part 3 - Instruction 4
                              //Call the updateDocument method with await in the onPressed property of the save button.
                              await firestore.updateDocument(
                                  docId,
                                  nameController.text,
                                  emailController.text,
                                  phoneController.text,
                                  locationController.text),
                            }
                          else
                            {
                              //TODO: Part 1 - Instruction 5
                              //Call the addDocument method with await in the onPressed property of the Save button. Then, set the docld variable to the return value of the method.
                              docId = await firestore.addDocument(
                                nameController.text,
                                emailController.text,
                                phoneController.text,
                                locationController.text,
                              ),
                            },
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AccountDetailsPage(
                                docId: docId,
                              ),
                            ),
                          )
                        }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AccountDetailsPage extends StatelessWidget {
  final String docId;
  AccountDetailsPage({required this.docId});

  final CloudFirestoreHelper firestore = CloudFirestoreHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Image.network(
              "https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FMicroshop.png?alt=media&token=793898ba-7450-4e6c-8eef-bd9650e3f4e5"),
          onPressed: () => {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_sharp, color: Colors.black),
            onPressed: () => {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.black),
            onPressed: () => {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
            onPressed: () => {},
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => {},
          ),
        ],
      ),
      body: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              'Add My Account Details',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 156,
                  height: 156,
                  decoration: BoxDecoration(
                    color: const Color(0xffD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person_outline_outlined,
                    color: Colors.white,
                    size: 90,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Change image',
                  style: TextStyle(fontSize: 12, color: Color(0xff494949)),
                ),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                    width: 268,
                    child: FutureBuilder(
                      //TODO: Part 2 - Instruction 3
                      //Set the future property of the FutureBuilder to the getOneUser method to display asynchronous results.
                      future: firestore.getOneUser(docId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 70,
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final user = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //TODO: Part 2 - Instruction 4
                              //Update the text value of the labeledText widget to use the field data for name, email, phone, and location from instruction3.

                              labeledText("Name", user['name']),
                              //TODO: Part 2 - Instruction 4
                              //Update the text value of the labeledText widget to use the field data for name, email, phone, and location from instruction3.

                              labeledText("Email", user['email']),
                              //TODO: Part 2 - Instruction 4
                              //Update the text value of the labeledText widget to use the field data for name, email, phone, and location from instruction3.

                              labeledText("Phone number", user['phone']),
                              //TODO: Part 2 - Instruction 4
                              //Update the text value of the labeledText widget to use the field data for name, email, phone, and location from instruction3.

                              labeledText("Location", user['location']),
                              //TODO: Part 2 - Instruction 4
                              //Update the text value of the labeledText widget to use the field data for name, email, phone, and location from instruction3.
                            ],
                          );
                        }
                      },
                    )),
                BlackElevatedButton(
                    label: "Edit",
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SetAccountDetailsPage(
                                isEditing: true,
                                docId: docId,
                              ),
                            ),
                          )
                        }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget labeledText(String label, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          width: 268,
          height: 46,
          child: Text(text, style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

class BlackElevatedButton extends StatelessWidget {
  BlackElevatedButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        minimumSize: const Size(268, 43),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  LabeledTextField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          width: 268,
          height: 46,
          child: TextField(
            controller: controller,
            cursorColor: Colors.black,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xff707072)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                )),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

class CloudFirestoreHelper {
  var db = FirebaseFirestore.instance;

  //TODO: Part 2 - Instruction 1
  //Add the docld variable as a parameter to the getOneUser method of the CloudFirestoreHelper class.

  Future<DocumentSnapshot<Map<String, dynamic>>> getOneUser(String docId) {
    //TODO: Part 2 - Instruction 2
    //Call the get method to retrieve specific user data. Then, return the retrieved data. Use the following document reference below.
    return db.collection('Users').doc(docId).get();
  }

  //TODO: Part 1 - Instruction 1
  // Add name, email, phone, location parameter to the addDocument method of the CloudFirestoreHelper class.

  Future<String> addDocument(
      String name, String email, String phone, String location) async {
    String docId = "";
    //TODO: Part 1 - Instruction 2, 3

    //TODO: Part 1 - Instruction 2
    // Create a form of the addDocument method using the try (} catch{ syntax.
    try {
      //TODO: Part 1 - Instruction 3
      //Create the docRef variable and Call the add method with await to add user data to Firestore.
      final docRef = await db.collection('Users').add({
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
      });
      //TODO: Part 1 - Instruction 4
      //Update the docld variable with the id of the created data. And return docld.
      docId = docRef.id;
    } catch (e) {
      print(e);
    }
    return docId;
  }

  //TODO: Part 3 - Instruction 1
  //Instruction 1 : Add docld, name, email, phone, location parameter to the updateDocument method of the CloudFirestoreHelper class.
  Future<void> updateDocument(String docId, String name, String email,
      String phone, String location) async {
    //TODO: Part 3 - Instruction 2, 3

    //TODO: Part 3 - Instruction 2
    //Instruction 2 : Create a form of the updateDocument method using the try{] catch{] syntax.

    try {
      //TODO: Part 3 - Instruction 3
      //Instruction 3 : Call the update method inside the instruction2 to update specific user data in the Firestore. Use the following document reference.

      await db.collection('Users').doc(docId).update({
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
      });
    } catch (e) {
      print(e);
    }
  }
}
