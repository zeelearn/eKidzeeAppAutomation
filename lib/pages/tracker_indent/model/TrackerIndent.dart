// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

class TrackerIndent {
  Root? root;

  String? error;

  TrackerIndent.setErrorMessage(String errorMessage) {
    error = errorMessage;
  }

  TrackerIndent({this.root});

  TrackerIndent.fromJson(Map<String, dynamic> json) {
    root = json['root'] != null ? Root.fromJson(json['root']) : null;
  }
}

class Root {
  Subroot? subroot;

  Root({this.subroot});

  Root.fromJson(Map<String, dynamic> json) {
    subroot =
        json['subroot'] != null ? Subroot.fromJson(json['subroot']) : null;
  }
}

class Subroot {
  List<IndentType>? indentType;
  List<IndentStatus>? indentStatus;
  List<AcademicYear>? academicYear;
  List<Indents>? indents;

  Subroot({this.academicYear, this.indents});

  Subroot.fromJson(Map<String, dynamic> json) {
    if (json['Indent_Status'] != null) {
      indentStatus = <IndentStatus>[];
      json['Indent_Status'].forEach((v) {
        indentStatus!.add(IndentStatus.fromJson(v));
      });
    } else {
      indentStatus = [];
    }
    if (json['IndentType'] != null) {
      indentType = <IndentType>[];
      json['IndentType'].forEach((v) {
        indentType!.add(IndentType.fromJson(v));
      });
    } else {
      indentType = [];
    }
    if (json['AcademicYear'] != null) {
      academicYear = <AcademicYear>[];
      if (json['AcademicYear'] is List) {
        json['AcademicYear'].forEach((v) {
          academicYear!.add(AcademicYear.fromJson(v));
        });
      } else {
        academicYear!.add(AcademicYear.fromJson(json['AcademicYear']));
      }
    } else {
      academicYear = [];
    }

    if (json['Indents'] != null) {
      if (json['Indents'] is List) {
        indents = [];
        json['Indents'].forEach((v) {
          log('Indent value is - $v');
          indents!.add(Indents.fromJson(v));
        });
      } else {
        indents = [];
        indents!.add(Indents.fromJson(json['Indents']));
      }
    } else {
      indents = [];
    }
  }
}

class IndentStatus {
  String? indentStatus;
  IndentStatus(this.indentStatus);

  IndentStatus.fromJson(Map<String, dynamic> json) {
    indentStatus = json['Indent_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Indent_status'] = indentStatus;
    return data;
  }
}

class IndentType {
  String? indentType;
  String? indentDescription;

  IndentType({this.indentType, this.indentDescription});

  IndentType.fromJson(Map<String, dynamic> json) {
    indentType = json['Indent_Type'];
    indentDescription = json['Indent_Description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Indent_Type'] = indentType;
    data['Indent_Description'] = indentDescription;
    return data;
  }
}

class AcademicYear {
  String? academicYearId;
  String? academicYearName;

  AcademicYear({this.academicYearId, this.academicYearName});

  AcademicYear.fromJson(Map<String, dynamic> json) {
    academicYearId = json['AcademicYear_Id'];
    academicYearName = json['AcademicYear_Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AcademicYear_Id'] = academicYearId;
    data['AcademicYear_Name'] = academicYearName;
    return data;
  }

  @override
  bool operator ==(covariant AcademicYear other) {
    if (identical(this, other)) return true;

    return other.academicYearId == academicYearId &&
        other.academicYearName == academicYearName;
  }

  @override
  int get hashCode => academicYearId.hashCode ^ academicYearName.hashCode;
}

class Indents {
  String? error;
  String? franchiseeId;
  String? indentId;
  String? indentDescription;
  String? indentType;
  String? indentNo;
  String? indentDate;
  String? indentAmount;
  String? isActive;
  String? indentStatus;
  String? hOClearedDate;
  String? tierName;
  String? feeType;
  String? franchiseeType;
  String? franchiseeCode;
  String? franchiseeName;
  List<Products>? products;
  List<Invoices>? invoices;

  Indents.setErrorMessage(String errorMessage) {
    error = errorMessage;
  }

  Indents(
      {this.franchiseeId,
      this.indentId,
      this.indentDescription,
      this.indentType,
      this.indentNo,
      this.indentDate,
      this.indentAmount,
      this.isActive,
      this.indentStatus,
      this.hOClearedDate,
      this.tierName,
      this.feeType,
      this.franchiseeType,
      this.franchiseeCode,
      this.franchiseeName,
      this.products,
      this.invoices});

  Indents.fromJson(Map<String, dynamic> json) {
    franchiseeId = json['Franchisee_Id'];
    indentId = json['Indent_Id'];
    indentDescription = json['Indent_Description'];
    indentType = json['Indent_Type'];
    indentNo = json['Indent_No'];
    indentDate = json['Indent_Date'];
    indentAmount = json['Indent_Amount'];
    isActive = json['Is_Active'];
    indentStatus = json['Indent_Status'];
    hOClearedDate = json['HOClearedDate'];
    tierName = json['Tier_Name'];
    feeType = json['Fee_Type'];
    franchiseeType = json['franchisee_type'];
    franchiseeCode = json['Franchisee_Code'];
    franchiseeName = json['Franchisee_Name'];

    if (json['Products'] != null) {
      products = [];
      if (json['Products'] is List) {
        json['Products'].forEach((v) {
          products!.add(Products.fromJson(v));
        });
      } else {
        products!.add(Products.fromJson(json['Products']));
      }
    } else {
      products = [];
    }
    // products =
    //     json['Products'] != null ? Products.fromJson(json['Products']) : null;
    if (json['Invoices'] != null) {
      invoices = <Invoices>[];
      if (json['Invoices'] is List) {
        json['Invoices'].forEach((v) {
          invoices!.add(Invoices.fromJson(v));
        });
      } else {
        invoices!.add(Invoices.fromJson(json['Invoices']));
      }
    } else {
      invoices = [];
    }
  }
}

