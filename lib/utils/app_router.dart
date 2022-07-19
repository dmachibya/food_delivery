import 'package:food_delivery/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import 'auth.dart';

class RouterHelper {
  static final router = GoRouter(initialLocation: "/login", routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        return HomeScreen();
      },
      redirect: (state) {
        if (AuthHelper().user == null) {
          return "/login";
        }

        return null;
      },
    ),
    GoRoute(
        path: '/login',
        builder: (context, state) {
          return LoginScreen();
        },
        redirect: (state) {
          if (AuthHelper().user != null) {
            return "/";
          }

          return null;
        },
        routes: [
          GoRoute(
              path: 'register',
              builder: (context, state) {
                return RegisterScreen();
              })
        ]),
  ]);
}
