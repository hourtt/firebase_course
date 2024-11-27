// ignore_for_file: unused_import, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// * Comment for installing ratting bar package: flutter pub add flutter_rating_bar
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

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
      home: ReviewsPage(),
    );
  }
}

class ReviewsPage extends StatelessWidget {
  final CloudFirestoreHelper firestore = CloudFirestoreHelper();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController explanationController = TextEditingController();
  int _rating = 0;
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
                elevation: 0,
                backgroundColor: Colors.white,
                centerTitle: true,
                title: const Text(
                  'Reviews',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_sharp,
                      color: Colors.black),
                  onPressed: () => {Navigator.pop(context)},
                )),
            Container(
              height: 63,
              color: const Color(0xffF3F3F3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 40,
                      height: 40,
                      child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2FShoes.png?alt=media&token=de6829d9-f2ec-4522-8dd7-315fc44713b9")),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text("Micro Running shoes",
                          style: TextStyle(
                            fontSize: 14,
                          )),
                      SizedBox(
                        height: 4,
                      ),
                      Text("\$16",
                          style: TextStyle(
                            fontSize: 14,
                          )),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 268,
                    alignment: Alignment.centerLeft,
                    child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                      itemBuilder: (context, index) => Icon(
                        index < _rating ? Icons.star : Icons.star_border,
                        color: Colors.black,
                      ),
                      itemSize: 25,
                      onRatingUpdate: (rating) {
                        _rating = rating.toInt();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 268,
                    child: TextField(
                      controller: explanationController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Add a review',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                      maxLines: 4,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    width: 268,
                    child: TextButton(
                      onPressed: () {
                        //TODO: Part 1 - Instruction 4
                        //Call the addDocument method in the onPressed property of the Save button.
                        firestore.addDocument(
                          nameController.text,
                          rateController.text,
                          explanationController.text,
                        );
                        explanationController.clear();
                        _rating = 0;
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    color: Color(0xffA6A6A7),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    //TODO: Part 2 - Instruction 2
                    //Set the stream property of the StreamBuilder to the getAllReviews method to display asynchronous results.
                    stream: firestore.getAllReviews(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (!snapshot.hasData) {
                        return const Text("There are no data");
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      return Container(
                        height: 250,
                        alignment: Alignment.center,
                        child: ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            //TODO: Part 2 - Instruction 3
                            DocumentSnapshot review =
                                snapshot.data!.docs[index];

                            //TODO: Part 2 - Instruction 4
                            //Update each widget property of the ListTile to use the field data for rating, explanation, and date from instruction3.
                            int rating = review['rate'] ?? 0;

                            //TODO: Part 2 - Instruction 4
                            //Update each widget property of the ListTile to use the field data for rating, explanation, and date from instruction3.
                            String explanation = review['explanation'] ?? "";

                            //TODO: Part 2 - Instruction 4
                            //Update each widget property of the ListTile to use the field data for rating, explanation, and date from instruction3.
                            DateTime date = review['date']
                                .DateFormat('MMM d, yyyy')
                                .format(DateTime(1, 1, 1));

                            return ListTile(
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                    rating,
                                    (index) => const Icon(
                                          Icons.star,
                                          color: Colors.black,
                                        )),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text("\"" + explanation + "\"",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      )),
                                  Row(children: [
                                    Text(
                                      "Mable,  ",
                                      style: TextStyle(fontSize: 14),
                                    ),

                                    //TODO: Part 2 - Instruction 4
                                    Text('$date',
                                        style: const TextStyle(fontSize: 14)),
                                    Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        //TODO: Part 3 - Instruction 4
                                        firestore.deleteDocument(review.id);
                                      },
                                      icon: const Icon(Icons.delete_outline),
                                      iconSize: 20,
                                    )
                                  ])
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
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

class CloudFirestoreHelper {
  var db = FirebaseFirestore.instance;

  //TODO: Part 1 - Instruction 1
  //Add name, rate, explanation parameter to the addDocument method of the CloudFirestoreHelper class.
  Future<void> addDocument(String name, String rate, String explanation) async {
    //TODO: Part 1 - Instruction 2, 3

    //TODO: Part 1 - Instruction 2
    //Create a form of addDocument method using the try(} catch{} syntax.
    try {
      //TODO: Part 1 - Instrcution 3
      //Call the add method inside instruction2. The method should have properties for Name, Rate, Explanation, and Date with the value DateTime.now().
      db.collection('Reviews').add({
        'name': name,
        'rate': rate,
        'explanation': explanation,
        'Date': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print(e);
    }
  }

  //TODO: Part 2 - Instruction 1
  //Call the snapshots method in the getAlIReviews method of CloudFirestoreHelper to retrieve all reviews
  Stream<QuerySnapshot> getAllReviews() {
    return db.collection('Reviews').snapshots();
  }

  //TODO: Part 3 - Instruction 1
  //Add id parameter to the deleteDocument method of the CloudFirestoreHelper class.
  Future<void> deleteDocument(String id) async {
    //TODO: Part 3 - Instruction 2, 3

    //TODO: Part 3 - Instruction 2
    //Create a form of deletDocument method using the try {} ctah{} syntax
    try {
      //TODO: Part 3 - Instruction 3
      //Call the delete method inside instruction 2.
      db.collection('Reviews').doc(id).delete();
    } catch (e) {
      print(e);
    }
  }
}
