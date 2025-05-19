import 'contract_model.dart';

class SignatureModel {
  final int? id;
  final ContractModel? contract;
  final String? signerWalletAddress;
  final String? signatureData;
  final DateTime? signedAt;

  SignatureModel({
    this.id,
    this.contract,
    this.signerWalletAddress,
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
      signerWalletAddress: json['signerWalletAddress'] as String?,
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
      'signerWalletAddress': signerWalletAddress,
      'signatureData': signatureData,
      'signedAt': signedAt?.toIso8601String(),
    };
  }
}
