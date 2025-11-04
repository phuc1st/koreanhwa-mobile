import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:koreanhwa_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:koreanhwa_flutter/features/auth/presentation/pages/register_page.dart';
import 'package:koreanhwa_flutter/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:koreanhwa_flutter/features/home/presentation/pages/home_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/register',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'home',
        pageBuilder: (context, state) => const MaterialPage(child: HomePage()),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        pageBuilder: (context, state) => const MaterialPage(child: DashboardPage()),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => const MaterialPage(child: LoginPage()),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => const MaterialPage(child: RegisterPage()),
      ),
    ],
  );
});
