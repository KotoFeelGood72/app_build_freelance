import 'package:app_build_freelance/src/components/ui/info_row.dart';
import 'package:app_build_freelance/src/constants/app_colors.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileHistoryPriceScreen extends StatelessWidget {
  const ProfileHistoryPriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('История платежей'),),
      body: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: 1,
              color: AppColors.border
            )
          )
        ),
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            InfoRow(label: '1 199 ₽', value: '12.10.24', hasBottomBorder: true, ),
            InfoRow(label: '1 199 ₽', value: '12.10.24', hasBottomBorder: true,),
            InfoRow(label: '1 199 ₽', value: '12.10.24', hasBottomBorder: true,),
          ],
        ),
      ),
    );
  }
}