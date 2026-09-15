// ignore_for_file: public_member_api_docs, sort_constructors_first
class LedgerResponse {
  List<LedgerModel> data = [];

  LedgerResponse({required this.data});

  LedgerResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <LedgerModel>[];
      json['data'].forEach((v) {
        data.add(LedgerModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }

  @override
  String toString() => 'LedgerResponse(data: $data)';
}

class LedgerModel {
  String? transType;
  double? transId;
  String? transDAte;
  String? transDesc;
  double? transAmount;
  String? indentStatus;
  int? isTransferAllowed;
  double? oldRoyaltyOpeningBalance;
  double? oldRoyaltyClosingBalance;
  double? openingBalance;
  double? totalIndent;
  double? totalReceipt;
  double? closingBalance;
  double? totalClosingBalance;

  LedgerModel(
      {this.transType,
      this.transId,
      this.transDAte,
      this.transDesc,
      this.transAmount,
      this.indentStatus,
      this.isTransferAllowed,
      this.oldRoyaltyOpeningBalance,
      this.oldRoyaltyClosingBalance,
      this.openingBalance,
      this.totalIndent,
      this.totalReceipt,
      this.closingBalance,
      this.totalClosingBalance});

  LedgerModel.fromJson(Map<String, dynamic> json) {
    transType = json['Trans_Type'];
    transId = json['Trans_Id'];
    transDAte = json['Trans_DAte'];
    transDesc = json['Trans_Desc'];
    transAmount = json['Trans_Amount'];
    indentStatus = json['Indent_Status'];
    isTransferAllowed = json['Is_Transfer_Allowed'];
    oldRoyaltyOpeningBalance = json['old_Royalty_Opening_Balance'];
    oldRoyaltyClosingBalance = json['old_Royalty_Closing_Balance'];
    openingBalance = json['opening_Balance'];
    totalIndent = json['total_Indent'];
    totalReceipt = json['total_Receipt'];
    closingBalance = json['closing_Balance'];
    totalClosingBalance = json['total_Closing_Balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Trans_Type'] = transType;
    data['Trans_Id'] = transId;
    data['Trans_DAte'] = transDAte;
    data['Trans_Desc'] = transDesc;
    data['Trans_Amount'] = transAmount;
    data['Indent_Status'] = indentStatus;
    data['Is_Transfer_Allowed'] = isTransferAllowed;
    data['old_Royalty_Opening_Balance'] = oldRoyaltyOpeningBalance;
    data['old_Royalty_Closing_Balance'] = oldRoyaltyClosingBalance;
    data['opening_Balance'] = openingBalance;
    data['total_Indent'] = totalIndent;
    data['total_Receipt'] = totalReceipt;
    data['closing_Balance'] = closingBalance;
    data['total_Closing_Balance'] = totalClosingBalance;
    return data;
  }

  @override
  String toString() {
    return 'LedgerModel(transType: $transType, transId: $transId, transDAte: $transDAte, transDesc: $transDesc, transAmount: $transAmount, indentStatus: $indentStatus, isTransferAllowed: $isTransferAllowed, oldRoyaltyOpeningBalance: $oldRoyaltyOpeningBalance, oldRoyaltyClosingBalance: $oldRoyaltyClosingBalance, openingBalance: $openingBalance, totalIndent: $totalIndent, totalReceipt: $totalReceipt, closingBalance: $closingBalance, totalClosingBalance: $totalClosingBalance)';
  }
}
