import 'package:flutter/material.dart';
import 'package:nhanvien/screens/home/home_screen.dart';
import 'package:nhanvien/screens/login/login_screen.dart';
import 'package:nhanvien/screens/order/order_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String order = '/order';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    order: (context) => const OrderScreen(),
  };
} 