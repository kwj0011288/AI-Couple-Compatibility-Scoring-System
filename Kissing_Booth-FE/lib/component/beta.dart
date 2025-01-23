import 'package:flutter/material.dart';
import 'package:kissing_booth/theme/font.dart';

class BetaContainer extends StatelessWidget {
  final String title;

  const BetaContainer({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15.0),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: AppFonts.warningBox(context),
        textAlign: TextAlign.center,
      ),
    );
  }
}
