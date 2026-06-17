import 'package:an_gi/core/app_config/app_config_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localization/language_cubit.dart';
import '../../../../core/utils/responsive_helper.dart';
import 'auth_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Cấu hình UI tĩnh (Không chứa text để tối ưu Localization)
  final List<_OnboardingStyleConfig> _configs = [
    _OnboardingStyleConfig(
      icon: Icons.auto_awesome_rounded,
      gradientColors: [Colors.green.shade400, Colors.green.shade700],
    ),
    _OnboardingStyleConfig(
      icon: Icons.published_with_changes_rounded,
      gradientColors: [Colors.amber.shade500, Colors.orange.shade700],
    ),
    _OnboardingStyleConfig(
      icon: Icons.shopping_bag_rounded,
      gradientColors: [Colors.teal.shade400, Colors.teal.shade700],
    ),
  ];

  void _onPageChanged(int index) {
    setState(() => _currentPage = index);
  }

  void _navigateToAuth() {
    // Đánh dấu đã xem xong Onboarding
    context.read<AppConfigCubit>().setOnboardingCompleted();

    // Sau đó mới điều hướng sang màn hình Đăng nhập (AuthPage)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = context.watch<LanguageCubit>().state;

    return Scaffold(
      body: Stack(
        children: [
          _OnboardingSlider(
            pageController: _pageController,
            onPageChanged: _onPageChanged,
            configs: _configs,
            currentLang: currentLang,
          ),
          if (_currentPage < _configs.length - 1)
            _SkipButton(onPressed: _navigateToAuth, currentLang: currentLang),
          _BottomActionBar(
            configs: _configs,
            currentPage: _currentPage,
            currentLang: currentLang,
            onNext: () {
              if (_currentPage < _configs.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              } else {
                _navigateToAuth();
              }
            },
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// CÁC WIDGET THÀNH PHẦN (LOCAL COMPONENT WIDGETS)
// =========================================================================

class _OnboardingSlider extends StatelessWidget {
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final List<_OnboardingStyleConfig> configs;
  final String currentLang;

  const _OnboardingSlider({
    required this.pageController,
    required this.onPageChanged,
    required this.configs,
    required this.currentLang,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
      itemCount: configs.length,
      itemBuilder: (context, index) {
        final config = configs[index];
        final title = AppStrings.get(
          'onboarding_title_${index + 1}',
          currentLang,
        );
        final desc = AppStrings.get(
          'onboarding_desc_${index + 1}',
          currentLang,
        );

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                config.gradientColors[0].withValues(alpha: 0.15),
                Colors.white,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.scaleW(32)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  _IconDisplayContainer(config: config),
                  const Spacer(),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: context.scaleSp(28),
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade900,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.scaleH(16)),
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: context.scaleSp(16),
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _IconDisplayContainer extends StatelessWidget {
  final _OnboardingStyleConfig config;
  const _IconDisplayContainer({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.scaleW(40)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: config.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: config.gradientColors[1].withValues(alpha: 0.4),
            blurRadius: context.scaleW(25),
            offset: Offset(0, context.scaleH(12)),
          ),
        ],
      ),
      child: Icon(config.icon, size: context.scaleW(100), color: Colors.white),
    );
  }
}

class _SkipButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String currentLang;

  const _SkipButton({required this.onPressed, required this.currentLang});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.paddingOf(context).top + context.scaleH(12),
      right: context.scaleW(16),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey.shade600,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: context.scaleSp(15),
          ),
        ),
        child: Text(AppStrings.get('skip', currentLang)),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  final List<_OnboardingStyleConfig> configs;
  final int currentPage;
  final String currentLang;
  final VoidCallback onNext;

  const _BottomActionBar({
    required this.configs,
    required this.currentPage,
    required this.currentLang,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: context.scaleH(40),
      left: context.scaleW(32),
      right: context.scaleW(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _IndicatorsList(configs: configs, currentPage: currentPage),
          _NavigationButton(
            configs: configs,
            currentPage: currentPage,
            currentLang: currentLang,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _IndicatorsList extends StatelessWidget {
  final List<_OnboardingStyleConfig> configs;
  final int currentPage;

  const _IndicatorsList({required this.configs, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        configs.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: context.scaleW(8)),
          height: context.scaleH(8),
          width: currentPage == index ? context.scaleW(24) : context.scaleW(8),
          decoration: BoxDecoration(
            color: currentPage == index
                ? configs[currentPage].gradientColors[1]
                : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(context.scaleW(4)),
          ),
        ),
      ),
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final List<_OnboardingStyleConfig> configs;
  final int currentPage;
  final String currentLang;
  final VoidCallback onPressed;

  const _NavigationButton({
    required this.configs,
    required this.currentPage,
    required this.currentLang,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = currentPage == configs.length - 1;
    final label = AppStrings.get(isLast ? 'start_now' : 'next', currentLang);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: context.scaleW(24),
          vertical: context.scaleH(16),
        ),
        backgroundColor: configs[currentPage].gradientColors[1],
        foregroundColor: Colors.white,
        elevation: 4,
        shadowColor: configs[currentPage].gradientColors[1].withValues(
          alpha: 0.4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.scaleW(30)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: context.scaleSp(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: context.scaleW(8)),
          Icon(
            isLast ? Icons.done_rounded : Icons.arrow_forward_rounded,
            size: context.scaleW(18),
          ),
        ],
      ),
    );
  }
}

class _OnboardingStyleConfig {
  final IconData icon;
  final List<Color> gradientColors;

  _OnboardingStyleConfig({required this.icon, required this.gradientColors});
}
