import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/fonts.dart';

class AppTitle extends StatelessWidget{

  final TextStyle? style;
  const AppTitle({required this.style});

  @override
  Widget build(BuildContext context) {
    TextStyle? style = this.style;
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: "T", style: style!.copyWith(color: AppColors.pieceO),
          children: [
            TextSpan(
              text: "E", style: style!.copyWith(color: AppColors.pieceS),
            ),
            TextSpan(
              text: "T", style: style!.copyWith(color: AppColors.pieceZ),
            ),
            TextSpan(
              text: "R", style: style!.copyWith(color: AppColors.pieceL),
            ),
            TextSpan(
              text: "I", style: style!.copyWith(color: AppColors.pieceO),
            ),
            TextSpan(
              text: "S", style: style!.copyWith(color: AppColors.pieceI),
            )
          ]
      ),
    );
  }

}