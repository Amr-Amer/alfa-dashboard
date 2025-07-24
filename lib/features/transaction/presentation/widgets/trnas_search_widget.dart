import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
import 'package:alfa_dashboard/utils/app_strings.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrnasSearchWidget extends StatelessWidget {
  const TrnasSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is TransactionLoading) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
                Radius.circular(20)),
            color: AppConstants.clrBoxBackground,
            boxShadow: [
              BoxShadow(color: Color(0xFF333333),
                  spreadRadius: 1)
            ]),
        child: TextField(
          style: TextStyle(color: AppConstants.clrBigText),
          decoration: InputDecoration(
              filled: false,
              enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.transparent)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                      color: AppConstants.clrBoxBackground)),
              contentPadding: EdgeInsets.symmetric(
                  vertical: 5),
              hintText: AppStrings.search,
              hintStyle: TextStyle(
                  color: AppConstants.clrSmallText,
                  fontSize: 14),
              prefixIcon: Icon(
                Icons.search,
                color: AppConstants.clrSmallText,
                size: 20,
              )),
          onChanged: (query) {
            context.read<TransactionCubit>().searchTransactions(query);
          },
        ),
      ),
    );
  }
}
