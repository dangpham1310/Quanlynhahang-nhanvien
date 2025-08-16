import 'package:flutter/material.dart';
import 'package:nhanvien/screens/home/home_screen.dart';
import 'package:nhanvien/screens/login/login_screen.dart';
import 'package:nhanvien/screens/order/order_screen.dart';
import 'package:nhanvien/screens/order/pages/payment_screen.dart';
import 'package:nhanvien/screens/order/pages/cash_payment_screen.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String order = '/order';
  static const String payment = '/payment';
  static const String cashPayment = '/cash-payment';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    order: (context) => const OrderScreen(),
    payment: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        return PaymentScreen(
          totalAmount: args['totalAmount'] ?? 0.0,
          orderItems: args['orderItems'] ?? [],
          tableNumber: args['tableNumber'] ?? 'N/A',
        );
      }
      // Fallback values if no arguments provided
      return const PaymentScreen(
        totalAmount: 12.06,
        orderItems: [
          {'name': 'Coco Love mit Garnelen', 'quantity': 1, 'price': 7.50},
          {'name': 'Miso Suppe', 'quantity': 3, 'price': 5.90},
        ],
        tableNumber: '8001',
      );
    },
    cashPayment: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        return CashPaymentScreen(
          totalAmount: args['totalAmount'] ?? 0.0,
          orderItems: args['orderItems'] ?? [],
          tableNumber: args['tableNumber'] ?? 'N/A',
        );
      }
      // Fallback values if no arguments provided
      return const CashPaymentScreen(
        totalAmount: 12.06,
        orderItems: [
          {'name': 'Coco Love mit Garnelen', 'quantity': 1, 'price': 7.50},
          {'name': 'Miso Suppe', 'quantity': 3, 'price': 5.90},
        ],
        tableNumber: '8001',
      );
    },
  };
} 