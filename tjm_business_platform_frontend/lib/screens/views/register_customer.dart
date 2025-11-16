import 'package:flutter/material.dart';

class RegisterCustomerView extends StatefulWidget {
  const RegisterCustomerView({super.key});

  @override
  State<RegisterCustomerView> createState() => _RegisterCustomerViewState();
}

class _RegisterCustomerViewState extends State<RegisterCustomerView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("RegisterCustomer view")
      ],
    );
  }
}