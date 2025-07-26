// 📁 lib/features/transaction/presentation/pages/transaction_page.dart
import 'package:alfa_dashboard/core/di/injection_container.dart';
import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
import 'package:alfa_dashboard/features/transaction/presentation/widgets/transaction_filter_search.dart';
import 'package:alfa_dashboard/features/transaction/presentation/widgets/transaction_error_widget.dart';
import 'package:alfa_dashboard/features/transaction/presentation/widgets/transactions_card.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionsPage extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const TransactionsPage({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => sl<TransactionCubit>()..fetchAllTransactions(),
        child: Scaffold(
          body: BlocBuilder<TransactionCubit, TransactionState>(
            builder: (context, state) {
              if (state is TransactionLoading) {
                return const Center(child: CircularProgressIndicator(color: AppConstants.clrBigText));
              } else if (state is TransactionError) {
                return TransactionErrorWidget(
                  message: state.message,
                  onRetry: () => context.read<TransactionCubit>().fetchTransactions(),
                );
              } else if (state is TransactionsLoaded) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Column(
                    children: [
                      const TransactionFilterSearch(),
                      const SizedBox(height: 20),
                      Expanded(child: TransactionsCard()),
                    ],
                  ),
                );
              }
              return const Center(child: Text(AppStrings.loading));
            },
          ),
        ),
      ),
    );

  }
}
