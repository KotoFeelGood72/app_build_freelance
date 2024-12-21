import 'package:app_build_freelance/src/components/ui/info_row.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileStarsScreen extends StatelessWidget {
  const ProfileStarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Рейтинг')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InfoRow(label: 'Рейтинг', value: 'Супер (Топ-10)'),
            InfoRow(
              label: 'Выполнено',
              value: '1000 заданий',
              hasBottomBorder: true,
              hasTopBorder: true,
            ),
            InfoRow(
              label: 'Заработано',
              value: '10 000 ₽',
              hasBottomBorder: true,
            ),
            const SizedBox(height: 24),
            // Круговая диаграмма прогресса
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: 0.7, // 70% прогресса
                      strokeWidth: 8,
                      color: Colors.purple,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '10 000 ₽',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      Text(
                        '70% потрачено',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Оценка
            const Text(
              'Оценка',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  '+ 999',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
                SizedBox(width: 16),
                Text(
                  '- 9',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Отзывы
            const Text(
              'Отзывы',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Пример отзыва
            ReviewCard(
              username: 'Александр',
              date: '29.10.2024',
              comment:
                  'В своём стремлении повысить качество жизни, они забывают, что экономическая повестка сегодняшнего дня обеспечивает широкий круг (специалистов) участие в формировании переосмысления внешнеэкономических политик.',
              isPositive: true,
            ),
            ReviewCard(
              username: 'Александр',
              date: '29.10.2024',
              comment:
                  'Текст отзыва, который будет отображаться в карточке...',
              isPositive: false,
            ),
            // Добавьте другие отзывы по аналогии
          ],
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String username;
  final String date;
  final String comment;
  final bool isPositive;

  const ReviewCard({
    Key? key,
    required this.username,
    required this.date,
    required this.comment,
    this.isPositive = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.yellow,
                  radius: 20,
                  child: const Icon(Icons.person),
                ),
                const SizedBox(width: 8),
                Text(
                  username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  date,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.add : Icons.remove,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    comment,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
