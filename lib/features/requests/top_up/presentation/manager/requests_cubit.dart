import 'dart:async';
import 'package:alfa_dashboard/core/services/global/global_fun.dart';
import 'package:alfa_dashboard/core/services/notifications/notification_service.dart';
import 'package:alfa_dashboard/features/notifications/domain/usecases/send_notification_usecase.dart';
import 'package:alfa_dashboard/features/requests/top_up/domain/usecases/get_topup_usecase.dart';
import 'package:alfa_dashboard/features/requests/top_up/presentation/manager/requests_state.dart';
import 'package:alfa_dashboard/features/transaction/domain/enums/transaction_status.dart';
import 'package:alfa_dashboard/features/user/presentation/manager/user_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestsCubit extends Cubit<RequestsState> {
  final UserCubit userCubit;
  final SendNotificationUseCase sendNotificationUseCase;
  final NotificationService notificationService;
   final GetTopUpStreamUseCase getTopUpStreamUseCase;

  RequestsCubit(
     this.userCubit,
     this.notificationService,
     this.sendNotificationUseCase,
     this.getTopUpStreamUseCase,
  ): super(RequestsInitial());

  String selectedStatus = 'all';

  StreamSubscription? _topUpStreamSubscription;


  Future<void> getTupUpStream() async {
    emit(TopUpsLoading());
    _topUpStreamSubscription?.cancel();
    _topUpStreamSubscription = getTopUpStreamUseCase().listen(
          (either) {
        either.fold(
              (failure) => emit(TopUpsError(failure.message)),
              (result) {
                topUpList = result;
            emit(TopUpsLoaded(topUps));
            if (kDebugMode) {
              print("withdrawRequests data.................... ${withdrawRequests.length}");
            }
          },
        );
      },
    );
  }



  void searchWithdrawRequests(String query) {
    if (query.isNotEmpty) {
      final filteredTransactions = withdrawRequests.where((transaction) {
        return transaction.id.toString().contains(query);
      }).toList();
      emit(RequestsLoaded(filteredTransactions));
    } else {
      emit(RequestsLoaded(withdrawRequests));
    }
  }

  void filterByStatus(String status) {
    selectedStatus = status;

    if (status == 'all') {
      emit(RequestsLoaded(withdrawRequests));
    } else {
      final filtered = withdrawRequests
          .where((transaction) =>
      transaction.status.name.toLowerCase() == status.toLowerCase())
          .toList();
      emit(RequestsLoaded(filtered));
    }
  }
}
