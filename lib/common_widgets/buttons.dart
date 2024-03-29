import 'package:flutter/material.dart';

import '../utils/colors.dart';

///Custom Icon Button with circular Splash
class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color color;
  final Color backgroundColor;

  const CircularIconButton(
      {Key? key,
      required this.onPressed,
      required this.icon,
      this.color = Colors.black,
      this.backgroundColor = Colors.transparent,
      this.size = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(30),
      child: IconButton(
          splashRadius: 20,
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: size,
            color: color,
          )),
    );
  }
}

ButtonStyle primaryButtonStyle({Color backgroundColor = AppColors.black}) =>
    ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
