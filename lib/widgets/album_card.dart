import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spotify_clone/views/album_view.dart';

class AlbumCard extends StatelessWidget {
  final ImageProvider image;
  final String label;
  final String musicUrl;
  final bool favorite;
  //final Function onTap;
  final double size;
  const AlbumCard({
    //required Key key,
    required this.image,
    required this.label,
    required this.musicUrl,
    required this.favorite,
    //this.onTap,
    this.size=140,
  }); //: super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlbumView(image: image,label: label,musicUrl: musicUrl,favorite: favorite,),

        ),
      );
    },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        SizedBox(width: 10,),
          Image(
            image: image,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 10,
          ),
          Text(label),

        ],
      ),
    );
  }
}
