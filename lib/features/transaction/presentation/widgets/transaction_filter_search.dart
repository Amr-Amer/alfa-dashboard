import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
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
          flex: 4,
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
                value: context.read<TransactionCubit>().selectedStatus,
                hint: const Text(
                  AppStrings.status,
                  style: TextStyle(color: AppConstants.clrSmallText),
                ),
                icon: const Icon(Icons.filter_list, size: 20),
                borderRadius: BorderRadius.circular(12),
                dropdownColor: AppConstants.clrBoxBackground,
                style: TextStyle(
                  color: AppConstants.clrSmallText,),
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('الكل')),
                  DropdownMenuItem(value: 'completed', child: Text('ناجحة')),
                  DropdownMenuItem(value: 'pending', child: Text('قيد المعالجة')),
                  DropdownMenuItem(value: 'failed', child: Text('مرفوضة')),
                  DropdownMenuItem(value: 'canceled', child: Text('ملغية')),
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
      ],
    );
  }
}
