import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone/views/search.dart';
import 'package:spotify_clone/widgets/album_card.dart';

import '../screens/playing.dart';

class AlbumView extends StatefulWidget {
  final ImageProvider image;
  final String label;
  final String musicUrl;
  final bool favorite;
  const AlbumView(
      {Key? key,
      required this.image,
      required this.label,
      required this.musicUrl,
      required this.favorite})
      : super(key: key);
  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  late ScrollController scrollController;
  double imageSize = 0;
  double initialSize = 240;
  double containerHeight = 500;
  double containerInitialHeight = 500;
  double imageOpacity = 1;
  bool showTopBar = false;
  bool isFavorite = false; // Favori durumu başlangıçta false

  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudioPlayer();

    imageSize = initialSize;
    scrollController = ScrollController()
      ..addListener(() {
        imageSize = initialSize - scrollController.offset;
        print(imageSize);
        if (imageSize < 0) {
          imageSize = 0;
        }
        containerHeight = containerInitialHeight - scrollController.offset;
        if (containerHeight < 0) {
          containerHeight = 0;
        }
        imageOpacity = imageSize / initialSize;
        if (scrollController.offset > 224) {
          showTopBar = true;
        } else {
          showTopBar = false;
        }
        setState(() {});
      });
    super.initState();
  }

  void _initAudioPlayer() async {
    await _audioPlayer.setUrl(widget.musicUrl);
    setState(() {});
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future getData() async {
    return await FirebaseFirestore.instance.collection('songs').get();
  }

  // Belirli bir dokümanın ID'sini bulan ve güncelleme işlemi yapacak olan işlev
  Future<void> updateFavoriteStatus(bool isFavorite, String documentId) async {
    // Firestore bağlantısını oluşturun
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Favori durumunu Firestore'da güncelleme
    firestore.collection('songs').doc(documentId).update({
      'favorite': isFavorite,
    }).then((value) {
      print('Doküman ID $documentId favori durumu güncellendi: $isFavorite');
    }).catchError((error) {
      print('Doküman ID $documentId favori durumu güncelleme hatası: $error');
    });
  }

// Verileri getiren ve doküman ID'sini bulan işlev
  Future<void> getDataAndUpdateFavoriteStatus() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('songs')
        .where('title',
            isEqualTo: widget.label) // Dokümanı başlık (label) ile filtrele
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String documentId =
          querySnapshot.docs.first.id; // İlk dokümanın ID'sini al
      print('Doküman ID: $documentId');

      // Favori durumu güncelleme işlevini çağır
      updateFavoriteStatus(isFavorite, documentId);
    } else {
      print('Belirtilen başlıkla eşleşen doküman bulunamadı.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardSize = MediaQuery.of(context).size.width / 2 - 32;
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Stack(
                children: [
                  Container(
                    height: containerHeight,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    color: Colors.pink.shade100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: imageOpacity.clamp(0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(.5),
                                  offset: Offset(0, 20),
                                  blurRadius: 32,
                                  spreadRadius: 16,
                                )
                              ],
                            ),
                            child: Image(
                              image: widget.image,
                              width: imageSize,
                              height: imageSize,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                        controller: scrollController,
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Container(
                              clipBehavior: Clip.none,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0),
                                    Colors.black.withOpacity(0),
                                    Colors.black.withOpacity(1),
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: initialSize + 32,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.label,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Image(
                                                image: AssetImage(
                                                    "assets/images/spotify_logo.png"),
                                                width: 32,
                                                height: 32,
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text("Spotify")
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            "1,888,132 likes 5h 3m",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                          SizedBox(
                                            height: 16,
                                          ),
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      // Firebase'e favori durumu gönderme
                                                      getDataAndUpdateFavoriteStatus(); // Durumu tersine çevir
                                                      setState(() {
                                                        isFavorite =
                                                            !isFavorite;
                                                      });
                                                    },
                                                    // Durumu güncelle
                                                    icon: Icon(
                                                      isFavorite
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border,
                                                      color: isFavorite
                                                          ? Colors.pink.shade300
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Icon(Icons.more_horiz,
                                                      color:
                                                          Colors.pink.shade300),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 64,
                                                    height: 64,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors
                                                            .pink.shade300),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                              builder: (context) => Playing(image: widget.image,label: widget.label,musicUrl: widget.musicUrl,),

                                                          )
                                                          /*if (_audioPlayer
                                                              .playing) {
                                                            _audioPlayer
                                                                .pause();
                                                          } else {
                                                            _audioPlayer.play();
                                                          }
                                                          setState(() {});*/
                                                          );
                                                        },
                                                        icon: Icon(
                                                            Icons.play_arrow)),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              color: Colors.black,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Açıklama açıklama açıklama açıklama açıklama açıklama açıklama açıklamaaçıklama açıklamaaçıklama açıklama açıklama",
                                  ),
                                  SizedBox(
                                    height: 32,
                                  ),
                                  Text(
                                    "You might also like",
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: BouncingScrollPhysics(),
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      children:snapshot.data.docs.map<Widget>((document) {
                                        return AlbumCard(
                                            label: document.data()["title"],
                                            image: NetworkImage(
                                                document.data()["image"]),
                                            musicUrl: document.data()["url"],
                                            favorite:
                                                document.data()["favorite"]);
                                      }).toList(),
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
                                          image: NetworkImage(
                                              document.data()["image"]),
                                          musicUrl: document.data()["url"],
                                          favorite: document.data()["favorite"],
                                        );
                                      }).toList(),
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
                                            image: NetworkImage(
                                                document.data()["image"]),
                                            musicUrl: document.data()["url"],
                                            favorite:
                                                document.data()["favorite"]);
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                  //App Bar
                  Positioned(
                      child: Container(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      color: showTopBar
                          ? Colors.pink.withOpacity(0.5)
                          : Colors.pink.withOpacity(0),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SafeArea(
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                left: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    size: 38,
                                  ),
                                ),
                              ),
                              AnimatedOpacity(
                                duration: Duration(milliseconds: 250),
                                opacity: showTopBar ? 1 : 0,
                                child: Text(
                                  "Album isim",
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ),
                              /* Positioned(
                        right: 0,
                        bottom:
                            80 - containerHeight.clamp(120.0, double.infinity),
                        child:Column(
                         // alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xff14D860)),
                            child: ElevatedButton(
                               //Icons.play_arrow,
                               //size: 38,
                                 onPressed: () {
                                   if (_audioPlayer.playing) {
                                     _audioPlayer.pause();
                                   } else {
                                     _audioPlayer.play();
                                   }
                                   setState(() {});
                                 },
                                 child: Text(_audioPlayer.playing ? 'Pause' : 'Play'),
                               ),

                           ),

                            /*Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Icon(
                                Icons.shuffle,
                                color: Colors.black,
                                size: 14,
                              ),
                            )*/
                          ],
                        ),
                      )*/
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
