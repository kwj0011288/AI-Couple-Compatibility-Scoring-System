import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kissing_booth/main.dart';
import 'package:kissing_booth/theme/font.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final Key? valueKey;
  final bool isNext;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.color,
    this.valueKey,
    this.isNext = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Use the provided onPressed callback
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: Container(
                    key: valueKey ?? ValueKey(text),
                    height: 55,
                    width: (kIsWeb) ? 450 : 300,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      text,
                      style: AppFonts.button(color, context).copyWith(
                        color: (!isNext)
                            ? color ==
                                    Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer
                                ? Theme.of(context).colorScheme.background
                                : Theme.of(context).colorScheme.outline
                            : Colors.white,
                      ),
                    ).tr(),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
