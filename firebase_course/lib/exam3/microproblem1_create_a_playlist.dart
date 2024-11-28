import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

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
      home: MusicPlayerPage(),
    );
  }
}

class MusicPlayerPage extends StatefulWidget {
  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  @override
  final albumImages = [
    'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage1.jpg?alt=media&token=c1511475-a259-48f1-80c7-6b9cb1087522',
    'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage2.jpg?alt=media&token=1dd26e16-b6e3-4c28-8f97-28747b086dae',
    'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage3.jpg?alt=media&token=c4732759-d336-4b61-b13a-8c4920764eaa',
    'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage4.jpg?alt=media&token=23953feb-163d-4466-80db-4afcaebe0809',
    'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage5.jpg?alt=media&token=ba823291-846c-406c-b701-965d2ba93d28',
    'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage6.jpg?alt=media&token=72b08192-ebad-475b-ad8a-9840e2a580f5',
    'https://firebasestorage.googleapis.com/v0/b/course4-microproject-test.appspot.com/o/images%2Fimage7.jpg?alt=media&token=0576453c-5f2b-4406-870a-84175761c2ef',
  ];
  CloudFirestoreHelper cloudFirestoreHelper = CloudFirestoreHelper();
  StorageHelper storageHelper = StorageHelper();
  String selectedImage = '';
  String imageUrl = '';
  TextEditingController playlistNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5B5B5B), Color(0xFF040404)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Create Playlist',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 30),
              Container(
                width: 107,
                height: 107,
                color: const Color(0xff282828),
                child: selectedImage == ''
                    ? const Icon(Icons.music_note_outlined,
                        size: 64, color: Color(0xffB3B3B3))
                    : Image.network(
                        selectedImage,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        color: const Color.fromRGBO(40, 40, 40, 1),
                        height: 550,
                        child: Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: 100,
                                      child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)))),
                                  const Text("Add Image",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  const SizedBox(
                                    width: 100,
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(
                                color: Color(0xffDBDBDB),
                              ),
                              const SizedBox(height: 10),
                              GridView.builder(
                                itemCount: albumImages.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                ),
                                itemBuilder: (_, index) {
                                  return InkWell(
                                    onTap: () async {
                                      //TODO: Part 2 - Instruction 6
                                      //Call uploadPostingImage method of storageHelper to upload the selected image as the playlist image to the irebase storage.
                                      final image = await storageHelper
                                          .uploadPostingImage(
                                        selectedImage,
                                        imageUrl,
                                      );
                                      setState(() {
                                        selectedImage = image!;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Image.network(
                                      albumImages[index],
                                      width: 112,
                                      height: 112,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: const Text(
                  'Add Image',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 52),
              Container(
                width: 268,
                child: TextField(
                  controller: playlistNameController,
                  cursorColor: Colors.white,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'Playlist Name',
                    hintStyle: TextStyle(
                      color: Color(0xffB3B3B3),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 36),
              OutlinedButton(
                onPressed: () {
                  //TODO: Part 3 - Instruction 3
                  //Call the addPlaylist method with the playlist name and selected image url in the Firebase Storage. (Use the class of CloudFirestoreHelper)
                  final playlist = cloudFirestoreHelper.addPlaylist(
                    playlistNameController.text,
                    selectedImage,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaylistPage(
                        playlistName: playlistNameController.text,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF1BD860),
                  minimumSize: const Size(143, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  side: BorderSide.none,
                ),
                child: const Text(
                  'Create',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlaylistPage extends StatefulWidget {
  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
  final String playlistName;

  PlaylistPage({required this.playlistName});
}

class _PlaylistPageState extends State<PlaylistPage> {
  final CloudFirestoreHelper cloudFirestoreHelper = CloudFirestoreHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5B5B5B), Color(0xFF040404)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Playlist',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 30),
              FutureBuilder<DocumentSnapshot>(
                future: cloudFirestoreHelper.db
                    .collection('Playlist')
                    .doc(widget.playlistName)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    }

                    Map<String, dynamic> data =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: <Widget>[
                        Container(
                          width: 173,
                          height: 176,
                          color: const Color(0xff282828),
                          child: data['Image'] == ''
                              ? const Icon(Icons.music_note_outlined,
                                  size: 64, color: Color(0xffB3B3B3))
                              //TODO: Part 3 - Instruction 4
                              //Retrieve the image URL from the image field of the retrieved data and display the image through image.network
                              //(Retrieved the data from data that Define as a Map from String to Dynamic)
                              : Image.network(
                                  data['image'],
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: 268,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data['Name'],
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  }

                  // While the document is not yet loaded, display a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
              const SizedBox(height: 8),
              Container(
                width: 268,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 3),
                    const Text(
                      'Mable',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.filter_alt_outlined,
                          size: 24,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 268,
                height: 1,
                color: Colors.white,
              ),
              StreamBuilder(
                stream: cloudFirestoreHelper.db
                    .collection("Playlist")
                    .doc(widget.playlistName)
                    .collection("Musics")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Column(
                      children: [
                        const SizedBox(height: 36),
                        const Text(
                          'Let\'s make your playlist',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            cloudFirestoreHelper.addMusics(widget.playlistName);
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(230, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: BorderSide.none,
                          ),
                          child: const Text(
                            'Add to this playlist',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return SizedBox(
                      width: 268,
                      height: 230,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              title: Text(snapshot.data!.docs[index]['Name'],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              subtitle: Text(
                                snapshot.data!.docs[index]['Singer'],
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14),
                              ),
                              trailing: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.more_horiz_outlined,
                                  color: Colors.white,
                                ),
                              ));
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StorageHelper {
  var storage = FirebaseStorage.instance;

  //TODO: Part 2 - Instruction 1
  //Modify return type of getImage method from void to a String or null
  Future<String?> uploadPostingImage(String imageName, String imageUrl) async {
    //TODO: Part 2 - Instruction 2
    //Create a reference to the Firebase Storage location where the image will be stored.
    //Use the follow path below
    // post_image/$imageName.jpg
    final imageRef = storage.ref().child('post_image/$imageName.jpg');

    //TODO: Part 2 - Instruction 3
    //Call getImage function with await to retrieve the image data from imageUrl
    final data = await getImage(url: imageUrl);

    if (data == null) return null;

    try {
      //TODO: Part 2 - Instruction 4
      //Call putData method to upload the retrieved image image data to the imageRef location.
      //Use the following metadata below
      //SettableMetadata(contentType:'image/jpg')

      await imageRef.putData(data, SettableMetadata(contentType: 'image/jpg'));

      //TODO: Part 2 - Instruction 5
      //Call getDownloadURL method to get the download url of the uploaded image.
      //Retrieved the download URL and return it
      final download = await imageRef.getDownloadURL();

      return download;
    } catch (e) {
      print(e);
      return null;
    }
  }

//TODO: Part 1 - Instruction 1
  //Modify return type of getImage method from void to a Uint8list or null
  Future<Uint8List?> getImage({String? url}) async {
    try {
      //TODO: Part 1 - Instruction 2
      //Use the https package with await to fetch the image from the following URL below
      // Uri.parse(url?? https://picsum.photos/300/200)
      final res =
          await http.get(Uri.parse(url ?? 'https://picsum.photos/300/200'));
      //TODO: Part 1 - Instruction 3, 4

      //TODO: Part 1 - Instruction 3
      //Create an if statement to check if the HTTP response status code indicates success
      if (res.statusCode == 200) {
        //TODO: Part 1 - Instruction 4
        //if the condition is true, return the body of the HTTP resposne as a list of bytes. The return value is of type Uint8List
        return res.bodyBytes;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}

class CloudFirestoreHelper {
  var db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> songs = [
    {
      'Name': 'Halo',
      'Singer': 'Beyonce',
      'Release_Date': '2008',
      'Genre': 'Pop',
      'Hits': 1000000
    },
    {
      'Name': 'Single Ladies',
      'Singer': 'Beyonce',
      'Release_Date': '2008',
      'Genre': 'Pop',
      'Hits': 950000
    },
    {
      'Name': 'Crazy In Love',
      'Singer': 'Beyonce',
      'Release_Date': '2003',
      'Genre': 'R&B',
      'Hits': 900000
    },
    {
      'Name': 'Irreplaceable',
      'Singer': 'Beyonce',
      'Release_Date': '2006',
      'Genre': 'Pop',
      'Hits': 850000
    },
    {
      'Name': 'Love On Top',
      'Singer': 'Beyonce',
      'Release_Date': '2011',
      'Genre': 'Pop',
      'Hits': 800000
    },
    {
      'Name': 'Love Story',
      'Singer': 'Taylor Swift',
      'Release_Date': '2008',
      'Genre': 'Country',
      'Hits': 1500000
    },
    {
      'Name': 'You Belong with Me',
      'Singer': 'Taylor Swift',
      'Release_Date': '2008',
      'Genre': 'Country',
      'Hits': 1400000
    },
    {
      'Name': 'Shake It Off',
      'Singer': 'Taylor Swift',
      'Release_Date': '2014',
      'Genre': 'Pop',
      'Hits': 1300000
    },
    {
      'Name': 'Blank Space',
      'Singer': 'Taylor Swift',
      'Release_Date': '2014',
      'Genre': 'Pop',
      'Hits': 1200000
    },
    {
      'Name': 'Bad Blood',
      'Singer': 'Taylor Swift',
      'Release_Date': '2014',
      'Genre': 'Pop',
      'Hits': 1100000
    },
    {
      'Name': 'Shape of You',
      'Singer': 'Ed Sheeran',
      'Release_Date': '2017',
      'Genre': 'Pop',
      'Hits': 2000000
    },
    {
      'Name': 'Perfect',
      'Singer': 'Ed Sheeran',
      'Release_Date': '2017',
      'Genre': 'Pop',
      'Hits': 1900000
    },
    {
      'Name': 'Thinking Out Loud',
      'Singer': 'Ed Sheeran',
      'Release_Date': '2014',
      'Genre': 'Pop',
      'Hits': 1800000
    },
    {
      'Name': 'Photograph',
      'Singer': 'Ed Sheeran',
      'Release_Date': '2014',
      'Genre': 'Pop',
      'Hits': 1700000
    },
    {
      'Name': 'Castle on the Hill',
      'Singer': 'Ed Sheeran',
      'Release_Date': '2017',
      'Genre': 'Pop',
      'Hits': 1600000
    },
    {
      'Name': 'Hello',
      'Singer': 'Adele',
      'Release_Date': '2015',
      'Genre': 'Pop',
      'Hits': 2500000
    },
    {
      'Name': 'Rolling in the Deep',
      'Singer': 'Adele',
      'Release_Date': '2010',
      'Genre': 'Pop',
      'Hits': 2400000
    },
    {
      'Name': 'Someone Like You',
      'Singer': 'Adele',
      'Release_Date': '2011',
      'Genre': 'Pop',
      'Hits': 2300000
    },
    {
      'Name': 'Set Fire to the Rain',
      'Singer': 'Adele',
      'Release_Date': '2011',
      'Genre': 'Pop',
      'Hits': 2200000
    },
    {
      'Name': 'Skyfall',
      'Singer': 'Adele',
      'Release_Date': '2012',
      'Genre': 'Pop',
      'Hits': 2100000
    },
  ];

  Future<QuerySnapshot> getMusicDocuments(String docId) async {
    try {
      return await db
          .collection('Playlist')
          .doc(docId)
          .collection("Musics")
          .get();
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }

  Future<void> addMusics(String docId) async {
    try {
      for (Map<String, dynamic> data in songs) {
        await db
            .collection('Playlist')
            .doc(docId)
            .collection("Musics")
            .add(data);
      }
    } catch (e) {
      print(e);
    }
  }

//TODO: Part 3 - Instruction 1
//Add name, image parameter to the addPlaylist method of the CloudFireHelper class
  Future<String?> addPlaylist(String name, String image) async {
    try {
      //TODO: Part 3 - Instruction 2
      //Call the set method with awiat to add playlist data to Firestore.
      //Use the following document reference below
      // await db.collection().doc().set({});

      await db.collection('Playlist').doc(name).set({
        'name': name,
        'image': image,
      });
    } catch (e) {
      print(e);
    }
  }
}
