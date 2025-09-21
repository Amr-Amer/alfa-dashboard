import 'package:alfa_dashboard/features/user/data/models/user_model.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:flutter/material.dart';

class AddNotificationDialog extends StatefulWidget {
  final List<UserModel> users;
  const AddNotificationDialog({super.key, required this.users});

  @override
  State<AddNotificationDialog> createState() => _AddNotificationDialogState();
}

class _AddNotificationDialogState extends State<AddNotificationDialog> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController(text: AppStrings.notificationTitle);
  final bodyController = TextEditingController();
  final amountController = TextEditingController();

  UserModel? selectedUser;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.addNewNotification),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: AppStrings.title),
              onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
            ),
            TextFormField(
              controller: bodyController,
              decoration: InputDecoration(labelText: AppStrings.body),
            ),

            TextFormField(
              controller: amountController,
              decoration: InputDecoration(labelText: AppStrings.amount),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? AppStrings.required : null,
            ),

          ],

        ),
      ),
      actions: [
        DropdownButtonFormField<UserModel>(
          decoration: InputDecoration(labelText: AppStrings.selectUser),
          value: selectedUser,
          items: widget.users.map((user) {
            return DropdownMenuItem<UserModel>(
              value: user,
              child: Text(user.displayName),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedUser = value;
            });
          },
          validator: (value) => value == null ? AppStrings.required : null,
        ),

        Row(
          children: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.cancel),
            ),
          ],
        ),

        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate() && selectedUser != null) {
              // final amount = double.tryParse(amountController.text) ?? 0;
              // final newBalance = selectedUser!.balance + amount;
              // final currency = selectedUser!.currency ?? 'EGP';

              // final defaultBody =
              //     'تم إضافة ${amount.toStringAsFixed(2)} $currency إلى رصيدك. الرصيد الحالي: ${newBalance.toStringAsFixed(2)} $currency';

              // final newNotification = NotificationModel(
              //   id: GlobalFun.generateId(),
              //   title: titleController.text.trim(),
              //   body: bodyController.text.trim().isEmpty ? defaultBody : bodyController.text.trim(),
              //   createdAt: DateTime.now(),
              //   read: false,
              //   uid: selectedUser!.uid,
              //   type: TransactionType.deposit,
              //   status: TransactionStatus.pending.name,
              //   data: {
              //     FirebaseConstants.amount: amount,
              //     FirebaseConstants.currency: currency,
              //   },
              //   name: selectedUser!.displayName,
              // );

              // await context.read<NotificationCubit>().createNotification(newNotification);
              // Navigator.pop(context);
            }
          },
          child: Text(AppStrings.add),
        ),
      ],
    );
  }
}
