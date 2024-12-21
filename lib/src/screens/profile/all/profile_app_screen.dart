import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileAppScreen extends StatelessWidget {
  const ProfileAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: const [
                  Text(
                    'Версия: 0.00.0',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Напишите нам'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Логика для перехода
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Рейтинг'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Логика для перехода
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Очистить кэш'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Логика для очистки кэша
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Правила сервиса'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Логика для перехода
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Политика конфиденциальности'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Логика для перехода
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  const Text(
                    'Наши соцсети',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          // Логика для VK
                        },
                        iconSize: 40,
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.telegram),
                        onPressed: () {
                          // Логика для Telegram
                        },
                        iconSize: 40,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Логика для удаления аккаунта
                    },
                    child: const Text(
                      'Удалить аккаунт',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
