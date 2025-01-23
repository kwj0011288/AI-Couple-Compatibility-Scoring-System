import 'package:flutter/material.dart';
import 'package:kissing_booth/theme/font.dart';

class ResultText extends StatefulWidget {
  final String text;

  ResultText({required this.text});

  @override
  _ResultTextState createState() => _ResultTextState();
}

class _ResultTextState extends State<ResultText> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
              text: widget.text.split(' ')[0],
              style: AppFonts.score1(
                  Theme.of(context).colorScheme.outline, context)),
          TextSpan(
            text: ' \/ 10',
            style:
                AppFonts.score2(Theme.of(context).colorScheme.primary, context),
          ),
        ],
      ),
    );
  }
}
