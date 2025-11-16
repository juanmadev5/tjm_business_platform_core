import 'package:flutter/material.dart';

class CustomersView extends StatefulWidget {
  const CustomersView({super.key});

  @override
  State<CustomersView> createState() => _CustomersViewState();
}

class _CustomersViewState extends State<CustomersView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Clients view")
      ],
    );
  }
}