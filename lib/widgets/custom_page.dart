import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_routes.dart';
import '../utils/colors.dart';
import 'custom_app_bar.dart';


class CustomPage extends StatefulWidget{
  final Widget? widget;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final bool? hasAppBar;
  final String? pageName;

  const CustomPage({
    super.key,
    required this.widget,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.hasAppBar = false,
    this.pageName
  });

  @override
  State createState() => _CustomPageState();
}

class _CustomPageState extends State<CustomPage>{

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isHome =
            GoRouterState.of(context).uri.path == AppRoute.home.path;

        if (isHome) {
          return await _showExitDialog(context);
        }

        if (GoRouter.of(context).canPop()) {
          context.pop();
          return false;
        }

        return await _showExitDialog(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        bottomNavigationBar: widget.bottomNavigationBar,
        appBar: (widget.hasAppBar!)? CustomAppBar(title: widget.pageName!) : null,
        body: widget.widget!,

      ),
    );
  }


  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Quit?"),
        content: const Text("Wanna quit from the app?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Nah"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Yes"),
          ),
        ],
      ),
    ) ?? false;
  }

}