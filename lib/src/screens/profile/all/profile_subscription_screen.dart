import 'package:app_build_freelance/router/app_router.gr.dart';
import 'package:app_build_freelance/src/components/ui/Btn.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:app_build_freelance/src/utils/modal_utils.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileSubscriptionScreen extends StatefulWidget {
  const ProfileSubscriptionScreen({super.key});

  @override
  State<ProfileSubscriptionScreen> createState() =>
      _ProfileSubscriptionScreenState();
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
            Btn(
                theme: 'white',
                text: 'История платежей',
                onPressed: () => AutoRouter.of(context)
                    .push(const ProfileHistoryPriceRoute())),
            const SizedBox(height: 24),
            const Text(
              'Выберите подписку',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                    child: _buildSubscriptionOption(0, '1', '1 месяц', '99 ₽')),
                const SizedBox(
                  width: 16,
                ),
                Flexible(
                    child:
                        _buildSubscriptionOption(1, '3', '3 месяца', '199 ₽')),
                const SizedBox(
                  width: 16,
                ),
                Flexible(
                    child: _buildSubscriptionOption(
                        2, '12', '12 месяцев', '1 199 ₽')),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Выберите способ оплаты',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPaymentMethodOption(0, 'МИР/Visa/Mastercard'),
            Divider(
              height: .5,
              color: AppColors.light.withOpacity(0.4),
            ),
            _buildPaymentMethodOption(1, 'СБП'),
            const SizedBox(height: 24),
            Btn(text: 'Оплатить', theme: 'violet', onPressed: () => ()),
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
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
          top: BorderSide(
            width: 1,
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildSubscriptionOption(
      int index, String duration, String period, String price) {
    bool isSelected = _selectedSubscriptionIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSubscriptionIndex = index;
        });
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    offset: const Offset(0, 1),
                    blurRadius: 0,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected ? AppColors.violet : AppColors.yellow,
              ),
              child: Text(
                duration,
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
            ),
            Text(period),
            Container(
              alignment: Alignment.center,
              child: Text(
                price,
                style: const TextStyle(fontSize: 24),
              ),
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
        activeColor: AppColors.violet,
      ),
      onTap: () {
        setState(() {
          _selectedPaymentMethodIndex = index;
        });
      },
    );
  }

  void _showCancelSubscriptionBottomSheet(BuildContext context) {
    showCustomModalBottomSheet(
      context: context,
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
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Подписку можно возобновить в любое время, чтобы вы смогли продолжить пользоваться всеми функциями приложения',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Btn(
                  text: 'Оставить подписку',
                  theme: 'violet',
                  onPressed: () {
                    Navigator.of(context).pop(); // Закрыть нижний лист
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Btn(
                  text: 'Да, приостановить',
                  theme: 'white',
                  onPressed: () {
                    Navigator.of(context).pop(); // Закрыть нижний лист
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Btn(
                  text: 'Нет, всё равно отменить',
                  theme: 'white',
                  textColor: AppColors.red,
                  onPressed: () {
                    Navigator.of(context).pop(); // Закрыть нижний лист
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
