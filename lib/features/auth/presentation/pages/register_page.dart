// lib/features/auth/presentation/pages/register_page.dart

import 'package:flutter/material.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      // TODO: Gửi sự kiện RegisterEvent sang AuthBloc ở bước tiếp theo
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
                  SizedBox(height: AppSizes.spaceM(context)),
                  _BackButton(context: context),
                  SizedBox(height: AppSizes.spaceM(context)),
                  _HeaderSection(context: context),
                  SizedBox(height: AppSizes.spaceL(context)),

                  // Ứng dụng linh kiện dùng chung CustomTextField cực kỳ gọn gàng
                  CustomTextField(
                    context: context,
                    label: AppStrings.get(context, 'name_label'),
                    hint: AppStrings.get(context, 'name_hint'),
                    controller: _nameController,
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.get(context, 'empty_name');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSizes.spaceM(context)),
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
                      onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.get(context, 'empty_password');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSizes.spaceM(context)),
                  CustomTextField(
                    context: context,
                    label: AppStrings.get(context, 'confirm_password_label'),
                    hint: AppStrings.get(context, 'confirm_password_hint'),
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    prefixIcon: Icons.lock_clock_outlined,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => setState(
                        () => _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible,
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return AppStrings.get(context, 'password_not_match');
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: AppSizes.spaceX(context)),
                  _RegisterButton(context: context, onPressed: _handleRegister),
                  SizedBox(height: AppSizes.spaceX(context)),
                  _LoginFooter(context: context),
                  SizedBox(height: AppSizes.spaceM(context)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- CÁC LOCAL PRIVATE WIDGETS ---

class _BackButton extends StatelessWidget {
  final BuildContext context;
  const _BackButton({required this.context});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final BuildContext context;
  const _HeaderSection({required this.context});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.get(context, 'register_title'),
          style: AppTextStyles.heading1(
            context,
          ).copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSizes.spaceS(context)),
        Text(
          AppStrings.get(context, 'register_subtitle'),
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onPressed;
  const _RegisterButton({required this.context, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSizes.buttonHeight(context),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors
              .secondary, // Dùng màu xanh lá an tâm, tin cậy cho Đăng ký
          elevation: 4,
          shadowColor: const Color(
            0x662E7D32,
          ), // Mã màu tĩnh cứng thay thế withOpacity
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusL(context)),
          ),
        ),
        child: Text(
          AppStrings.get(context, 'register_button'),
          style: AppTextStyles.buttonText(
            context,
          ).copyWith(color: Colors.white),
        ),
      ),
    );
  }
}

class _LoginFooter extends StatelessWidget {
  final BuildContext context;
  const _LoginFooter({required this.context});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.get(context, 'already_account'),
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Text(
            AppStrings.get(context, 'login_now'),
            style: AppTextStyles.bodyBold(
              context,
            ).copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
