import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
import 'package:alfa_dashboard/features/transaction/presentation/widgets/date_range_filter_widget.dart';
import 'package:alfa_dashboard/features/transaction/presentation/widgets/trnas_search_widget.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionFilterSearch extends StatelessWidget {
  const TransactionFilterSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TrnasSearchWidget(),
        ),
        const SizedBox(width: 12),

        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppConstants.clrBoxBackground,
              boxShadow: const [
                BoxShadow(color: Color(0xFF333333), spreadRadius: 1)
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: context.watch<TransactionCubit>().selectedStatus == 'all'
                    ? null
                    : context.read<TransactionCubit>().selectedStatus,
                hint: const Text(
                  AppStrings.transactionStatus,
                  style: TextStyle(color: AppConstants.clrSmallText),
                ),
                icon: const Icon(Icons.filter_list, size: 20),
                borderRadius: BorderRadius.circular(12),
                dropdownColor: AppConstants.clrBoxBackground,
                style: TextStyle(
                  color: AppConstants.clrSmallText,),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text(AppStrings.all)),
                  DropdownMenuItem(value: 'completed', child: Text(AppStrings.completed)),
                  DropdownMenuItem(value: 'pending', child: Text(AppStrings.pending)),
                  DropdownMenuItem(value: 'failed', child: Text(AppStrings.failed)),
                  DropdownMenuItem(value: 'canceled', child: Text(AppStrings.cancelled)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context.read<TransactionCubit>().filterByStatus(value);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppConstants.clrBoxBackground,
              boxShadow: const [
                BoxShadow(color: Color(0xFF333333), spreadRadius: 1)
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: context.watch<TransactionCubit>().selectedType == 'all'
                    ? null
                    : context.read<TransactionCubit>().selectedType,

                hint: const Text(AppStrings.transactionType,
                  style: TextStyle(color: AppConstants.clrSmallText),
                ),
                icon: const Icon(Icons.filter_list, size: 20),
                borderRadius: BorderRadius.circular(12),
                dropdownColor: AppConstants.clrBoxBackground,
                style: TextStyle(
                  color: AppConstants.clrSmallText,),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text(AppStrings.all)),
                  DropdownMenuItem(value: 'deposit', child: Text(AppStrings.deposit)),
                  DropdownMenuItem(value: 'withdraw', child: Text(AppStrings.withdraw)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context.read<TransactionCubit>().filterByType(value);
                  }
                },
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppConstants.clrBoxBackground,
              boxShadow: const [
                BoxShadow(color: Color(0xFF333333), spreadRadius: 1)
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: context.watch<TransactionCubit>().selectedMethod == 'all'
                    ? null
                    : context.read<TransactionCubit>().selectedMethod,

                hint: const Text(AppStrings.transactionMethod,
                  style: TextStyle(color: AppConstants.clrSmallText),
                ),
                icon: const Icon(Icons.filter_list, size: 20),
                borderRadius: BorderRadius.circular(12),
                dropdownColor: AppConstants.clrBoxBackground,
                style: TextStyle(
                  color: AppConstants.clrSmallText,),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text(AppStrings.all)),
                  DropdownMenuItem(value: 'visa', child: Text(AppStrings.visa)),
                  DropdownMenuItem(value: 'wallet', child: Text(AppStrings.wallet)),
                ],
                onChanged: (value) {
                  if (value != null) {
                    context.read<TransactionCubit>().filterByMethod(value);
                  }
                },
              ),
            ),
          ),
        ),

        SizedBox(width: 50),

        DateRangeFilterWidget()
      ],
    );
  }
}
