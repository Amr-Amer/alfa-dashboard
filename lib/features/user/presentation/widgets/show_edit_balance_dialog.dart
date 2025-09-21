import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/material.dart';

class ShowEditBalanceDialog extends StatefulWidget {
  final UserModel user;
  final Function() onBalanceChanged;

  const ShowEditBalanceDialog({super.key, required this.user, required this.onBalanceChanged});

  @override
  State<ShowEditBalanceDialog> createState() => _ShowEditBalanceDialogState();
}

class _ShowEditBalanceDialogState extends State<ShowEditBalanceDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.user.balance.toString());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _saveBalance() {
    final newBalance = double.tryParse(controller.text);
    if (newBalance != null) {
      // widget.user.balance = newBalance;
      widget.onBalanceChanged();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppStrings.amountNotValid)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppStrings.updateBalance),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: AppStrings.newBalance,
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: _saveBalance,
          child: Text(AppStrings.save),
        ),
      ],
    );
  }
}
