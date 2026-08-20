import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_radius.dart';

class AuthStep extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const AuthStep({
    super.key,
    required this.onAuthenticated,
  });

  @override
  State<AuthStep> createState() => _AuthStepState();
}

// class _AuthStepState extends State<AuthStep> {
//   bool isLogin = true;

//   void switchMode() {
//     setState(() {
//       isLogin = !isLogin;
//     });
//   }

//   void authenticate() {
//     widget.onAuthenticated();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: AppSpacing.lg,
//       ),
//       child: Column(
//         children: [
//           const Spacer(),

//           Text(
//             isLogin ? 'Вхід' : 'Реєстрація',
//             style: AppTextStyles.h1,
//           ),

//           const SizedBox(
//             height: AppSpacing.xl,
//           ),

//           if (!isLogin)
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Імʼя',
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(
//                     color: AppColors.border,
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),

//           if (!isLogin)
//             const SizedBox(
//               height: AppSpacing.md,
//             ),

//           TextField(
//             keyboardType: TextInputType.emailAddress,
//             decoration: InputDecoration(
//               hintText: 'Email',
//               enabledBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(
//                   color: AppColors.border,
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),

//           const SizedBox(
//             height: AppSpacing.md,
//           ),

//           TextField(
//             obscureText: true,
//             decoration: InputDecoration(
//               hintText: 'Пароль',
//               enabledBorder: OutlineInputBorder(
//                 borderSide: const BorderSide(
//                   color: AppColors.border,
//                 ),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),

//           if (!isLogin)
//             const SizedBox(
//               height: AppSpacing.md,
//             ),

//           if (!isLogin)
//             TextField(
//               obscureText: true,
//               decoration: InputDecoration(
//                 hintText: 'Підтвердження паролю',
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(
//                     color: AppColors.border,
//                   ),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),

//           const SizedBox(
//             height: AppSpacing.xl,
//           ),

//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: authenticate,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.accent,
//                 foregroundColor: AppColors.bg,
//                 minimumSize: const Size(
//                   double.infinity,
//                   52,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               child: Text(
//                 isLogin ? 'Увійти' : 'Зареєструватися',
//                 style: AppTextStyles.button,
//               ),
//             ),
//           ),

//           const SizedBox(
//             height: AppSpacing.md,
//           ),

//           TextButton(
//             onPressed: switchMode,
//             child: Text(
//               isLogin
//                   ? 'Ще не маєте акаунту? Зареєструватися'
//                   : 'Вже маєте акаунт? Увійти',
//               style: const TextStyle(
//                 color: AppColors.accent,
//               ),
//             ),
//           ),

//           const Spacer(),
//         ],
//       ),
//     );
//   }
// }

class _AuthStepState extends State<AuthStep> {
  bool isLogin = true;
  bool obscurePassword = true;
  bool obscureConfirm = true;

  void switchMode() => setState(() => isLogin = !isLogin);

  Widget _buildField({
    required String label,
    required TextEditingController? controller,
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
            isLogin
                ? 'Увійдіть, щоб продовжити'
                : 'Це займе менше хвилини',
            style: AppTextStyles.bodySmall,
          ),

          const SizedBox(height: AppSpacing.xl),

          if (!isLogin) ...[
            _buildField(label: 'Імʼя', controller: null),
            const SizedBox(height: AppSpacing.md),
          ],

          _buildField(
            label: 'Email',
            controller: null,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.md),

          _buildField(
            label: 'Пароль',
            controller: null,
            obscure: obscurePassword,
            toggleObscure: () => setState(() => obscurePassword = !obscurePassword),
          ),

          if (!isLogin) ...[
            const SizedBox(height: AppSpacing.md),
            _buildField(
              label: 'Підтвердження паролю',
              controller: null,
              obscure: obscureConfirm,
              toggleObscure: () => setState(() => obscureConfirm = !obscureConfirm),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: widget.onAuthenticated,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.bg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
              child: Text(
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