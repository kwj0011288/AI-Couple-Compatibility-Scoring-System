// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:kissing_booth/component/couple_photo.dart';

// class Leaderboard extends StatelessWidget {
//   final Uint8List? photo1;
//   final Uint8List? photo2;

//   final String heart;
//   final double score;

//   const Leaderboard({
//     Key? key,
//     this.heart = "assets/heart/full_heart.png",
//     this.score = 0,
//     this.photo1,
//     this.photo2,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Size getHeartSize(double score) {
//       int category = score.floor();
//       if (category >= 7) {
//         return const Size(90, 90);
//       } else if (category >= 4) {
//         return const Size(90, 90);
//       } else {
//         return const Size(80, 80);
//       }
//     }

//     Size heartSize = getHeartSize(score);
//     return score != 0
//         ? Stack(
//             alignment: Alignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CouplePhoto(photo: photo1),
//                   const SizedBox(width: 30),
//                   CouplePhoto(photo: photo2),
//                 ],
//               ),
//               Positioned(
//                 child: Image.asset(
//                   heart,
//                   width: heartSize.width,
//                   height: heartSize.height,
//                 ),
//               )
//             ],
//           )
//         : Container();
//   }
// }
