import 'package:flutter/material.dart';

class AppRouteInfo{
  final String name;
  final String path;

  const AppRouteInfo({
    required this.name,
    required this.path
  });
}

class AppRoute{
  static const splash = AppRouteInfo(
      name: 'Splash_Page',
      path: '/'
  );
  static const home = AppRouteInfo(
      name: 'Home_Page',
      path: '/home'
  );
  static const ingame = AppRouteInfo(
      name: 'InGame_Page',
      path: '/ingame'
  );
  static const highscore = AppRouteInfo(
      name: 'HighScore Page',
      path: '/highscore_page'
  );
  static const setting = AppRouteInfo(
      name: 'Setting_Page',
      path: '/setting_page'
  );

  static List<AppRouteInfo> get all => [splash, home, ingame, highscore, setting];
}