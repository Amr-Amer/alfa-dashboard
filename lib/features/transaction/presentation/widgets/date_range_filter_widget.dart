import 'package:alfa_dashboard/features/transaction/presentation/manager/transaction_cubit.dart';
import 'package:alfa_dashboard/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


class DateRangeFilterWidget extends StatefulWidget {
  const DateRangeFilterWidget({super.key});

  @override
  State<DateRangeFilterWidget> createState() => _DateRangeFilterWidgetState();
}

class _DateRangeFilterWidgetState extends State<DateRangeFilterWidget> {
  DateTime? _fromDate;
  DateTime? _toDate;

  final DateFormat _formatter = DateFormat('yyyy-MM-dd');

  Future<void> _selectFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  void _search() {
    if (_fromDate != null && _toDate != null) {
      BlocProvider.of<TransactionCubit>(context).filterByDateRange(_fromDate!, _toDate!);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار تاريخ البداية والنهاية')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 5,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.clrBoxBackground,
                  foregroundColor: AppConstants.clrSmallText,
              ),
              onPressed: _selectFromDate,
              child: Text(_fromDate == null ? 'من تاريخ' : 'من: ${_formatter.format(_fromDate!)}'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.clrBoxBackground,
                foregroundColor: AppConstants.clrSmallText,
              ),
              onPressed: _selectToDate,
              child: Text(_toDate == null ? 'إلى تاريخ' : 'إلى: ${_formatter.format(_toDate!)}'),
            ),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.clrWhite,
            foregroundColor: AppConstants.clrPrimary,
          ),
          onPressed: _search,
          child: const Text('بحث'),
        ),
      ],
    );
  }
}
