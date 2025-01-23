import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  ShareButton({required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: icon != null
          ? Icon(
              icon,
              color: Colors.black,
              size: 30,
            )
          : null,
    );
  }
}

/* 
1. 그냥 쉐어 ??? 
2. 인스타 쉐어
3. 메시지 쉐어

*/