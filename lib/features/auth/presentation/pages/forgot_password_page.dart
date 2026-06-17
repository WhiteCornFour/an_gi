// lib/features/auth/presentation/pages/forgot_password_page.dart

import 'package:flutter/material.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // TODO: Gửi sự kiện ForgotPasswordEvent sang AuthBloc ở bước tiếp theo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.get(context, 'success_send_email'))),
      );
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
                  SizedBox(height: AppSizes.spaceX(context)),
                  _HeaderSection(context: context),
                  SizedBox(height: AppSizes.spaceX(context) * 1.5),

                  // Tái sử dụng linh kiện dùng chung vô cùng mượt mà
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
                  SizedBox(height: AppSizes.spaceX(context) * 1.5),
                  _SubmitButton(context: context, onPressed: _handleSubmit),
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
          AppStrings.get(context, 'forgot_title'),
          style: AppTextStyles.heading1(
            context,
          ).copyWith(color: AppColors.textPrimary),
        ),
        SizedBox(height: AppSizes.spaceS(context)),
        Text(
          AppStrings.get(context, 'forgot_subtitle'),
          style: AppTextStyles.bodyMedium(
            context,
          ).copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final BuildContext context;
  final VoidCallback onPressed;
  const _SubmitButton({required this.context, required this.onPressed});

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
          ), // Triệt tiêu completely withOpacity
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radiusL(context)),
          ),
        ),
        child: Text(
          AppStrings.get(context, 'send_request_button'),
          style: AppTextStyles.buttonText(
            context,
          ).copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
