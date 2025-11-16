import 'package:flutter/material.dart';
import 'package:tjm_business_platform/core/app_colors.dart';
import 'package:tjm_business_platform/data/provider.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  Provider provider = Provider();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text(
          provider.getTodayDateFormatted(),
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: card(
                "Ganancias de la semana",
                "Gs. 1.570.000",
                valueColor: Colors.green,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: card(
                "Pérdidas en el mes",
                "Gs. 100.000",
                valueColor: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: card("Trabajos realizados en el mes", "6")),
            SizedBox(width: 16),
            Expanded(
              child: card(
                "Ganancia neta",
                "Gs. 1.470.000",
                valueColor: Colors.green,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: card("Trabajos pendientes", "0")),
            SizedBox(width: 16),
            Expanded(
              child: card(
                "Clientes nuevos este mes",
                "3",
                valueColor: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  DecoratedBox card(
    String title,
    String value, {
    Color valueColor = Colors.white,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.seedColor.onSecondary,
      ),
      child: SizedBox(
        width: 320,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: valueColor,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
