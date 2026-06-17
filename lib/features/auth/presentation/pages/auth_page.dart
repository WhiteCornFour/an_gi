import 'package:an_gi/core/components/custom_text_field.dart';
import 'package:an_gi/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:an_gi/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Logic BLoC sẽ được đấu nối tại đây ở bước kế tiếp
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingL(context),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSizes.spaceX(context) * 2),
                  _HeaderSection(context: context),
                  SizedBox(height: AppSizes.spaceX(context) * 2),
                  CustomTextField(
                    context: context,
                    label: AppStrings.get(context, 'email_label'),
                    hint: AppStrings.get(context, 'email_hint'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || !value.contains('@')) {
                        return AppStrings.get(context, 'invalid_email');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSizes.spaceM(context)),
                  CustomTextField(
                    context: context,
                    label: AppStrings.get(context, 'password_label'),
                    hint: AppStrings.get(context, 'password_hint'),
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.get(context, 'empty_password');
                      }
                      return null;
                    },
                  ),
                  _ForgotPasswordButton(context: context),
                  SizedBox(height: AppSizes.spaceL(context)),
                  _LoginButton(context: context, onPressed: _handleLogin),
                  SizedBox(height: AppSizes.spaceX(context)),
                  _RegisterFooter(context: context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- CÁC SUB-WIDGETS ĐƯỢC BÓC TÁCH RIÊNG BIỆT ---

class _HeaderSection extends StatelessWidget {
  final BuildContext context;
  const _HeaderSection({required this.context});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(AppSizes.spaceM(context)),
          decoration: const BoxDecoration(
            color:
                AppColors.primaryOpacity10, // ĐÃ FIX: Thay thế withOpacity(0.1)
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.restaurant_menu_rounded,
            size: AppSizes.iconL(context),
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: AppSizes.spaceM(context)),
        Text(
          AppStrings.get(context, 'login_title'),
          style: AppTextStyles.heading1(
            context,
          ).copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSizes.spaceS(context)),
        Text(
          AppStrings.get(context, 'login_subtitle'),
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  final BuildContext context;
  const _ForgotPasswordButton({required this.context});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
          );
        },
        child: Text(
          AppStrings.get(context, 'forgot_password'),
          style: AppTextStyles.bodyBold(
            context,
          ).copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onPressed;
  const _LoginButton({required this.context, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight(context),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          elevation: 4,
          shadowColor: const Color(
            0x66E65100,
          ), // ĐÃ FIX: Thay thế AppColors.primary.withOpacity(0.4) bằng mã màu tĩnh cứng
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusL(context)),
          ),
        ),
        child: Text(
          AppStrings.get(context, 'login_button'),
          style: AppTextStyles.buttonText(
            context,
          ).copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _RegisterFooter extends StatelessWidget {
  final BuildContext context;
  const _RegisterFooter({required this.context});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.get(context, 'no_account'),
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
            );
          },
          child: Text(
            AppStrings.get(context, 'register_now'),
            style: AppTextStyles.bodyBold(
              context,
            ).copyWith(color: AppColors.secondary),
          ),
        ),
      ],
    );
  }
}
