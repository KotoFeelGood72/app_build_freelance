import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileSubscriptionScreen extends StatefulWidget {
  const ProfileSubscriptionScreen({super.key});

  @override
  State<ProfileSubscriptionScreen> createState() => _ProfileSubscriptionScreenState();
}

class _ProfileSubscriptionScreenState extends State<ProfileSubscriptionScreen> {
  // Индексы выбранных подписки и способа оплаты
  int _selectedSubscriptionIndex = 1; // 0: 1 месяц, 1: 3 месяца, 2: 12 месяцев
  int _selectedPaymentMethodIndex = 0; // 0: МИР/Visa/Mastercard, 1: СБП

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Подписка'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoRow('Истечёт через', '3 месяца'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Логика перехода к истории платежей
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                elevation: 0,
              ),
              child: InkWell(
                onTap: () {
                  AutoRouter.of(context).push(ProfileHistoryPriceRoute());
                },
                child: const Text(
                  'История платежей',
                  style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Выберите подписку',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSubscriptionOption(0, '1', '1 месяц', '99 ₽'),
                _buildSubscriptionOption(1, '3', '3 месяца', '199 ₽'),
                _buildSubscriptionOption(2, '12', '12 месяцев', '1 199 ₽'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Выберите способ оплаты',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPaymentMethodOption(0, 'МИР/Visa/Mastercard'),
            _buildPaymentMethodOption(1, 'СБП'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Логика для оплаты
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Оплатить',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                _showCancelSubscriptionBottomSheet(context);
              },
              child: const Text(
                'Отменить подписку',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }

  Widget _buildSubscriptionOption(int index, String duration, String period, String price) {
    bool isSelected = _selectedSubscriptionIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSubscriptionIndex = index;
        });
      },
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple[100] : Colors.yellow[100],
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: Colors.purple, width: 2) : null,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(
              duration,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.purple : Colors.orange,
              ),
            ),
            Text(period),
            Text(
              price,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(int index, String method) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(method),
      trailing: Radio<int>(
        value: index,
        groupValue: _selectedPaymentMethodIndex,
        onChanged: (value) {
          setState(() {
            _selectedPaymentMethodIndex = value!;
          });
        },
        activeColor: Colors.purple,
      ),
      onTap: () {
        setState(() {
          _selectedPaymentMethodIndex = index;
        });
      },
    );
  }

  void _showCancelSubscriptionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Приостановить подписку?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Подписку можно возобновить в любое время, чтобы вы смогли продолжить пользоваться всеми функциями приложения',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Закрыть нижний лист
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Оставить подписку',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  // Логика для приостановки подписки
                  Navigator.of(context).pop(); // Закрыть нижний лист
                },
                child: const Text(
                  'Да, приостановить',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Закрыть нижний лист
                },
                child: const Text(
                  'Нет, всё равно отменить',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
