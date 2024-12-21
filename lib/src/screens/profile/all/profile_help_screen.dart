import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileHelpScreen extends StatelessWidget {
  const ProfileHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Помощь'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  ExpansionTile(
                    title: const Text('Вопрос?'),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Вот вам яркий пример современных тенденций — базовый вектор развития влечет за собой процесс внедрения и модернизации новых принципов формирования материально-технической и кадровой базы.',
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  ExpansionTile(
                    title: const Text('Вопрос?'),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Ответ на второй вопрос...',
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  ExpansionTile(
                    title: const Text('Вопрос?'),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Ответ на третий вопрос...',
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  ExpansionTile(
                    title: const Text('Вопрос?'),
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Ответ на четвертый вопрос...',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  const Text('Остались вопросы? Напишите в поддержку'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Добавьте логику для отправки сообщения в поддержку
                    },
                    child: const Text('Написать'),
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
