import 'package:starknet/starknet.dart';

class FunctionCall {
  final Felt contractAddress;
  final String entrypoint;
  final List<Felt> calldata;

  const FunctionCall({
    required this.contractAddress,
    required this.entrypoint,
    required this.calldata,
  });

  Map<String, dynamic> toJson() {
    return {
      'contractAddress': contractAddress.toHexString(),
      'entrypoint': entrypoint,
      'calldata': calldata.map((f) => f.toHexString()).toList(),
    };
  }
}
