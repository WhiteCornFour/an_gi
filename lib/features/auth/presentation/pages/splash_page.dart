import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 1. Khai tử Supabase, nhúng Firebase Auth vào vị trí gác cổng
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
  @override
  void initState() {
    super.initState();
    _startSplashTimer(); // Kích hoạt hàng đợi đồng hồ đếm ngược an toàn
  }

  void _startSplashTimer() {
    // Tạo khoảng trễ 2 giây để hiển thị logo nịnh mắt và né lỗi vỡ cây Widget (_ModalScope)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _handleNavigation();
    });
  }

  void _handleNavigation() {
    // Đọc trạng thái cấu hình một lần từ bộ nhớ HydratedBLoC
    final configState = context.read<AppConfigCubit>().state;

    // Kiểm tra phiên đăng nhập thực tế của hệ sinh thái FIREBASE
    final currentUser = FirebaseAuth.instance.currentUser;

    // LUỒNG ĐIỀU HƯỚNG TUẦN TỰ THÔNG MINH (USER FLOW)
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
    } else if (currentUser == null) {
      // Nếu chưa đăng nhập tài khoản Firebase -> Đưa ra phòng khách AuthPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    } else {
      // Nếu đã có phiên đăng nhập -> Vào thẳng bên trong để ăn mâm cơm
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MealPlanPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors
          .primary, // 2. Đồng bộ ăn theo dải màu thương hiệu dùng chung mới
      body: Center(
        child:
            _SplashContent(), // 3. Tách nhỏ Widget thành Local Private Widget giúp hàm build "siêu NGỐC"
      ),
    );
  }
}

/// Local Private Widget xử lý riêng giao diện hiển thị thương hiệu
class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Icon ẩm thực tự động co giãn tỷ lệ chuẩn theo không gian thiết bị
        Icon(
          Icons.restaurant_menu,
          size: context.scaleW(80),
          color: Colors.white,
        ),
        SizedBox(height: context.scaleH(16)),
        // Tên ứng dụng được bảo vệ toàn diện bằng Localization đa ngôn ngữ
        Text(
          AppStrings.get(context, 'app_name'),
          style: TextStyle(
            color: Colors.white,
            fontSize: AppSizes.fontHeader(
              context,
            ), // Ép kích thước chữ tự động co giãn
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
