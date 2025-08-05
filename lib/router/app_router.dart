import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home-section',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/how-it-works',
        name: 'how-it-works',
        builder: (context, state) =>
            const HomeScreen(scrollToSection: 'how-it-works'),
      ),
      GoRoute(
        path: '/who-its-for',
        name: 'who-its-for',
        builder: (context, state) =>
            const HomeScreen(scrollToSection: 'who-its-for'),
      ),
      GoRoute(
        path: '/solutions',
        name: 'solutions',
        builder: (context, state) =>
            const HomeScreen(scrollToSection: 'solutions'),
      ),
      GoRoute(
        path: '/testimonials',
        name: 'testimonials',
        builder: (context, state) =>
            const HomeScreen(scrollToSection: 'testimonials'),
      ),
      GoRoute(
        path: '/pricing',
        name: 'pricing',
        builder: (context, state) =>
            const HomeScreen(scrollToSection: 'pricing'),
      ),
      GoRoute(
        path: '/download',
        name: 'download',
        builder: (context, state) =>
            const HomeScreen(scrollToSection: 'download'),
      ),
      GoRoute(
        path: '/faqs',
        name: 'faqs',
        builder: (context, state) => const HomeScreen(scrollToSection: 'faqs'),
      ),
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) =>
            const HomeScreen(scrollToSection: 'contact'),
      ),
    ],
  );
}
