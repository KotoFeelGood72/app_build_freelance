import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class TaskDetailCustomerScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О задании'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Название задания до 40 символов',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'В своём стремлении повысить качество жизни, они забывают, что экономическая повестка сегодняшнего дня обеспечивает широкому кругу (специалистов) участие в формировании переосмысления внешнеэкономических политик.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Стоимость', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('1000 ₽', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Срок выполнения', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('4 ч'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Размещено', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('20 сентября в 20:40'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('Статус', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Поиск исполнителя'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.purple,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Заказчик', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // Логика для перехода на детали заказчика
                        },
                        child: const Text(
                          'Подробнее',
                          style: TextStyle(color: Colors.purple),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () {
                  // Логика для жалобы
                },
                child: const Text(
                  'Пожаловаться',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Btn(text: 'Отказаться', theme: 'white', onPressed: () {}),
                Btn(text: 'Согласиться', onPressed: () {})
              ],
            ),
          ],
        ),
      ),
    );
  }
}
