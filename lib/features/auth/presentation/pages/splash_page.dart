import 'package:an_gi/core/theme/app_colors.dart';
import 'package:an_gi/core/theme/app_sizes.dart';
import 'package:an_gi/core/utils/responsive_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:an_gi/core/app_config/app_config_cubit.dart';
import '../../../../core/constants/app_strings.dart';
import 'auth_page.dart';
import 'language_selection_page.dart';
import 'onboarding_page.dart';
import '../../../meal_plan/presentation/pages/meal_plan_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _startSplashTimer();
  }

  void _startSplashTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _handleNavigation();
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
    return Scaffold(
      backgroundColor: AppColors.primary, // Ăn theo màu hệ thống dùng chung
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: context.scaleW(80),
              color: Colors.white,
            ),
            SizedBox(height: context.scaleH(16)),
            Text(
              AppStrings.get(
                context,
                'app_name',
              ), // Đã phủ Localization cho tên app
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSizes.fontHeader(
                  context,
                ), // Ép kích thước chữ theo chuẩn co giãn
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
