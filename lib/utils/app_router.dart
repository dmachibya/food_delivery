import 'package:go_router/go_router.dart';

import '../screens/login_screen.dart';
import '../screens/register_screen.dart';

class RouterHelper {
  static final router = GoRouter(initialLocation: "/login", routes: [
    GoRoute(
        path: '/login',
        builder: (context, state) {
          return LoginScreen();
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
