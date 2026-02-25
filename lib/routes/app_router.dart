import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tetris_flame/pages/game%20screen/game_screen.dart';
import 'package:tetris_flame/pages/highscore%20page/highscore_page.dart';
import 'package:tetris_flame/pages/setting%20page/setting_page.dart';

import '../pages/home page/home_page.dart';
import '../pages/splash_page.dart';
import 'app_routes.dart';


final GoRouter goRouter = GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      GoRoute(
          path: AppRoute.splash.path,
          name: AppRoute.splash.name,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: SplashPage(),
            transitionDuration: const Duration(milliseconds: 400),
            transitionsBuilder: _slideTransition,
          )
      ),
      ShellRoute(
          builder: (context, state, child){
            return Scaffold(
              body: child,
            );
          },
          routes: [
            GoRoute(
                path: AppRoute.home.path,
                name: AppRoute.home.name,
                pageBuilder: (context, state){
                  return CustomTransitionPage(
                      key: state.pageKey,
                      child: HomePage(),
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder: _slideTransition
                  );
                }
            ),
            GoRoute(
                path: AppRoute.ingame.path,
                name: AppRoute.ingame.name,
                pageBuilder: (context, state){
                  return CustomTransitionPage(
                      key: state.pageKey,
                      child: GameScreen(),
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder: _slideTransition
                  );
                }
            ),
            GoRoute(
                path: AppRoute.setting.path,
                name: AppRoute.setting.name,
                pageBuilder: (context, state){
                  return CustomTransitionPage(
                      key: state.pageKey,
                      child: SettingsPage(),
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder: _slideTransition
                  );
                }
            ),
            GoRoute(
                path: AppRoute.highscore.path,
                name: AppRoute.highscore.name,
                pageBuilder: (context, state){
                  return CustomTransitionPage(
                      key: state.pageKey,
                      child: HighScorePage(),
                      transitionDuration: const Duration(milliseconds: 400),
                      transitionsBuilder: _slideTransition
                  );
                }
            )
          ]
      )
    ]
);

Widget _slideTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child
    ){
  final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut
  );
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1.0, 1.0),
      end: Offset.zero,
    ).animate(curvedAnimation),
    child: child,
  );

}