import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/register_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/partners/partner_search_screen.dart';
import '../../presentation/profile/profile_screen.dart';
import '../../presentation/statistics/statistics_screen.dart';

GoRouter createRouter(String lang) {
  return GoRouter(
    initialLocation: FirebaseAuth.instance.currentUser == null
        ? '/login'
        : '/home',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return LoginScreen(lang: lang);
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          return RegisterScreen(lang: lang);
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          return ProfileScreen(lang: lang);
        },
      ),
      GoRoute(
        path: '/partners',
        builder: (context, state) {
          return PartnerSearchScreen(lang: lang);
        },
      ),
      GoRoute(
        path: '/statistics',
        builder: (context, state) {
          return StatisticsScreen(lang: lang);
        },
      ),
    ],
  );
}