import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileNoteScreen extends StatefulWidget {
  const ProfileNoteScreen({super.key});

  @override
  _ProfileNoteScreenState createState() => _ProfileNoteScreenState();
}

class _ProfileNoteScreenState extends State<ProfileNoteScreen> {
  bool isCandidateEnabled = true;
  bool isCityTaskEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Уведомления'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('В списке кандидатов'),
              value: isCandidateEnabled,
              onChanged: (bool value) {
                setState(() {
                  isCandidateEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text(
                'Задание в моём городе',
                style: TextStyle(color: Colors.grey),
              ),
              value: isCityTaskEnabled,
              onChanged: (bool value) {
                setState(() {
                  isCityTaskEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Включите push-уведомления, чтобы узнавать о новых событиях',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  // Логика для настройки уведомлений
                },
                child: const Text(
                  'Настроить уведомления',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
