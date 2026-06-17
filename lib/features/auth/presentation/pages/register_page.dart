import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/custom_text_field.dart';
import '../../../../core/components/app_toast.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

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
      context.read<AuthBloc>().add(
        RegisterSubmittedEvent(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
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
          // Ứng dụng AppToast báo lỗi từ Firebase bất đồng bộ cực kỳ xịn sò
          AppToast.show(
            context,
            message: AppStrings.get(context, state.errorMessageKey),
            type: ToastType.error,
          );
        }
        if (state is AuthRegisterSuccessState) {
          AppToast.show(
            context,
            message: AppStrings.get(context, 'register_success'),
            type: ToastType.success,
          );
          // TODO: Đăng ký thành công chuyển sang home lun
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => HomePage()),
          // );
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
                      SizedBox(height: AppSizes.spaceM(context)),
                      _BackButton(context: context),
                      SizedBox(height: AppSizes.spaceM(context)),
                      _HeaderSection(context: context),
                      SizedBox(height: AppSizes.spaceL(context)),

                      // ĐÃ SỬA: Xóa bỏ hoàn toàn "context: context," dư thừa
                      // và liên kết cờ "enabled" chặn tương tác khi loading API
                      CustomTextField(
                        label: AppStrings.get(context, 'name_label'),
                        hint: AppStrings.get(context, 'name_hint'),
                        controller: _nameController,
                        prefixIcon: Icons.person_outline,
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppStrings.get(context, 'empty_name');
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizes.spaceM(context)),
                      CustomTextField(
                        label: AppStrings.get(context, 'email_label'),
                        hint: AppStrings.get(context, 'email_hint'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        enabled: !isLoading,
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return AppStrings.get(context, 'invalid_email');
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizes.spaceM(context)),
                      CustomTextField(
                        label: AppStrings.get(context, 'password_label'),
                        hint: AppStrings.get(context, 'password_hint'),
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        prefixIcon: Icons.lock_outline,
                        enabled: !isLoading,
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
                        label: AppStrings.get(
                          context,
                          'confirm_password_label',
                        ),
                        hint: AppStrings.get(context, 'confirm_password_hint'),
                        controller: _confirmPasswordController,
                        obscureText: !_isConfirmPasswordVisible,
                        prefixIcon: Icons.lock_clock_outlined,
                        enabled: !isLoading,
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
                            return AppStrings.get(
                              context,
                              'password_not_match',
                            );
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSizes.spaceX(context)),
                      isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.secondary,
                                ),
                              ),
                            )
                          : _RegisterButton(
                              context: context,
                              onPressed: _handleRegister,
                            ),
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
      },
    );
  }
}

// --- CÁC LOCAL PRIVATE WIDGETS GIỮ NGUYÊN KHÔNG ĐỔI ---
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
          backgroundColor: AppColors.secondary,
          elevation: 4,
          shadowColor: const Color(0x662E7D32),
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
