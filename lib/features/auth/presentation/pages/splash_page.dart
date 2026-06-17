import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/localization/language_cubit.dart';
import '../../../../core/utils/responsive_helper.dart';
import '../../../meal_plan/presentation/pages/meal_plan_page.dart';
import 'language_selection_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MealPlanPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LanguageSelectionPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLang = context.watch<LanguageCubit>().state;

    return Scaffold(
      backgroundColor: Colors.green.shade700,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const _SplashLogo(),
            SizedBox(height: context.scaleH(24)),
            _SplashTitle(currentLang: currentLang),
            SizedBox(height: context.scaleH(8)),
            _SplashSlogan(currentLang: currentLang),
            SizedBox(height: context.scaleH(48)),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET THÀNH PHẦN: LOGO ---
class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.scaleW(20)),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.restaurant_menu,
        size: context.scaleW(80),
        color: Colors.green.shade700,
      ),
    );
  }
}

// --- WIDGET THÀNH PHẦN: TÊN APP ---
class _SplashTitle extends StatelessWidget {
  final String currentLang;
  const _SplashTitle({required this.currentLang});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.get('app_name', currentLang),
      style: TextStyle(
        fontSize: context.scaleSp(32),
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 2,
      ),
    );
  }
}

// --- WIDGET THÀNH PHẦN: SLOGAN ---
class _SplashSlogan extends StatelessWidget {
  final String currentLang;
  const _SplashSlogan({required this.currentLang});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.get('splash_slogan', currentLang),
      style: TextStyle(
        fontSize: context.scaleSp(16),
        color: Colors.green.shade100,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
