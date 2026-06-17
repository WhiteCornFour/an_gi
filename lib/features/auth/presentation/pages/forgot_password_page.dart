import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/components/app_toast.dart'; // Nạp vũ khí Toast
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

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
      // ĐẤU NỐI LOGIC: Bắn sự kiện gửi email sang AuthBloc
      context.read<AuthBloc>().add(
        ForgotPasswordSubmittedEvent(email: _emailController.text.trim()),
      );
    } else {
      AppToast.show(
        context,
        message: AppStrings.get(context, 'warning_form_invalid'),
        type: ToastType.warning,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailureState) {
          AppToast.show(
            context,
            message: AppStrings.get(context, state.errorMessageKey),
            type: ToastType.error,
          );
        }
        if (state is AuthForgotPasswordSuccessState) {
          AppToast.show(
            context,
            message: AppStrings.get(context, 'success_send_email'),
            type: ToastType.success,
          );
          Navigator.pop(
            context,
          ); // Quay về trang Login sau khi gửi link thành công
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoadingState;

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
                      const _BackButton(), // Widget quay lại phòng khách
                      SizedBox(height: AppSizes.spaceX(context)),
                      _HeaderSection(context: context),
                      SizedBox(height: AppSizes.spaceX(context) * 1.5),
                      CustomTextField(
                        label: AppStrings.get(context, 'email_label'),
                        hint: AppStrings.get(context, 'email_hint'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        enabled:
                            !isLoading, // Khóa trường nhập khi đang gọi API
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return AppStrings.get(context, 'invalid_email');
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizes.spaceX(context) * 1.5),
                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            )
                          : _SubmitButton(
                              context: context,
                              onPressed: _handleSubmit,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- CÁC PRIVATE SUB-WIDGETS ĐÃ ĐƯỢC CHUẨN HÓA KIẾN TRÚC ---

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSizes.spaceM(context)),
      child: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        color: AppColors.textPrimary,
        iconSize: AppSizes.iconL(context),
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
          shadowColor: const Color(0x66E65100),
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
