import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tetris_flame/utils/colors.dart';
import 'package:tetris_flame/utils/fonts.dart';
import 'package:tetris_flame/widgets/app_title.dart';
import 'package:tetris_flame/widgets/custom_page.dart';

import '../routes/app_routes.dart';


class SplashPage extends StatefulWidget{

  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => SplashState();

}

class SplashState extends State<SplashPage>{

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),(){
      context.go(AppRoute.home.path);
    });
  }


  @override
  Widget build(BuildContext context) {
    return CustomPage(
      widget: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: AppColors.gameBg
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: AppTitle(style: AppFonts.pixeloidBold60,)
            ),
            Text("______Make by Flame______", textAlign: TextAlign.center,
              style: AppFonts.pixeloidSemiBold16.copyWith(color: AppColors.textPrimary),)
          ],
        ),
      ),
    );
  }
}