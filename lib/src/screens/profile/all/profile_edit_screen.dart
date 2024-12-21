import 'dart:io';

import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:app_build_freelance/src/components/ui/Inputs.dart';
import 'package:app_build_freelance/src/components/ui/location_picker.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/provider/UserNotifier.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

@RoutePage()
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  // Контроллеры для ввода данных
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController aboutMySelfController = TextEditingController();

@override
void initState() {
  super.initState();
  // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   ref.read(userProvider.notifier).loadUser();
  // });
}
  Future<String?> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path; // Возвращаем путь к выбранному изображению
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final userNotifier = ref.read(userProvider.notifier);

    if (userState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userState.user == null) {
      return const Center(child: Text('Пользователь не найден'));
    }

    // Заполняем контроллеры значениями из состояния
    firstNameController.text = userState.user!.firstName ?? '';
    lastNameController.text = userState.user!.lastName ?? '';
    phoneController.text = userState.user!.phoneNumber ?? '';
    aboutMySelfController.text = userState.user!.aboutMySelf ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактирование'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Аватар
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.yellow,
                  backgroundImage: _getImageProvider(userState.user?.photo ?? ''),
                ),
                // Кнопка удаления
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      userNotifier.updateUser(
                        userState.user!.copyWith(photo: ''),
                      );
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // Кнопка редактирования
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      final updatedPhoto = await _pickImage();
                      if (updatedPhoto != null) {
                        userNotifier.updateUser(
                          userState.user!.copyWith(photo: updatedPhoto),
                        );
                      }
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: const Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Inputs(
              controller: firstNameController,
              backgroundColor: AppColors.ulight,
              textColor: Colors.black,
              label: 'Имя',
              required: true,
            ),
            const SizedBox(height: 16),
            Inputs(
              controller: lastNameController,
              backgroundColor: AppColors.ulight,
              textColor: Colors.black,
              label: 'Фамилия',
              required: true,
            ),
            const SizedBox(height: 16),
            Inputs(
              controller: phoneController,
              backgroundColor: AppColors.ulight,
              textColor: Colors.black,
              label: 'Телефон',
              fieldType: 'phone',
            ),
            const SizedBox(height: 16),
            Inputs(
              controller: aboutMySelfController,
              backgroundColor: AppColors.ulight,
              textColor: Colors.black,
              label: 'О себе',
              isMultiline: true,
            ),
            const SizedBox(height: 40),
            Btn(
              text: userState.isLoading ? 'Загрузка...' : 'Подтвердить',
              onPressed: () {
                userNotifier.updateUser(
                  userState.user!.copyWith(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    phoneNumber: phoneController.text,
                    aboutMySelf: aboutMySelfController.text,
                  ),
                );
              },
              theme: 'violet',
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _getImageProvider(String imageUrl) {
    if (imageUrl.isEmpty) {
      return const AssetImage('assets/images/splash.png');
    }
    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    } else if (imageUrl.startsWith('/')) {
      return FileImage(File(imageUrl));
    } else {
      return AssetImage(imageUrl);
    }
  }
}