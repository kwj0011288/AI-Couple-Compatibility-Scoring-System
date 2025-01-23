import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FixedWebSizeWrapper extends StatelessWidget {
  final Widget child;

  const FixedWebSizeWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return kIsWeb &&
            (defaultTargetPlatform != TargetPlatform.iOS) &&
            (defaultTargetPlatform != TargetPlatform.android)
        ? Center(
            child: Container(
              width: 420,
              height: 1100,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.8),
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: child,
              ),
            ),
          )
        : child; // Non-web platforms remain responsive
  }
}