class Products {
  String? productCode;
  String? productName;
  String? quantity;
  List<ProductDtls>? productDtls;

  Products(
      {this.productCode, this.productName, this.quantity, this.productDtls});

  Products.fromJson(Map<String, dynamic> json) {
    productCode = json['Product_Code'];
    productName = json['Product_Name'];
    quantity = json['Quantity'];

    if (json['ProductDtls'] != null) {
      productDtls = [];
      if (json['ProductDtls'] is List) {
        json['ProductDtls'].forEach((v) {
          productDtls!.add(ProductDtls.fromJson(v));
        });
      } else {
        productDtls!.add(ProductDtls.fromJson(json['ProductDtls']));
      }
    } else {
      productDtls = [];
    }
  }
}

class ProductDtls {
  String? productId;
  String? bomCode;
  String? productName;
  String? qty;
  String? status;
  String? productImg;

  ProductDtls(
      {this.productId,
      this.bomCode,
      this.productName,
      this.qty,
      this.status,
      this.productImg});

  ProductDtls.fromJson(Map<String, dynamic> json) {
    productId = json['Product_Id'];
    bomCode = json['Bom_code'];
    productName = json['Product_name'];
    qty = json['Qty'];
    status = json['Status'];
    productImg = json['ProductUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Product_Id'] = productId;
    data['Bom_code'] = bomCode;
    data['Product_name'] = productName;
    data['Qty'] = qty;
    data['Status'] = status;
    data['ProductUrl'] = productImg;
    return data;
  }
}

class Invoices {
  String? invoiceno;
  String? provider;
  String? docketNo;
  String? status;
  List<Invoicedetails>? invoicedetails;
  List<LogisticStatus>? logisticStatus;

  Invoices(
      {this.invoiceno,
      this.provider,
      this.docketNo,
      this.status,
      this.invoicedetails,
      this.logisticStatus});

  Invoices.fromJson(Map<String, dynamic> json) {
    invoiceno = json['invoiceno'];
    provider = json['Provider'];
    docketNo = json['docketno'];
    status = json['status'];
    if (json['invoicedetails'] != null) {
      invoicedetails = <Invoicedetails>[];
      if (json['invoicedetails'] is List) {
        json['invoicedetails'].forEach((v) {
          invoicedetails!.add(Invoicedetails.fromJson(v));
        });
      } else {
        invoicedetails!.add(Invoicedetails.fromJson(json['invoicedetails']));
      }
    } else {
      invoicedetails = [];
    }

    if (json['LogisticStatus'] != null) {
      logisticStatus = [];
      if (json['LogisticStatus'] is List) {
        json['LogisticStatus'].forEach((v) {
          logisticStatus!.add(LogisticStatus.fromJson(v));
        });
      } else {
        logisticStatus!.add(LogisticStatus.fromJson(json['LogisticStatus']));
      }
    } else {
      logisticStatus = [];
    }
  }
}

class Invoicedetails {
  String? bomCode;
  String? description;
  String? qty;
  String? productImg;

  Invoicedetails({this.bomCode, this.description, this.qty});

  Invoicedetails.fromJson(Map<String, dynamic> json) {
    bomCode = json['bom_code'];
    description = json['description'];
    qty = json['qty'];
    productImg = json['ProductUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['bom_code'] = bomCode;
    data['description'] = description;
    data['qty'] = qty;
    data['ProductUrl'] = productImg;
    return data;
  }
}

class LogisticStatus {
  String? provider;
  String? docketno;
  String? docketDate;
  String? invoiceno;
  String? milestoneReason;
  String? milestoneStatus;
  String? milestoneDateTime;

  LogisticStatus(
      {this.provider,
      this.docketno,
      this.docketDate,
      this.invoiceno,
      this.milestoneReason,
      this.milestoneStatus,
      this.milestoneDateTime});

  LogisticStatus.fromJson(Map<String, dynamic> json) {
    provider = json['Provider'];
    docketno = json['Docketno'];
    docketDate = json['docket_date'];
    invoiceno = json['invoiceno'];
    milestoneReason = json['Milestone_Reason'];
    milestoneStatus = json['Milestone_Status'];
    milestoneDateTime = json['Milestone_DateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Provider'] = provider;
    data['Docketno'] = docketno;
    data['docket_date'] = docketDate;
    data['invoiceno'] = invoiceno;
    data['Milestone_Reason'] = milestoneReason;
    data['Milestone_Status'] = milestoneStatus;
    data['Milestone_DateTime'] = milestoneDateTime;
    return data;
  }
}
