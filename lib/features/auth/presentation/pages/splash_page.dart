import 'package:an_gi/features/auth/presentation/pages/auth_page.dart';
import 'package:an_gi/features/auth/presentation/pages/language_selection_page.dart';
import 'package:an_gi/features/auth/presentation/pages/onboarding_page.dart';
import 'package:an_gi/features/meal_plan/presentation/pages/meal_plan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:an_gi/core/app_config/app_config_cubit.dart'; // Đường dẫn tới Cubit của bạn

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // Khởi động bộ đếm thời gian an toàn trước khi điều hướng
    _startSplashTimer();
  }

  void _startSplashTimer() {
    // Chờ 2 giây để hiển thị thương hiệu ứng dụng "Ăn gì?" trước
    Future.delayed(const Duration(seconds: 2), () {
      // Luôn kiểm tra xem Widget có còn hiển thị trên màn hình không (mounted) trước khi điều hướng
      if (mounted) {
        _handleNavigation();
      }
    });
  }

  void _handleNavigation() {
    final configState = context.read<AppConfigCubit>().state;
    final supabaseSession = Supabase.instance.client.auth.currentSession;

    if (!configState.isLanguageSelected) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
      );
    } else if (!configState.isOnboardingCompleted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    } else if (supabaseSession == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MealPlanPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.green, // Màu nền thương hiệu "Ăn gì?"
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 80, color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Ăn Gì?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
