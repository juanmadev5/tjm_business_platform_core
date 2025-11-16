import 'package:flutter/material.dart';
import 'package:tjm_business_platform/components/action_snackbar.dart';
import 'package:tjm_business_platform/components/author_date_header.dart';
import 'package:tjm_business_platform/components/details_field.dart';
import 'package:tjm_business_platform/components/name_field.dart';
import 'package:tjm_business_platform/components/price_field.dart';
import 'package:tjm_business_platform/components/save_action_button.dart';
import 'package:tjm_business_platform/core/strings.dart';
import 'package:tjm_business_platform/data/provider.dart';

class RegisterExpenseView extends StatefulWidget {
  const RegisterExpenseView({super.key});

  @override
  State<RegisterExpenseView> createState() => _RegisterExpenseViewState();
}

class _RegisterExpenseViewState extends State<RegisterExpenseView> {
  Provider provider = Provider();
  String productName = "";
  String details = "";
  String price = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        authorDateHeader(),
        SizedBox(
          width: 400,
          child: nameField(
            AppStrings.expenseName,
            (value) => {productName = value},
          ),
        ),
        SizedBox(height: 24),
        Expanded(
          child: detailsField(
            AppStrings.expenseDetail,
            (detail) => {details = detail},
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 300,
          child: priceField(
            AppStrings.cost,
            (priceFromField) => {price = priceFromField},
          ),
        ),
        SizedBox(height: 16),
        saveActionButton(
          context,
          AppStrings.saveExpense,
          (context) => {
            actionSnackbar(context!, trigger(), AppStrings.expenseSaved),
          },
        ),
      ],
    );
  }

  bool trigger() {
    return (productName.isNotEmpty && details.isNotEmpty && price.isNotEmpty);
  }
}
