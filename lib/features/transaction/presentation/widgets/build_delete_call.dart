import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BuildDeleteCall extends StatelessWidget {
  final String transactionId;
  final int flex;
  const BuildDeleteCall({super.key, required this.transactionId, required this.flex});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is TransactionDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is TransactionDeleteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is TransactionDeleting && state.transactionId == transactionId;

        return Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                 await context.read<TransactionCubit>().deleteTransaction(transactionId);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
