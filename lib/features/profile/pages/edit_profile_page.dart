import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final lastNameController = TextEditingController(text: 'Ковальчук');
  final firstNameController = TextEditingController(text: 'Олена');
  final patronymicController = TextEditingController();
  final phoneController = TextEditingController(text: '+380 93 327 04 00');

  @override
  void dispose() {
    lastNameController.dispose();
    firstNameController.dispose();
    patronymicController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void save() {
    // TODO: відправити дані на бекенд
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
        title: Text('Особисті дані', style: AppTextStyles.h3),
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
                  AppTextField(
                    label: 'Прізвище',
                    controller: lastNameController,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Імʼя',
                    controller: firstNameController,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'По батькові',
                    controller: patronymicController,
                    hint: 'Необовʼязково',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    label: 'Номер телефону',
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),
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