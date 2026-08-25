import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_radius.dart';

// SUPABASE
import 'package:supabase_flutter/supabase_flutter.dart';

// AUTH REPOSITORY
import 'package:tilolab_app/features/auth/data/auth-repository.dart';

class AuthStep extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const AuthStep({
    super.key,
    required this.onAuthenticated,
  });

  @override
  State<AuthStep> createState() => _AuthStepState();
}

class _AuthStepState extends State<AuthStep> {
  bool isLogin = true;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  final authRepository = AuthRepository();

  bool isLoading = false;
  String? errorMessage;

  // true — показуємо екран "перевірте пошту" замість форми
  bool awaitingEmailConfirmation = false;

  void switchMode() => setState(() {
        isLogin = !isLogin;
        errorMessage = null;
      });

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    debugPrint('[AuthStep] submit tapped. isLogin=$isLogin, email="$email"');

    if (email.isEmpty || password.isEmpty) {
      debugPrint('[AuthStep] validation failed: empty email/password');
      setState(() => errorMessage = 'Заповніть всі поля');
      return;
    }

    if (!isLogin) {
      final name = nameController.text.trim();
      final confirmPassword = confirmPasswordController.text;

      if (name.isEmpty) {
        debugPrint('[AuthStep] validation failed: empty name');
        setState(() => errorMessage = 'Введіть імʼя');
        return;
      }

      if (password != confirmPassword) {
        debugPrint('[AuthStep] validation failed: passwords do not match');
        setState(() => errorMessage = 'Паролі не співпадають');
        return;
      }
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (isLogin) {
        final response = await authRepository.login(
          email: email,
          password: password,
        );

        if (!mounted) return;

        if (response.session == null) {
          // теоретично не має статись при звичайному логіні,
          // але про всяк випадок логуємо і не пускаємо далі
          debugPrint('[AuthStep] login returned without session — unexpected');
          setState(() => errorMessage = 'Не вдалося увійти. Спробуйте ще раз.');
          return;
        }

        debugPrint('[AuthStep] login OK, navigating to home');
        widget.onAuthenticated();
      } else {
        final response = await authRepository.register(
          email: email,
          password: password,
          name: nameController.text.trim(),
        );

        if (!mounted) return;

        if (response.session == null) {
          // Supabase за замовчуванням вимагає підтвердження email:
          // signUp завершується успішно, user створений, але сесії ще нема,
          // поки людина не перейде за посиланням з листа.
          debugPrint('[AuthStep] register OK but session is null — email confirmation required');
          setState(() => awaitingEmailConfirmation = true);
          return;
        }

        debugPrint('[AuthStep] register OK with session, navigating to home');
        widget.onAuthenticated();
      }
    } on AuthException catch (error) {
      debugPrint('[AuthStep] AuthException: ${error.message}');

      if (!mounted) return;
      setState(() => errorMessage = _mapAuthError(error));
    } catch (error, stackTrace) {
      debugPrint('[AuthStep] unknown error: $error');
      debugPrint('$stackTrace');

      if (!mounted) return;
      setState(() => errorMessage = 'Сталася помилка. Спробуйте ще раз.');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  String _mapAuthError(AuthException error) {
    // Supabase повертає повідомлення англійською — мапимо найпоширеніші
    final message = error.message.toLowerCase();

    if (message.contains('invalid login credentials')) {
      return 'Невірний email або пароль';
    }
    if (message.contains('user already registered')) {
      return 'Користувач з таким email вже зареєстрований';
    }
    if (message.contains('password should be at least')) {
      return 'Пароль занадто короткий';
    }
    if (message.contains('email not confirmed')) {
      return 'Підтвердіть email — перевірте пошту';
    }

    return error.message;
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    VoidCallback? toggleObscure,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: AppTextStyles.body,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.transparentFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.borderNeutral),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.borderNeutral),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
            suffixIcon: toggleObscure == null
                ? null
                : IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.darkText,
                      size: 20,
                    ),
                    onPressed: toggleObscure,
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (awaitingEmailConfirmation) {
      return _EmailConfirmationView(
        email: emailController.text.trim(),
        onBackToLogin: () {
          setState(() {
            awaitingEmailConfirmation = false;
            isLogin = true;
            passwordController.clear();
            confirmPasswordController.clear();
          });
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),

          Text(
            isLogin ? 'З поверненням' : 'Створити акаунт',
            style: AppTextStyles.h1,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            isLogin ? 'Увійдіть, щоб продовжити' : 'Це займе менше хвилини',
            style: AppTextStyles.bodySmall,
          ),

          const SizedBox(height: AppSpacing.xl),

          if (!isLogin) ...[
            _buildField(label: 'Імʼя', controller: nameController),
            const SizedBox(height: AppSpacing.md),
          ],

          _buildField(
            label: 'Email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.md),

          _buildField(
            label: 'Пароль',
            controller: passwordController,
            obscure: obscurePassword,
            toggleObscure: () => setState(() => obscurePassword = !obscurePassword),
          ),

          if (!isLogin) ...[
            const SizedBox(height: AppSpacing.md),
            _buildField(
              label: 'Підтвердження паролю',
              controller: confirmPasswordController,
              obscure: obscureConfirm,
              toggleObscure: () => setState(() => obscureConfirm = !obscureConfirm),
            ),
          ],

          const SizedBox(height: AppSpacing.lg),

          if (errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.errorBg,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.errorBorder),
              ),
              child: Text(
                errorMessage!,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.errorText),
                textAlign: TextAlign.center,
              ),
            ),

          const SizedBox(height: AppSpacing.md),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.bg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      isLogin ? 'Увійти' : 'Зареєструватися',
                      style: AppTextStyles.button.copyWith(color: AppColors.bg),
                    ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Center(
            child: TextButton(
              onPressed: switchMode,
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.bodySmall,
                  children: [
                    TextSpan(
                      text: isLogin ? 'Ще не маєте акаунту? ' : 'Вже маєте акаунт? ',
                    ),
                    TextSpan(
                      text: isLogin ? 'Зареєструватися' : 'Увійти',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}

class _EmailConfirmationView extends StatelessWidget {
  final String email;
  final VoidCallback onBackToLogin;

  const _EmailConfirmationView({
    required this.email,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.mark_email_read_outlined,
            size: 56,
            color: AppColors.accent,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Перевірте пошту',
            style: AppTextStyles.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Ми надіслали лист із підтвердженням на\n$email. '
            'Перейдіть за посиланням, щоб завершити реєстрацію.',
            style: AppTextStyles.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onBackToLogin,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                side: const BorderSide(color: AppColors.accent),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(
                'Повернутися до входу',
                style: AppTextStyles.button.copyWith(color: AppColors.accent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}