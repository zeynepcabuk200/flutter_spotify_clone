import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/album_card.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future getData() async {
    return await FirebaseFirestore.instance.collection('songs').get();
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }else if(snapshot.hasData){
          return Scaffold(
            body: Stack(
              alignment: Alignment.topLeft,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * .6,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.pink.withOpacity(0.8),
                        Colors.pink.withOpacity(0.5),
                        Colors.black.withOpacity(0),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    decoration: BoxDecoration(//28
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.5),
                          Colors.white.withOpacity(0.1),
                          Colors.black.withOpacity(0),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // son oynatılan kısım
                              children: [
                                Text(
                                  "Recently Played",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.history),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Icon(Icons.settings),
                                  ],
                                )
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.all(20),
                            child: Row(
                              children:snapshot.data.docs.map<Widget>((document) {

                                return AlbumCard(
                                    label: document.data()["title"],
                                    image: NetworkImage(document.data()["image"]),
                                    musicUrl:document.data()["url"] ,
                                    favorite: document.data()["favorite"]

                                );

                              }).toList(),

                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text("Good Evening",
                                    style: Theme.of(context).textTheme.headline6),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    RowAlbumCard(
                                      label: "Top 50 - Global",
                                      image: AssetImage("assets/images/music3.jpg"),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    RowAlbumCard(
                                      label: "Top 50 - Global",
                                      image: AssetImage("assets/images/music2.jpg"),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    RowAlbumCard(
                                      label: "Top 50 - Global",
                                      image: AssetImage("assets/images/music4.jpg"),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    RowAlbumCard(
                                      label: "Top 50 - Global",
                                      image: AssetImage("assets/images/music1.jpg"),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    RowAlbumCard(
                                      label: "Top 50 - Global",
                                      image: AssetImage("assets/images/music3.jpg"),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    RowAlbumCard(
                                      label: "Top 50 - Global",
                                      image: AssetImage("assets/images/music5.jpg"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Based on your recent listening",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children:snapshot.data.docs.map<Widget>((document) {

                                    return AlbumCard(
                                        label: document.data()["title"],
                                        image: NetworkImage(document.data()["image"]),
                                        musicUrl:document.data()["url"] ,
                                        favorite: document.data()["favorite"]


                                    );

                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Recommended radio",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children:snapshot.data.docs.map<Widget>((document) {
                                    print(document.data()["url"]);
                                    return AlbumCard(
                                        label: document.data()["title"],
                                        image: NetworkImage(document.data()["image"]),
                                        musicUrl:document.data()["url"],
                                        favorite: document.data()["favorite"]

                                    );

                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }else{
          return Center(
            child: Text("veri bulunamadı"),
          );
        }
      },
    );
  }
}

class RowAlbumCard extends StatelessWidget {
  final AssetImage image;
  final String label;

  const RowAlbumCard(
      {
        // Key key,
        required this.image,
        required this.label}); //: super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white10, borderRadius: BorderRadius.circular(4)),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            Image(
              image: image,
              height: 48,
              width: 48,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 8,
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
