import 'package:flutter/material.dart';
import 'package:we_chat_app/helper/routes/routes_name.dart';
import 'package:we_chat_app/models/chat_user.dart';
import 'package:we_chat_app/screens/auth/login_screen.dart';
import 'package:we_chat_app/screens/home_screen.dart';
import 'package:we_chat_app/screens/profile_screen.dart';
import 'package:we_chat_app/screens/splash_screen.dart';
import 'package:we_chat_app/widgets/chat_user_card.dart';

import '../../apis/apis.dart';
import '../../screens/chat_screen.dart';

class Routes {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case RoutesName.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RoutesName.profileScreen:
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(
            user: APIs.me,
          ),
        );
      case RoutesName.chatScreen:
        return MaterialPageRoute(
          builder: (_) => ChatScreen(
            user: settings.arguments as ChatUser,
          ),
        );
      case RoutesName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('No route defined.'),
            ),
          ),
        );
    }
  }
}
