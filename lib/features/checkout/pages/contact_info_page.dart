import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/ua_phone_formatter.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_text_field.dart';
import '../data/contact_info.dart';
import '../services/checkout_store.dart';

class ContactInfoPage extends StatefulWidget {
  const ContactInfoPage({super.key});

  @override
  State<ContactInfoPage> createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  late final firstNameController =
      TextEditingController(text: CheckoutStore.instance.contact?.firstName ?? '');
  late final lastNameController =
      TextEditingController(text: CheckoutStore.instance.contact?.lastName ?? '');
  late final phoneController =
      TextEditingController(text: CheckoutStore.instance.contact?.phone ?? '+38 (0');
  late final emailController =
      TextEditingController(text: CheckoutStore.instance.contact?.email ?? '');

  String? errorMessage;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final error = Validators.firstError([
      () => Validators.cyrillicName(firstNameController.text, message: "Введіть ім'я Українською"),
      () => Validators.cyrillicName(lastNameController.text, message: 'Введіть прізвище Українською'),
      () => Validators.uaPhone(phoneController.text),
      () => Validators.email(emailController.text),
    ]);

    if (error != null) {
      setState(() => errorMessage = error);
      return;
    }

    await CheckoutStore.instance.saveContact(
      ContactInfo(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
      ),
    );

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        centerTitle: false,
        title: Text('Контактні дані', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.md,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                children: [
                  AppTextField(label: "Ім'я (Українською)", controller: firstNameController),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(label: 'Прізвище (Українською)', controller: lastNameController),
                  const SizedBox(height: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Телефон', style: AppTextStyles.caption),
                      const SizedBox(height: AppSpacing.xs),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [UaPhoneInputFormatter()],
                        style: AppTextStyles.body,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.surface,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Електронна пошта',
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  if (errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.md),
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
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.borderNeutral)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: AppColors.bg,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: Text(
                    'Зберегти',
                    style: AppTextStyles.button.copyWith(color: AppColors.bg),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}