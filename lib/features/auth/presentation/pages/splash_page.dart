import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:an_gi/core/theme/app_colors.dart';
import 'package:an_gi/core/theme/app_sizes.dart';
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
  String _loadingStatus = '';

  @override
  void initState() {
    super.initState();
    _initializeAppCoreFlow(); // Kích hoạt chuỗi kiểm tra hệ thống tự động
  }

  /// Bộ điều tốc xử lý tuần tự toàn bộ các tác vụ hạ tầng trước khi vào app
  Future<void> _initializeAppCoreFlow() async {
    try {
      // MỐC 1: Kiểm tra kết nối Internet (0% -> 20%)
      _updateProgress(0.2, 'Checking network connection...');
      await Future.delayed(
        const Duration(milliseconds: 400),
      ); // Tạo độ trễ mượt UX
      bool hasInternet = await _checkInternetConnection();

      // MỐC 2: Kiểm tra kết nối dịch vụ Firebase (20% -> 40%)
      _updateProgress(0.4, 'Initializing security gates...');
      await Future.delayed(const Duration(milliseconds: 400));
      final auth = FirebaseAuth.instance;

      // MỐC 3: Đồng bộ trạng thái HydratedBLoC (40% -> 60%)
      _updateProgress(0.6, 'Loading local configurations...');
      await Future.delayed(const Duration(milliseconds: 400));

      if (!mounted) {
        return;
      }
      final configState = context.read<AppConfigCubit>().state;

      // MỐC 4: Giả lập Pre-fetch dữ liệu thực đơn để chạy Offline (60% -> 80%)
      _updateProgress(
        0.8,
        hasInternet
            ? 'Pre-fetching weekly recipes...'
            : 'Working in offline mode...',
      );
      await Future.delayed(const Duration(milliseconds: 500));

      // MỐC 5: Hoàn tất kiểm tra, chốt hạ mục tiêu (80% -> 100%)
      _updateProgress(1.0, 'System ready!');
      await Future.delayed(const Duration(milliseconds: 300));

      if (mounted) _handleSmartNavigation(configState, auth.currentUser);
    } catch (e) {
      // Cơ chế phòng vệ nếu Firebase hoặc hệ thống trục trặc, vẫn ép qua cổng để né màn hình treo
      _updateProgress(1.0, 'Entering fallback mode...');
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        final configState = context.read<AppConfigCubit>().state;
        _handleSmartNavigation(configState, FirebaseAuth.instance.currentUser);
      }
    }
  }

  /// Hàm cập nhật tiến trình chạy thanh phần trăm an toàn cho State
  void _updateProgress(double progress, String status) {
    if (mounted) {
      setState(() {
        _loadingProgress = progress;
        _loadingStatus = status;
      });
    }
  }

  /// Kiểm tra thực tế xem thiết bị có internet thật hay không bằng cơ chế lookup domain
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false; // Trả về false nếu rớt mạng hoặc timeout mà không làm sập ứng dụng
    }
  }

  /// Bộ điều hướng rẽ nhánh thông minh sau khi đã nạp đủ 100% tài nguyên
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
      backgroundColor:
          AppColors.primary, // Ăn theo dải màu cốt lõi của thương hiệu
      body: Center(
        child: _SplashContent(
          progress: _loadingProgress,
          statusMessage: _loadingStatus,
        ),
      ),
    );
  }
}

/// Local Private Widget đóng gói giao diện hiển thị danh mục nhận diện và thanh tiến trình
class _SplashContent extends StatelessWidget {
  final double progress;
  final String statusMessage;

  const _SplashContent({required this.progress, required this.statusMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.scaleW(40)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          // Thân bài: Hiển thị biểu tượng ẩm thực co giãn chuẩn Responsive
          Icon(
            Icons.restaurant_menu,
            size: context.scaleW(85),
            color: Colors.white,
          ),
          SizedBox(height: context.scaleH(16)),
          Text(
            AppStrings.get(context, 'app_name'),
            style: TextStyle(
              color: Colors.white,
              fontSize: AppSizes.fontHeader(context),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(flex: 2),
          // Chân bài: Khu vực hiển thị thanh Loading % và Trạng thái tác vụ ngầm
          _ProgressBarSection(progress: progress, statusMessage: statusMessage),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}

/// Widget con xử lý giao diện thanh phần trăm và dòng văn bản trạng thái ngầm
class _ProgressBarSection extends StatelessWidget {
  final double progress;
  final String statusMessage;

  const _ProgressBarSection({
    required this.progress,
    required this.statusMessage,
  });

  @override
  Widget build(BuildContext context) {
    // Ép cứng mã màu Hex ARGB tĩnh thay cho withOpacity để bảo toàn hiệu năng GPU 120 FPS
    final Color trackColor = const Color(0x33FFFFFF); // Trắng trong suốt 20%
    final int percentage = (progress * 100).toInt();

    return Column(
      children: [
        // Hiển thị số phần trăm chạy động
        Text(
          '$percentage%',
          style: TextStyle(
            color: Colors.white,
            fontSize: context.scaleW(16),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.scaleH(10)),
        // Thanh LinearProgressIndicator có bo góc mềm mại
        ClipRRect(
          borderRadius: BorderRadius.circular(context.scaleW(10)),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: trackColor,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: context.scaleH(6),
          ),
        ),
        SizedBox(height: context.scaleH(12)),
        // Dòng chữ thông báo tác vụ ngầm nhỏ tinh tế ở dưới cùng
        Text(
          statusMessage,
          style: TextStyle(
            color: const Color(
              0xB3FFFFFF,
            ), // Trắng trong suốt 70% giúp mắt dễ điều tiết
            fontSize: context.scaleW(13),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
