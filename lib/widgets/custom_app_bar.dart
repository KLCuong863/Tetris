import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leftscr;
  final Widget? rightscr;
  final bool goBack;

  const CustomAppBar({
    super.key,
    required this.title,
    this.goBack = true,
    this.leftscr,
    this.rightscr,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      leading: goBack
          ? IconButton(
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          }
        },
        icon: const Icon(
          Icons.arrow_back,
          size: 26,
          color: AppColors.textPrimary,
        ),
      )
          : leftscr,

      title: Text(
        title,
        style: AppFonts.pixeloidSemiBold16.copyWith(
          color: AppColors.textPrimary,
        ),
      ),

      actions: rightscr != null
          ? [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: rightscr!,
        )
      ]
          : [],
    );
  }
}