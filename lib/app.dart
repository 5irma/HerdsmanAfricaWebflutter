import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Herdsman',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        // Performance optimizations
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Reduce animations for better performance
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.web: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        // Optimize text rendering
        textTheme: Theme.of(
          context,
        ).textTheme.apply(fontSizeFactor: 1.0, fontSizeDelta: 0.0),
      ),
      routerConfig: AppRouter.router,
      // Performance settings
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            // Reduce text scale factor for consistency
            textScaleFactor: 1.0,
          ),
          child: child!,
        );
      },
    );
  }
}
