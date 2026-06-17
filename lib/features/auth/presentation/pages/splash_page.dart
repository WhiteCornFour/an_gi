import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:an_gi/core/utils/responsive_helper.dart';
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
  double _loadingProgress = 0.0;
  String _statusKey =
      'splash_connecting'; // Lưu Key thay vì Hardcode String để chạy Localization

  @override
  void initState() {
    super.initState();
    _initializeAppCoreFlow();
  }

  Future<void> _initializeAppCoreFlow() async {
    final configCubit = context.read<AppConfigCubit>();
    final auth = FirebaseAuth.instance;

    try {
      // MỐC 1: Kiểm tra mạng (0% -> 20%)
      _updateProgress(0.2, 'splash_connecting');
      await Future.delayed(const Duration(milliseconds: 500));
      bool hasInternet = await _checkInternetConnection();

      // MỐC 2: Kiểm tra Firebase (20% -> 40%)
      _updateProgress(0.4, 'splash_security');
      await Future.delayed(const Duration(milliseconds: 400));

      // MỐC 3: Cấu hình hệ thống (40% -> 60%)
      _updateProgress(0.6, 'splash_sync');
      await Future.delayed(const Duration(milliseconds: 400));
      final configState = configCubit.state;

      // MỐC 4: Tải dữ liệu đệm (60% -> 80%)
      _updateProgress(
        0.8,
        hasInternet ? 'splash_recipes_online' : 'splash_recipes_offline',
      );
      await Future.delayed(const Duration(milliseconds: 500));

      // MỐC 5: Sẵn sàng (80% -> 100%)
      _updateProgress(1.0, 'splash_ready');
      await Future.delayed(const Duration(milliseconds: 400));

      if (mounted) _handleSmartNavigation(configState, auth.currentUser);
    } catch (e) {
      _updateProgress(1.0, 'splash_fallback');
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) {
        _handleSmartNavigation(configCubit.state, auth.currentUser);
      }
    }
  }

  void _updateProgress(double progress, String statusKey) {
    if (mounted) {
      setState(() {
        _loadingProgress = progress;
        _statusKey = statusKey;
      });
    }
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  void _handleSmartNavigation(dynamic configState, User? currentUser) {
    if (!configState.isLanguageSelected) {
      _navigateTo(const LanguageSelectionPage());
    } else if (!configState.isOnboardingCompleted) {
      _navigateTo(const OnboardingPage());
    } else if (currentUser == null) {
      _navigateTo(const AuthPage());
    } else {
      _navigateTo(const MealPlanPage());
    }
  }

  void _navigateTo(Widget targetPage) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF9233), // Cam hoàng hôn
              Color(0xFFFF4B2B), // Đỏ cam đậm ẩm thực
            ],
          ),
        ),
        child: Center(
          child: _SplashContent(
            progress: _loadingProgress,
            statusKey: _statusKey,
          ),
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  final double progress;
  final String statusKey;

  const _SplashContent({required this.progress, required this.statusKey});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.scaleW(45)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 4),

          // Container bọc Logo đổ bóng khối chuyên nghiệp
          Container(
            width: context.scaleW(135),
            height: context.scaleW(135),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(
                    0x1F000000,
                  ), // Mức mờ 12% tĩnh (không dùng withOpacity)
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            padding: EdgeInsets.all(context.scaleW(16)),
            child: Image.asset(
              'assets/images/app_logo_transparent.png',
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: context.scaleH(20)),

          // Tên ứng dụng đồng bộ hóa hệ thống chữ
          Text(
            AppStrings.get(context, 'app_name'),
            style: TextStyle(
              color: Colors.white,
              fontSize: context.scaleW(30),
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              shadows: const [
                Shadow(
                  color: Color(0x26000000), // Mức mờ 15% tĩnh
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
          ),

          const Spacer(flex: 3),

          // Khối hiển thị thanh trạng thái và tiến trình %
          _ProgressBarSection(progress: progress, statusKey: statusKey),

          const Spacer(flex: 1),
        ],
      ),
    );
  }
}

class _ProgressBarSection extends StatelessWidget {
  final double progress;
  final String statusKey;

  const _ProgressBarSection({required this.progress, required this.statusKey});

  @override
  Widget build(BuildContext context) {
    final int percentage = (progress * 100).toInt();

    return Column(
      children: [
        Text(
          '$percentage%',
          style: const TextStyle(
            color: Color(0xE6FFFFFF), // Mức mờ 90% tĩnh
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.scaleH(8)),

        // Thanh tiến trình Linear mảnh, bo góc hiện đại
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: context.scaleH(4),
            width: context.scaleW(180),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0x40FFFFFF), // Mức mờ 25% tĩnh
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
        SizedBox(height: context.scaleH(12)),

        // Hiệu ứng đổi chữ mượt mà và gọi dữ liệu qua Localization hệ thống
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            AppStrings.get(
              context,
              statusKey,
            ), // ✅ ĐÃ LÀM SẠCH: Đưa chuỗi qua bộ dịch tự động theo Key
            key: ValueKey<String>(statusKey),
            style: const TextStyle(
              color: Color(0xCCFFFFFF), // Mức mờ 80% tĩnh
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
