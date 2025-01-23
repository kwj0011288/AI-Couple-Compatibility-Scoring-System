import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:kissing_booth/theme/font.dart';

class CustomChatBubble extends StatefulWidget {
  final String message;
  final Alignment alignment;
  final BubbleType bubbleType;
  final bool isResult;
  final String? imageAsset;
  final Color backgroundColor;

  const CustomChatBubble({
    Key? key,
    required this.message,
    required this.alignment,
    required this.bubbleType,
    this.isResult = false,
    this.imageAsset,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  _CustomChatBubbleState createState() => _CustomChatBubbleState();
}

class _CustomChatBubbleState extends State<CustomChatBubble> {
  double girlSize = 60;
  double boySize = 60;
  double midSize = 50;
  double resultSize = 40;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.bubbleType == BubbleType.receiverBubble
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.bubbleType == BubbleType.receiverBubble &&
            widget.imageAsset != null)
          Container(
            width: girlSize,
            height: girlSize,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SizedBox(
                width: midSize,
                height: midSize,
                child: ClipOval(
                  child: Image.asset(
                    widget.imageAsset!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        if (widget.bubbleType == BubbleType.receiverBubble)
          const SizedBox(width: 8),
        Flexible(
          child: ChatBubble(
            padding: const EdgeInsets.all(10),
            shadowColor: Colors.transparent,
            alignment: widget.alignment,
            backGroundColor: () {
              if (widget.isResult) {
                return Colors.green;
              }
              if (widget.bubbleType == BubbleType.receiverBubble) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.5);
              } else if (widget.bubbleType == BubbleType.sendBubble) {
                return Colors.blue;
              }
            }(),
            clipper: ChatBubbleClipper5(
              type: widget.bubbleType,
            ),
            child: Text(
              widget.message,
              style: AppFonts.chat(
                      Theme.of(context).colorScheme.background, context)
                  .copyWith(
                      color: (widget.bubbleType == BubbleType.sendBubble)
                          ? Colors.white
                          : Theme.of(context).colorScheme.outline),
            ).tr(),
          ),
        ),
        if (widget.bubbleType == BubbleType.sendBubble &&
            widget.imageAsset != null)
          const SizedBox(width: 8),
        if (widget.bubbleType == BubbleType.sendBubble &&
            widget.imageAsset != null)
          Container(
            width: boySize,
            height: boySize,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Center(
                child: !widget.isResult
                    ? SizedBox(
                        width: midSize,
                        height: midSize,
                        child: ClipOval(
                          child: Image.asset(
                            widget.imageAsset!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : SizedBox(
                        width: resultSize,
                        height: resultSize,
                        child: Image.asset(
                          widget.imageAsset!,
                          fit: BoxFit.cover,
                        ),
                      )),
          ),
      ],
    );
  }
}
