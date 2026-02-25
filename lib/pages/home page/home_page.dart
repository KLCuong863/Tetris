import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:tetris_flame/routes/app_routes.dart';
import 'package:tetris_flame/utils/colors.dart';
import 'package:tetris_flame/utils/fonts.dart';
import 'package:tetris_flame/widgets/app_title.dart';
import 'package:tetris_flame/widgets/custom_text_field.dart';

import '../../widgets/custom_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => HomeState();
}

class HomeState extends State<HomePage> {

  final TextEditingController play = TextEditingController(text: "PLAY");
  final TextEditingController highscore = TextEditingController(text: "HIGHSCORE");
  final TextEditingController settings = TextEditingController(text: "SETTINGS");
  final TextEditingController exit = TextEditingController(text: "EXIT");

  Widget buildMenuItem({
    required TextEditingController controller,
    required Color color,
    required IconData icon,
    VoidCallback? onTap
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 1,
          )
        ],
      ),
      child: CustomTextField(
        readOnly: true,
        controller: controller,
        filled: true,
        fillColor: AppColors.darkSurface,
        borderRadius: 16,
        borderColor: color,
        prefixIcon: Icon(icon, color: color),
        textStyle: AppFonts.pixeloidSemiBold20.copyWith(
          color: color,
          letterSpacing: 2,
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomPage(
      widget: Container(
        decoration: const BoxDecoration(
            gradient: AppColors.gameBg
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /// TITLE
            const AppTitle(
              style: AppFonts.pixeloidSemiBold40,
            ),

            const SizedBox(height: 60),

            /// MENU
            buildMenuItem(
              controller: play,
              color: AppColors.pieceZ,
              icon: Icons.play_arrow_rounded,
              onTap: (){context.push(AppRoute.ingame.path);},
            ),

            const SizedBox(height: 20),

            buildMenuItem(
              controller: highscore,
              color: AppColors.pieceO,
              icon: Icons.emoji_events_outlined,
              onTap: (){context.push(AppRoute.highscore.path);}
            ),

            const SizedBox(height: 20),

            buildMenuItem(
              controller: settings,
              color: AppColors.pieceT,
              icon: Icons.settings,
              onTap: (){context.push(AppRoute.setting.path);}
            ),

            const SizedBox(height: 20),

            buildMenuItem(
              controller: exit,
              color: AppColors.pieceL,
              icon: Icons.logout,
              onTap: (){SystemNavigator.pop();}
            ),
          ],
        ),
      ),
    );
  }
}