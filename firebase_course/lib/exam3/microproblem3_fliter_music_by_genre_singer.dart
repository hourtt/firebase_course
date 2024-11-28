import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

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
      home: PlaylistPage(),
    );
  }
}

class PlaylistPage extends StatefulWidget {
  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final CloudFirestoreHelper cloudFirestoreHelper = CloudFirestoreHelper();
  String selectedSinger = '';
  String selectedGenre = '';
  String selectedSort = '';
  final List<String> genres = [
    'Pop',
    'K-pop',
    'R&B',
    'Hip-Hop',
    'Country',
    'Jazz'
  ];
  final List<String> singers = [
    'Beyonce',
    'Taylor Swift',
    'Ed Sheeran',
    'Adele'
  ];
  final List<String> sorts = ['Newest', 'Popular'];

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
              Container(
                width: 173,
                height: 176,
                color: const Color(0xff282828),
                child: Image.network(
                  "https://picsum.photos/300/200",
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 268,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "My Playlist",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
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
                        onPressed: () async {
                          Map<String, dynamic> result =
                              await showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xFF5B5B5B),
                                          Color(0xFF040404)
                                        ],
                                      ),
                                    ),
                                    child: SingleChildScrollView(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const SizedBox(
                                                  width: 50,
                                                ),
                                                const Text("Filter your genres",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                SizedBox(
                                                    width: 60,
                                                    child: TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, {
                                                            'selectedGenre':
                                                                selectedGenre,
                                                            'selectedSinger':
                                                                selectedSinger,
                                                            'selectedSort':
                                                                selectedSort
                                                          });
                                                          setState(() {});
                                                        },
                                                        child: const Text(
                                                            "Done",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white)))),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 12,
                                            ),
                                            SizedBox(
                                              width: 268,
                                              child: GridView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: genres.length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        childAspectRatio:
                                                            128 / 57,
                                                        mainAxisSpacing: 12,
                                                        crossAxisSpacing: 12,
                                                        crossAxisCount: 2),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedGenre ==
                                                                genres[index]
                                                            ? selectedGenre = ''
                                                            : selectedGenre =
                                                                genres[index];
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: selectedGenre ==
                                                                genres[index]
                                                            ? const Color(
                                                                0xff1BD860)
                                                            : Colors.white,
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                              genres[index],
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black))),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const Divider(
                                              color: Colors.white,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text("Filter your singer",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white)),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            SizedBox(
                                              width: 268,
                                              child: GridView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: singers.length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        childAspectRatio:
                                                            128 / 57,
                                                        mainAxisSpacing: 12,
                                                        crossAxisSpacing: 12,
                                                        crossAxisCount: 2),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedSinger ==
                                                                singers[index]
                                                            ? selectedSinger =
                                                                ''
                                                            : selectedSinger =
                                                                singers[index];
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: selectedSinger ==
                                                                singers[index]
                                                            ? const Color(
                                                                0xff1BD860)
                                                            : Colors.white,
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                              singers[index],
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black))),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const Divider(
                                              color: Colors.white,
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            const Text("Sort your music",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white)),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            SizedBox(
                                              width: 268,
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                itemCount: sorts.length,
                                                gridDelegate:
                                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                                        childAspectRatio:
                                                            128 / 57,
                                                        mainAxisSpacing: 12,
                                                        crossAxisSpacing: 12,
                                                        crossAxisCount: 2),
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.white,
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                              sorts[index],
                                                              style: const TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black))),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 40,
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                              });
                            },
                          );
                          if (result != null) {
                            setState(() {
                              selectedGenre = result["selectedGenre"];
                              selectedSinger = result["selectedSinger"];
                            });
                          }
                        },
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
                //TODO: Part 1 - Instruction 5
                //Set the stream property of the StreamBuilder to the getFilteredMusicDocuments method.
                //Use it with the asStream method below.
                //stream.asReplace() => cloudFirestoreHelper.getFilteredMusicDocuments(selectedSinger,selectedGenre,selectedSort).asStream(),
                //*Modify from stream: cloudFirestoreHelper.getFilteredMusicDocuments( selectedSinger, selectedGenre, selectedSort) .asStream(), to stream: cloudFirestoreHelper.getFilteredMusicDocuments( selectedGenre, selectedSinger, selectedSort) .asStream(),
                stream: cloudFirestoreHelper
                    .getFilteredMusicDocuments(
                        selectedGenre, selectedSinger, selectedSort)
                    .asStream(),
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
                          onPressed: () async {
                            await cloudFirestoreHelper.addMusics();
                            setState(() {});
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

  Future<void> addMusics() async {
    try {
      for (Map<String, dynamic> data in songs) {
        await db.collection("Musics").add(data);
      }
    } catch (e) {
      print(e);
    }
  }

//TODO: Part 1 - Instruction 1
  //Modify return type of getFilterMusicDocuments method from void to query snapshot [Querysnapshot<Map<String,dynamic>>> the QuerySnapshot need an object]
  Future<QuerySnapshot<Map<String, dynamic>>> getFilteredMusicDocuments(
      String selectedGenre, String selectedSinger, String selectedSort) async {
    try {
      //Change from Query to Query <Map<String,dynamic>>
      //Error cause: line 1 of test.dart .
      //A value of type QuerySnapshot<Object?> can't be returned from the method getFilteredMusicDocuments
      //because it has a return type of Future<QuerySnapshot<Map<String, dynamic>>>
      Query<Map<String, dynamic>> query = db.collection("Musics");

      if (selectedGenre.isNotEmpty) {
        //TODO: Part 1 - Instruction 2
        //if selectedGenre is not null, call the where method with Genre field equal to selectedGenre. Then, assign it to the query variable
        query = query.where("Genre", isEqualTo: selectedGenre);
      }

      if (selectedSinger.isNotEmpty) {
        //TODO: Part 1 - Instruction 3
        //if selectedSinger is not null, call the where method with Singer field euqal to selectedSinger.Then, assign it to the query variabale
        query = query.where("Singer", isEqualTo: selectedSinger);
      }
      //TODO: Part 1 - Instruction 4
      //call the get function with a query variable to retrieve data then return it
      return await query.get();
    } catch (e) {
      print(e);
      return Future.value(null);
    }
  }
}
