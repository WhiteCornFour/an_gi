import 'package:an_gi/core/app_config/app_config_cubit.dart';
import 'package:an_gi/features/auth/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localization/language_cubit.dart';
import '../../../../core/utils/responsive_helper.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scaleW(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: context.scaleH(60)),
              const _HeaderSection(),
              SizedBox(height: context.scaleH(48)),
              const _LanguageOptionsList(),
              const Spacer(),
              const _ConfirmButton(),
              SizedBox(height: context.scaleH(24)),
            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET THÀNH PHẦN 1: TIÊU ĐỀ MÀN HÌNH ---
class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          Icons.translate_rounded,
          size: context.scaleW(64),
          color: Colors.green.shade700,
        ),
        SizedBox(height: context.scaleH(16)),
        Text(
          AppStrings.get(context, 'select_language'),
          style: TextStyle(
            fontSize: context.scaleSp(24),
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade900,
          ),
        ),
      ],
    );
  }
}

// --- WIDGET THÀNH PHẦN 2: DANH SÁCH LỰA CHỌN ---
class _LanguageOptionsList extends StatelessWidget {
  const _LanguageOptionsList();

  @override
  Widget build(BuildContext context) {
    final currentLang = context.watch<LanguageCubit>().state;
    final cubit = context.read<LanguageCubit>();

    return Column(
      children: [
        _LanguageCard(
          title: 'Tiếng Việt',
          subtitle: 'Vietnamese',
          flag: '🇻🇳',
          isSelected: currentLang == 'vi',
          onTap: () => cubit.changeLanguage('vi'),
        ),
        SizedBox(height: context.scaleH(16)),
        _LanguageCard(
          title: 'English',
          subtitle: 'English',
          flag: '🇺🇸',
          isSelected: currentLang == 'en',
          onTap: () => cubit.changeLanguage('en'),
        ),
      ],
    );
  }
}

// Thẻ bọc giao diện cho từng ngôn ngữ (Tách nhỏ để tái sử dụng)
class _LanguageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String flag;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.title,
    required this.subtitle,
    required this.flag,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.scaleW(16)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.all(context.scaleW(16)),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(context.scaleW(16)),
          border: Border.all(
            color: isSelected ? Colors.green.shade600 : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: TextStyle(fontSize: context.scaleSp(28))),
            SizedBox(width: context.scaleW(16)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: context.scaleSp(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: context.scaleSp(12),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green.shade700,
                size: context.scaleW(24),
              ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET THÀNH PHẦN 3: NÚT XÁC NHẬN ---
class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Đánh dấu đã chọn ngôn ngữ thành công
        context.read<AppConfigCubit>().setLanguageSelected();

        // Sau đó mới điều hướng sang Onboarding Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: context.scaleH(16)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.scaleW(28)),
        ),
      ),
      child: Text(
        AppStrings.get(context, 'continue'),
        style: TextStyle(
          fontSize: context.scaleSp(16),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
