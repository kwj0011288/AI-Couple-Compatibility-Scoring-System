import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CouplePhoto extends StatelessWidget {
  final String? photo;
  final bool isCouple;

  const CouplePhoto({
    Key? key,
    required this.photo,
    this.isCouple = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isCouple
          ? 200
          : kIsWeb &&
                  (defaultTargetPlatform != TargetPlatform.iOS) &&
                  (defaultTargetPlatform != TargetPlatform.android)
              ? 220
              : 180,
      width: isCouple
          ? MediaQuery.of(context).size.width - 50
          : kIsWeb &&
                  (defaultTargetPlatform != TargetPlatform.iOS) &&
                  (defaultTargetPlatform != TargetPlatform.android)
              ? 170
              : 130,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1,
        ),
        image: photo != null
            ? DecorationImage(
                image: NetworkImage(photo!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: photo == null
          ? Center(
              child: Icon(
                Icons.photo,
                size: 40,
                color: Theme.of(context).colorScheme.outline,
              ),
            )
          : null,
    );
  }
}
