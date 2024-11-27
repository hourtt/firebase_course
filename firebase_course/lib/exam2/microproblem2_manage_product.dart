import 'package:flutter/material.dart';
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
      home: AddProductPage(),
    );
  }
}

class AddProductPage extends StatelessWidget {
  final bool isEditing;
  final String name;
  final String price;
  final String explanation;
  String docId;

  AddProductPage(
      {this.isEditing = false,
        this.name = "",
        this.price = "",
        this.explanation = "",
        this.docId = ""});

  final CloudFirestoreHelper firestore = CloudFirestoreHelper();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController explanationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = name;
    priceController.text = price;
    explanationController.text = explanation;

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
              isEditing ? 'Edit a product' : 'Add a product',
              style: TextStyle(fontSize: 16, color: Colors.black),
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
                SizedBox(
                    width: 156,
                    height: 156,
                    child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FShoes.png?alt=media&token=de6829d9-f2ec-4522-8dd7-315fc44713b9")),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: 268,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LabeledTextField(
                          label: "Product Name", controller: nameController),
                      LabeledTextField(
                          label: "Price", controller: priceController),
                      LabeledTextField(
                        label: "Detailed Explanation",
                        controller: explanationController,
                        height: 100,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
                BlackElevatedButton(
                    label: isEditing ? "Edit" : "Save",
                    onPressed: () async => {
                      if(isEditing){
                        //TODO: Part 3 - Instruction 4
                        //Call the updateDocument method with await in the onPressed property of the Edit button.
                         await firestore.updateDocument(
                          docId,
                          nameController.text,
                          priceController.text,
                          explanationController.text,
                        )

                      } else {
                        //TODO: Part 1 - Instruction 5
                        //Call the addDocument method with await in the onPressed property of the Save button. Then, set the docld variable to the return value of the method.
                       docId= await firestore.addDocument(
                         nameController.text,
                         priceController.text,
                         explanationController.text,
                       ),
                      },
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsPage(
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

class ProductDetailsPage extends StatelessWidget {
  final String docId;

  ProductDetailsPage({
    required this.docId,
  });

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              elevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'Product details',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                      width: 156,
                      height: 156,
                      child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FShoes.png?alt=media&token=de6829d9-f2ec-4522-8dd7-315fc44713b9")),
                  const SizedBox(
                    height: 12,
                  ),
                  FutureBuilder(
                    //TODO: Part 2 - Instruction 3
                    //Set the future property of the FutureBuilder to the getOneDocument method to display asynchronous results.
                    future: firestore.getOneDocument(docId),
                    builder: (context, snapshot) {

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container(
                          height: 70,
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final product = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            //TODO: Part 2 - Instruction 4
                            //Update the value of the text widget to use the field data for name, price, explanation from instruction3.
                            Text(
                              product["name"],
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            SizedBox(
                              height: 12,
                            ),

                           //TODO: Part 2 - Instruction 4
                            //Update the value of the text widget to use the field data for name, price, explanation from instruction3.
                            Text(
                              product["price"],
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Divider(),
                            SizedBox(
                              height: 18,
                            ),
                            SizedBox(
                              width: 268,

                              //TODO: Part 2 - Instruction 4
                            //Update the value of the text widget to use the field data for name, price, explanation from instruction3.
                              child: Text(
                                product["explanation"],
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            BlackElevatedButton(
                                label: "Edit",
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddProductPage(
                                        isEditing: true,
                                        //TODO: Part 2 - Instruction 5
                                        //Update the property of the AddProductPage to use the field data for name, price, explanation from instruction3.
                                        
                                        name: snapshot.data!["name"],
                                        //TODO: Part 2 - Instruction 5                                        
                                        //Update the property of the AddProductPage to use the field data for name, price, explanation from instruction3.

                                        price: snapshot.data!["price"],
                                        //TODO: Part 2 - Instruction 5                                        //Update the property of the AddProductPage to use the field data for name, price, explanation from instruction3.
                                        //Update the property of the AddProductPage to use the field data for name, price, explanation from instruction3.

                                        explanation: snapshot.data!["explanantion"],
                                        docId: docId,
                                      ),
                                    ),
                                  )
                                }),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}

class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  double height;

  LabeledTextField(
      {required this.label, required this.controller, this.height = 52});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 4,
        ),
        SizedBox(
          width: 268,
          height: height,
          child: TextField(
            controller: controller,
            cursorColor: Colors.black,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color(0xff707072)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            maxLines: 4,
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }
}


class CloudFirestoreHelper {
  var db = FirebaseFirestore.instance;

  //TODO: Part 2 - Instruction 1
  //Add docld parameter to the getOneDocument method of the CloudFirestoreHelper class.
  Future<DocumentSnapshot<Map<String, dynamic>>> getOneDocument(String docId) async {
    //TODO: Part 2 - Instruction 2
    //Call the get method from Firebase to retrieve specific user data inside instruction1. Use the following document reference below. Then, return the result.
    return db.collection('Products').doc(docId).get();
  }
  //TODO: Part 1 - Instruction 1
  //Add name, price, explanation parameter to the addDocument method of the CloudFirestoreHelper class.

  Future<String> addDocument(String name, String price, String explanation) async {
    String docId = "";
    //TODO: Part 1 - Instruction 2, 3, 4
    
    //TODO: Part 1 - Instruction 2
    //Create a form of addDocument method using the try(} catch{} syntax.
    try{
      
      //TODO: Part 1 - Instruction 3
      //Create the docRef Variable and call the add method with await to add user data to Firestore.
      final docRef = await db.collection('Products').add({
        'name':name,
        'price':price,
        'explanation':explanation,
      });
      //TODO: Part 1 - Instruction 4
      //Update the docld variable with the id of the created data. And return docld.
      docId = docRef.id;
    }catch(e){
      print(e);
    }
    return docId;
  }
  //TODO: Part 3 - Instruction 1
  Future<void> updateDocument(String docId, String name, String price, String explanation) async {
    //TODO: Part 3 - Instruction 2, 3
    
    //TODO: part 3 - Instruction 2
    try{
      //TODO: Part 3 - Instruction 3
     await db.collection('Products').doc(docId).update({
        'name':name,
        'price':price,
        'explanation':explanation,
      });
    }catch(e){
      print(e);
    }
  }
}






