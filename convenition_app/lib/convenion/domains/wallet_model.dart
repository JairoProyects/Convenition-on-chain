import 'user_model.dart';

class WalletModel {
  final int? walletId;
  final UserModel? user; // Reference to UserModel
  final String? address;
  final String? chain;
  final DateTime? addedAt;

  WalletModel({
    this.walletId,
    this.user,
    this.address,
    this.chain,
    this.addedAt,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      walletId: json['walletId'] as int?,
      user:
          json['user'] == null
              ? null
              : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      address: json['address'] as String?,
      chain: json['chain'] as String?,
      addedAt:
          json['addedAt'] == null
              ? null
              : DateTime.tryParse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'walletId': walletId,
      'user': user?.toJson(), // Call toJson on UserModel
      'address': address,
      'chain': chain,
      'addedAt': addedAt?.toIso8601String(),
    };
  }
}
