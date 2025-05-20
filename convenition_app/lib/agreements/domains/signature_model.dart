import 'contract_model.dart';
import 'user_model.dart';
import 'wallet_model.dart';

class SignatureModel {
  final int? id;
  final ContractModel? contract;
  final WalletModel? wallet;
  final UserModel? user;
  final String? signatureData;
  final DateTime? signedAt;

  SignatureModel({
    this.id,
    this.contract,
    this.wallet,
    this.user,
    this.signatureData,
    this.signedAt,
  });

  factory SignatureModel.fromJson(Map<String, dynamic> json) {
    return SignatureModel(
      id: json['id'] as int?,
      contract:
          json['contract'] == null
              ? null
              : ContractModel.fromJson(
                json['contract'] as Map<String, dynamic>,
              ),
      wallet:
          json['wallet'] == null
              ? null
              : WalletModel.fromJson(json['wallet'] as Map<String, dynamic>),
      user:
          json['user'] == null
              ? null
              : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      signatureData: json['signatureData'] as String?,
      signedAt:
          json['signedAt'] == null
              ? null
              : DateTime.tryParse(json['signedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contract': contract?.toJson(),
      'wallet': wallet?.toJson(),
      'user': user?.toJson(),
      'signatureData': signatureData,
      'signedAt': signedAt?.toIso8601String(),
    };
  }
}
