import 'package:flutter/material.dart';
import 'package:new_texi_driver/views/booking_history_view.dart';
import 'package:new_texi_driver/views/dashboard_view.dart';
import 'package:new_texi_driver/views/register_new_page.dart';

import '../../views/login_view.dart';
import '../../views/register_view.dart';
import '../../views/splash_view.dart';
import 'route_names.dart';

class Routes {
  static Route<dynamic> onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());
      case RouteNames.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginView());
      case RouteNames.register:
        return MaterialPageRoute(
            builder: (BuildContext context) => const RegisterView());
             case RouteNames.bookingHistroyView:
        return MaterialPageRoute(
            builder: (BuildContext context) => const BookingHistroyView());
    
      case RouteNames.registerNextStep:
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
      
        return MaterialPageRoute(
            builder: (BuildContext context) => RegisterNewPage(
                  email: arguments['email'],
                  password: arguments['password'],
                ));
      case RouteNames.dashboard:
        Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (BuildContext context) => DashboardView(
                 user: arguments['driver'],
                ));

        // case RouteNames.afterBookRideView:
        // Map<String, dynamic> arguments =
        //     settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => AfterBookRideView(
      //             bookRideModel: arguments['bookRideModel'],
      //           ));
      // case RouteNames.dashboard:
      //   Map<String, dynamic> arguments =
      //       settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => DashboardView(
      //             user: arguments['user'],
      //           ));

      // case RouteNames.bookingHistroyView:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const BookingHistroyView());
      // case RouteNames.chatWithDriverView:
      //   Map<String, dynamic> arguments =
      //       settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => ChatWithDriverView(
      //           userId: arguments['userId'].toString(),
      //           driverId: arguments['driverId'].toString(),
      //           chatRoomId: arguments['chatRoomId'],
      //           bookingId: arguments['bookingId'].toString()));
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashView());
    }
  }
}
