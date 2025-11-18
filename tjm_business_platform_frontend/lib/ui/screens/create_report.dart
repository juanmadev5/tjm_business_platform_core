import 'package:flutter/material.dart';
import 'package:tjm_business_platform/ui/utils/formatted_date.dart';
import 'package:tjm_business_platform_logic/core/model/platform_user.dart';

class CreateReport extends StatefulWidget {
  final PlatformUser? user;
  const CreateReport({super.key, required this.user});

  @override
  State<CreateReport> createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  @override
  Widget build(BuildContext context) {
    var user = widget.user!;

    return Scaffold(
      appBar: AppBar(title: Text("Crear reporte")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text("Autor: ${user.name} ${user.lastName}"),
              Text("Fecha: ${formattedDate()}"),
            ],
          ),
        ),
      ),
    );
  }
}
