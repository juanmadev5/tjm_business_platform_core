import 'package:flutter/material.dart';
import 'package:tjm_business_platform/components/action_snackbar.dart';
import 'package:tjm_business_platform/components/author_date_header.dart';
import 'package:tjm_business_platform/components/details_field.dart';
import 'package:tjm_business_platform/components/name_field.dart';
import 'package:tjm_business_platform/components/price_field.dart';
import 'package:tjm_business_platform/components/save_action_button.dart';
import 'package:tjm_business_platform/core/strings.dart';
import 'package:tjm_business_platform/data/provider.dart';
import 'package:tjm_business_platform/screens/state/payment_state.dart';
import 'package:tjm_business_platform/screens/state/work_state.dart';

class CreateReportView extends StatefulWidget {
  const CreateReportView({super.key});

  @override
  State<CreateReportView> createState() => _CreateReportViewState();
}

class _CreateReportViewState extends State<CreateReportView> {
  Provider provider = Provider();
  String customerName = "";
  String details = "";
  String price = "";
  PaymentState payment = PaymentState.pending;
  WorkState work = WorkState.inProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        authorDateHeader(),
        SizedBox(
          width: 400,
          child: nameField(
            AppStrings.customerName,
            (value) => {customerName = value},
          ),
        ),
        SizedBox(height: 24),
        Expanded(
          child: detailsField(
            AppStrings.workDetails,
            (detail) => {details = detail},
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          width: 300,
          child: priceField(
            AppStrings.costOfWork,
            (priceFromField) => {price = priceFromField},
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(AppStrings.workState),
                SizedBox(height: 8),
                SegmentedButton(
                  showSelectedIcon: false,
                  segments: workStateSegments,
                  selected: <WorkState>{work},
                  onSelectionChanged: (Set<WorkState> selection) {
                    setState(() {
                      work = selection.first;
                    });
                  },
                ),
              ],
            ),
            SizedBox(width: 18),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(AppStrings.paymentState),
                SizedBox(height: 8),
                SegmentedButton(
                  showSelectedIcon: false,
                  segments: paymentStateSegments,
                  selected: <PaymentState>{payment},
                  onSelectionChanged: (Set<PaymentState> selection) {
                    setState(() {
                      payment = selection.first;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16),
        saveActionButton(
          context,
          AppStrings.saveReport,
          (context) => {
            actionSnackbar(
              context!,
              customerName.isNotEmpty && details.isNotEmpty && price.isNotEmpty,
              AppStrings.reportSaved,
            ),
          },
        ),
      ],
    );
  }

  List<ButtonSegment<PaymentState>> get paymentStateSegments {
    return <ButtonSegment<PaymentState>>[
      ButtonSegment(
        value: PaymentState.pending,
        label: Text(AppStrings.pending),
        icon: Icon(Icons.money_off),
      ),
      ButtonSegment(
        value: PaymentState.paid,
        label: Text(AppStrings.paid),
        icon: Icon(Icons.credit_score),
      ),
    ];
  }

  List<ButtonSegment<WorkState>> get workStateSegments {
    return <ButtonSegment<WorkState>>[
      ButtonSegment(
        value: WorkState.inProgress,
        label: Text(AppStrings.inProgress),
        icon: Icon(Icons.timelapse),
      ),
      ButtonSegment(
        value: WorkState.finished,
        label: Text(AppStrings.finished),
        icon: Icon(Icons.done_all),
      ),
    ];
  }
}
