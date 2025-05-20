import 'user_model.dart'; // Corrected import path

enum ContractStatus {
  created,
  signedByOne,
  completed,
  expired,
  unknown; // Added for deserialization robustness

  static ContractStatus fromString(String? statusString) {
    if (statusString == null) return ContractStatus.unknown;
    try {
      return ContractStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == statusString.toLowerCase(),
      );
    } catch (e) {
      return ContractStatus.unknown;
    }
  }

  String toJson() => name;
}

class ContractModel {
  final int? contractId;
  final UserModel? creator;
  final String? onchainAddress;
  final String? classHash;
  final String? title;
  final String? contentHash;
  final DateTime? expirationDate;
  final ContractStatus? status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ContractModel({
    this.contractId,
    this.creator,
    this.onchainAddress,
    this.classHash,
    this.title,
    this.contentHash,
    this.expirationDate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      contractId: json['contractId'] as int?,
      creator:
          json['creator'] == null
              ? null
              : UserModel.fromJson(json['creator'] as Map<String, dynamic>),
      onchainAddress: json['onchainAddress'] as String?,
      classHash: json['classHash'] as String?,
      title: json['title'] as String?,
      contentHash: json['contentHash'] as String?,
      expirationDate:
          json['expirationDate'] == null
              ? null
              : DateTime.tryParse(json['expirationDate'] as String),
      status:
          json['status'] == null
              ? null
              : ContractStatus.fromString(json['status'] as String?),
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.tryParse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.tryParse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contractId': contractId,
      'creator': creator?.toJson(),
      'onchainAddress': onchainAddress,
      'classHash': classHash,
      'title': title,
      'contentHash': contentHash,
      'expirationDate': expirationDate?.toIso8601String(),
      'status': status?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
