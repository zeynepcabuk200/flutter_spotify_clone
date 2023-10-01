import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/views/search.dart';

import '../screens/playing.dart';

class LibraryViewW extends StatelessWidget {
  const LibraryViewW({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> getFavoriteItems() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('songs')
        .where('favorite', isEqualTo: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs
          .map((document) => document.data() as Map<String, dynamic>)
          .toList();
    } else {
      return []; // Favori öğe bulunamadıysa boş bir liste döndürün
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.pink.shade600.withOpacity(0.9),
            Colors.pink.shade100.withOpacity(0.9),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: getFavoriteItems(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Veriler alınamıyor.');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Text('Favori öğe bulunamadı.');
                        } else {
                          final favoriteItems = snapshot.data!;

                          return ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 20),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: favoriteItems.length,
                            itemBuilder: ((context, index) {
                              final item = favoriteItems[index];
                              final musicUrl = item['url'] as String?;
                              final imageUrl = item['image'] as String?;
                              final title = item['title'] as String?;
                              final artist = item['artist'] as String?;

                              return InkWell(
                                onTap: () {
                                  // Öğeye tıklama işlemini burada işle
                                },
                                child: Container(
                                  height: 75,
                                  margin: EdgeInsets.only(bottom: 10),
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.black
                                        .withOpacity(0.7),
                                    borderRadius:
                                    BorderRadius.circular(15.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(15.0),
                                        child: Image.network(
                                          imageUrl ?? '', // Null güvenliği için ?? kullanılıyor
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              title ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                            Text(
                                              artist ?? '',
                                              maxLines: 2,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            )
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Playing(image: NetworkImage(imageUrl ?? ''),
                                                label: title ?? '',
                                                musicUrl: musicUrl ?? '',
                                              ),

                                            ),
                                          ); // Öğeyi çalmak veya başka bir eylemi gerçekleştirmek için burada işlem yapabilirsiniz.
                                        },
                                        icon: Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

