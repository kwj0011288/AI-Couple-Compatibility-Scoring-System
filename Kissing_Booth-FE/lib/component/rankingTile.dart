import 'package:flutter/material.dart';
import 'package:kissing_booth/component/stack_image.dart';
import 'package:kissing_booth/theme/font.dart';

class RankingTile extends StatelessWidget {
  final int rank;
  final List<String> imageUrls;
  final String nickname;
  final double score;
  final bool isCoupleRank;

  RankingTile({
    required this.rank,
    required this.imageUrls,
    required this.nickname,
    required this.score,
    required this.isCoupleRank,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 20.0, vertical: isCoupleRank ? 15 : 10.0),
      margin: EdgeInsets.symmetric(vertical: 2.0),
      decoration: BoxDecoration(
        color: isCoupleRank
            ? Theme.of(context).colorScheme.secondary
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.0,
            child: Center(
              child: rank == 1
                  ? Image.asset(
                      'assets/illustrations/first.png',
                      width: 40.0,
                      height: 40.0,
                    )
                  : rank == 2
                      ? Image.asset(
                          'assets/illustrations/second.png',
                          width: 40.0,
                          height: 40.0,
                        )
                      : rank == 3
                          ? Image.asset(
                              'assets/illustrations/third.png',
                              width: 40.0,
                              height: 40.0,
                            )
                          : Text(
                              '$rank',
                              style: AppFonts.ranking(context),
                              textAlign: TextAlign.center,
                            ),
            ),
          ),
          SizedBox(width: 15.0),
          if (imageUrls.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrls[0],
                fit: BoxFit.cover,
                width: 30,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if the image fails to load
                  return Image.asset(
                    'assets/illustrations/result.png',
                    fit: BoxFit.cover,
                    width: 30,
                    height: 40,
                  );
                },
              ),
            ),
          SizedBox(width: 5.0),
          if (imageUrls.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrls[1],
                fit: BoxFit.cover,
                width: 30,
                height: 40,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if the image fails to load
                  return Image.asset(
                    'assets/illustrations/result.png',
                    fit: BoxFit.cover,
                    width: 30,
                    height: 40,
                  );
                },
              ),
            ),
          SizedBox(width: 20.0),
          Expanded(
            child: Text(
              nickname,
              style: AppFonts.ranking(context),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${(score * 10).toStringAsFixed(2)}',
            style: AppFonts.ranking(context),
          ),
        ],
      ),
    );
  }
}
