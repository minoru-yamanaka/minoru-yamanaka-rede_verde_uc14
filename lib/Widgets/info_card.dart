import 'package:atalaia_ar_condicionados_flutter_application/Config/app_text_style.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String text;

  const InfoCard({super.key, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyle.titleStyle,
            ),
            SizedBox(height: 12),
            Text(
              "A recomendação geral é realizar a higienização completa pelo menos uma vez por ano. Em ambientes com alto fluxo de pessoas, o ideal é a cada 6 meses.",
              style: AppTextStyle.contentStyle,
            ),
          ],
        ),
      ),
    );
  }
}
