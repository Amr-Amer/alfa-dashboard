import 'package:alfa_dashboard/utils/app_strings.dart';

enum TransferChannel {
  bank,
  instapay,
  walletVodafone,
  walletOrange,
  walletEtisalat,
  walletWE,
}

extension TransferChannelExt on TransferChannel {
  String get name => toString().split('.').last;

  String get displayName {
    switch (this) {
      case TransferChannel.bank:
        return AppStrings.bank;
      case TransferChannel.instapay:
        return AppStrings.instaPay;
      case TransferChannel.walletVodafone:
        return AppStrings.vodafoneCash;
      case TransferChannel.walletOrange:
        return AppStrings.orangeCash;
      case TransferChannel.walletEtisalat:
        return AppStrings.etisalatCash;
      case TransferChannel.walletWE:
        return AppStrings.wePay;
    }
  }

  String get channelValue {
    switch (this) {
      case TransferChannel.bank:
        return 'bank';
      case TransferChannel.instapay:
        return 'instapay';
      case TransferChannel.walletVodafone:
        return 'wallet:vodafone';
      case TransferChannel.walletOrange:
        return 'wallet:orange';
      case TransferChannel.walletEtisalat:
        return 'wallet:etisalat';
      case TransferChannel.walletWE:
        return 'wallet:we';
    }
  }

  static TransferChannel fromString(String value) {
    return TransferChannel.values.firstWhere(
      (e) => e.channelValue == value,
      orElse: () => TransferChannel.bank,
    );
  }
}
