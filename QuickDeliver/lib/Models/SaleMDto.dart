class SaleMDto {
  int saleMId = 0;
  DateTime docDate = DateTime.now();
  String docNo = "";
  DateTime docTime = DateTime.now();
  int branchId = 0;
  int userId = 0;
  int customerId = 0;
  int payModeId = 0;
  double discountAmount = 0;
  double promoDiscountAmount = 0;

  double roundOffAmount = 0;
  double otherCharges = 0;
  List<SaleTDto> transList = [];
  List<SalePaymodeDbDto> payModeList = [];
  int gstTypeId = 0;
  String gstNumber = '';

  String walkInCustomerMobileNo = '';
  String walkInCustomerName = '';

  // for external use

  String customerName = '';
  String customerPincode = '';
  String contactNo = '';
  String customerAddress = '';
  String placeOfSupplyName = '';
  String placeOfSupplyCode = '';
  String gstTypeName = '';
  int queueno = 0;
  int accountLedgerId = 0;

  double billMrpAmount = 0;
  double billBaseSalePriceAmount = 0;
  double billNetSalePriceAmount = 0;
  double billItemDiscountAmount = 0;
  double billFinalPayableAmount = 0;
  double billTaxAmount = 0;

  String inWords = '';
  String paymentQrCode = '';

  SaleMDto();

  SaleMDto.fromJson(Map<String, dynamic> json) {
    saleMId = json['saleMId'];
    docDate = DateTime.parse(json['docDate']);
    docNo = json['docNo'];
    docTime = DateTime.parse(json['docTime']);
    branchId = json['branchId'];
    userId = json['userId'];
    customerId = json['customerId'];
    payModeId = json['payModeId'];
    discountAmount = double.parse(json['discountAmount'].toString());
    promoDiscountAmount = double.parse(json['promoDiscountAmount'].toString());
    roundOffAmount = double.parse(json['roundOffAmount'].toString());
    otherCharges = double.parse(json['otherCharges'].toString());
    gstTypeId = json['gstTypeId'];
    gstNumber = json['gstNumber'];
    customerName = json['customerName'];
    contactNo = json['contactNo'];
    walkInCustomerMobileNo = json['walkInCustomerMobileNo'];
    walkInCustomerName = json['walkInCustomerName'];
    if (json['customerAddress'] != null) {
      customerAddress = json['customerAddress'];
    }

    if (json['customerPincode'] != null) {
      customerPincode = json['customerPincode'];
    }
    if (json['gstTypeName'] != null) {
      gstTypeName = json['gstTypeName'];
    }

    if (json['placeOfSupplyCode'] != null) {
      placeOfSupplyCode = json['placeOfSupplyCode'];
    }
    if (json['placeOfSupplyName'] != null) {
      placeOfSupplyName = json['placeOfSupplyName'];
    }

    if (json['transList'] != null) {
      transList = <SaleTDto>[];
      json['transList'].forEach((v) {
        transList.add(SaleTDto.fromJson(v));
      });
    }
    if (json['payModeList'] != null) {
      payModeList = <SalePaymodeDbDto>[];
      json['payModeList'].forEach((v) {
        payModeList.add(SalePaymodeDbDto.fromJson(v));
      });
    }
    if (json['queueno'] != null) {
      queueno = json['queueno'];
    }

    if (json['billMrpAmount'] != null) {
      billMrpAmount = double.parse(json['billMrpAmount'].toString());
    }
    if (json['billBaseSalePriceAmount'] != null) {
      billBaseSalePriceAmount =
          double.parse(json['billBaseSalePriceAmount'].toString());
    }
    if (json['billNetSalePriceAmount'] != null) {
      billNetSalePriceAmount =
          double.parse(json['billNetSalePriceAmount'].toString());
    }

    if (json['billItemDiscountAmount'] != null) {
      billItemDiscountAmount =
          double.parse(json['billItemDiscountAmount'].toString());
    }
    if (json['billFinalPayableAmount'] != null) {
      billFinalPayableAmount =
          double.parse(json['billFinalPayableAmount'].toString());
    }
    if (json['billTaxAmount'] != null) {
      billTaxAmount = double.parse(json['billTaxAmount'].toString());
    }

    if (json['inWords'] != null) {
      inWords = json['inWords'];
    }

    if (json['paymentQrCode'] != null) {
      paymentQrCode = json['paymentQrCode'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saleMId'] = saleMId;
    data['docDate'] = docDate.toIso8601String();
    data['docNo'] = docNo;
    data['docTime'] = docTime.toIso8601String();
    data['branchId'] = branchId;
    data['userId'] = userId;
    data['customerId'] = customerId;
    data['payModeId'] = payModeId;
    data['discountAmount'] = discountAmount;
    data['promoDiscountAmount'] = promoDiscountAmount;
    data['roundOffAmount'] = roundOffAmount;
    data['otherCharges'] = otherCharges;
    data['transList'] = transList.map((v) => v.toJson()).toList();
    data['payModeList'] = payModeList.map((v) => v.toJson()).toList();
    data['gstTypeId'] = gstTypeId;
    data['gstNumber'] = gstNumber;
    data['customerName'] = customerName;
    data['contactNo'] = contactNo;
    data['customerAddress'] = customerAddress;
    data['customerPincode'] = customerPincode;
    data['placeOfSupplyCode'] = placeOfSupplyCode;
    data['placeOfSupplyName'] = placeOfSupplyName;
    data['walkInCustomerMobileNo'] = walkInCustomerMobileNo;
    data['walkInCustomerName'] = walkInCustomerName;
    data['queueno'] = queueno;

    data['billMrpAmount'] = billMrpAmount;
    data['billBaseSalePriceAmount'] = billBaseSalePriceAmount;
    data['billNetSalePriceAmount'] = billNetSalePriceAmount;

    data['billItemDiscountAmount'] = billItemDiscountAmount;
    data['billFinalPayableAmount'] = billFinalPayableAmount;
    data['billTaxAmount'] = billTaxAmount;
    data['inWords'] = inWords;
    data['paymentQrCode'] = paymentQrCode;

    return data;
  }
}

class SaleTDto {
  int saleTId = 0;
  int saleMId = 0;
  int serialNo = 0;
  int productId = 0;
  int productCcuId = 0;
  int productUcuId = 0;
  int productRcuId = 0;
  int metalId = 0;
  double quantity = 0;
  double mrp = 0;
  double baseSalePrice = 0;
  double lineDiscAmount = 0;
  double sharedDiscAmount = 0;
  double linePromoDiscAmount = 0;
//  double sharedPromoDiscAmount = 0;
  double eachSharedDiscAmount = 0;
  double eachSharedPromoDiscAmount = 0;
  double sharedPromoDiscAmount = 0;

  double finalSalePrice = 0;
  double eachTaxableAmount = 0;
  double eachTaxAmount = 0;
  double eachFinalAmount = 0;
  int outputTaxId = 0;
  double outputTaxPerc = 0;
  String taxType = '';
  double taxableAmount = 0;
  double taxAmount = 0;
  double finalAmount = 0;
  double markCommAmount = 0;
  double commAmount = 0;
  double metalRate = 0;
  int salesManId = 0;
  int appliedPromotionMId = 0;
  String appliedPromotionName = '';
  double appliedQuantity = 0;
  double promobeforeQuantity = 0;

  int appliedBillPromotionMId = 0;
  String appliedBillPromotionName = '';

  String productName = "";
  String fullName = "";
  String metalName = "";
  String taxName = "";
  String salesManName = "";

  String productCode = '';
  String productCcuCode = '';
  String productUcuCode = '';
  String barcodeno = '';
  int taxTemplateMId = 0;

  double cgstAmount = 0;
  double sgstAmount = 0;
  double igstAmount = 0;
  double cgstRate = 0;
  double sgstRate = 0;
  double igstRate = 0;

// Additional for display

  String hsnCode = '';

  String attValue1 = "";
  String attValue2 = "";
  String attValue3 = "";
  String attValue4 = "";
  String attValue5 = "";
  String attValue6 = "";
  String attValue7 = "";
  String attValue8 = "";
  String attValue9 = "";
  String attValue10 = "";

  int att1 = 0;
  int att2 = 0;
  int att3 = 0;
  int att4 = 0;
  int att5 = 0;
  int att6 = 0;
  int att7 = 0;
  int att8 = 0;
  int att9 = 0;
  int att10 = 0;

// additional for internal use

  bool isProcessing = false;
  int itemPromotionMId = 0;
  bool isAddedFromPromotion = false;
  String salesManCode = '';
  double commissionPerc = 0;
  bool isOpenRate = false;
  int quantityDecimalNo = 0;
  String taxTemplateName = '';
  String languageName = '';
  String productImageUrl = '';

  double markAmount = 0;
  String markCode = '';
  bool isMarkAmountFixed = false;
  double markPerc = 0;

  double grossSalePrice = 0;
  double billPromoApplicableAmount = 0;

  bool isChecked = false;

  //LockedtagDbDto? lockedtagDbDto;

// for sale return purpose not using in sales
  double returnQuantity = 0;
  double balanceQuantity = 0;

  SaleTDto();

  SaleTDto.fromJson(Map<String, dynamic> json) {
    saleTId = json['saleTId'];
    saleMId = json['saleMId'];
    serialNo = json['serialNo'];
    productId = json['productId'];
    productCcuId = json['productCcuId'];
    productUcuId = json['productUcuId'];
    productRcuId = json['productRcuId'];
    metalId = json['metalId'];
    quantity = double.parse(json['quantity'].toString());
    mrp = double.parse(json['mrp'].toString());
    baseSalePrice = double.parse(json['baseSalePrice'].toString());
    grossSalePrice = double.parse(json['baseSalePrice'].toString());
    lineDiscAmount = double.parse(json['lineDiscAmount'].toString());
    linePromoDiscAmount = double.parse(json['linePromoDiscAmount'].toString());
    sharedDiscAmount = double.parse(json['sharedDiscAmount'].toString());
    // sharedPromoDiscAmount =
    //   double.parse(json['sharedPromoDiscAmount'].toString());
    eachSharedDiscAmount =
        double.parse(json['eachSharedDiscAmount'].toString());
    eachSharedPromoDiscAmount =
        double.parse(json['eachSharedPromoDiscAmount'].toString());
    sharedPromoDiscAmount =
        double.parse(json['sharedPromoDiscAmount'].toString());
    finalSalePrice = double.parse(json['finalSalePrice'].toString());
    eachTaxableAmount = double.parse(json['eachTaxableAmount'].toString());
    eachTaxAmount = double.parse(json['eachTaxAmount'].toString());
    eachFinalAmount = double.parse(json['eachFinalAmount'].toString());
    outputTaxId = json['outputTaxId'];
    outputTaxPerc = double.parse(json['outputTaxPerc'].toString());
    taxType = json['taxType'];
    taxableAmount = double.parse(json['taxableAmount'].toString());
    taxAmount = double.parse(json['taxAmount'].toString());
    finalAmount = double.parse(json['finalAmount'].toString());
    markCommAmount = double.parse(json['markCommAmount'].toString());
    commAmount = double.parse(json['commAmount'].toString());
    metalRate = double.parse(json['metalRate'].toString());
    salesManId = json['salesManId'];
    salesManName = json['salesManName'];
    taxName = json['taxName'];
    productName = json['productName'];
    fullName = json['fullName'];
    metalName = json['metalName'];
    appliedPromotionMId = json['appliedPromotionMId'];

    if (json['returnQuantity'] != null) {
      returnQuantity = double.parse(json['returnQuantity'].toString());
    }

    balanceQuantity = quantity - returnQuantity;

    if (json['cgstAmount'] != null) {
      cgstAmount = double.parse(json['cgstAmount'].toString());
    }

    if (json['sgstAmount'] != null) {
      sgstAmount = double.parse(json['sgstAmount'].toString());
    }

    if (json['igstAmount'] != null) {
      igstAmount = double.parse(json['igstAmount'].toString());
    }

    if (json['cgstRate'] != null) {
      cgstRate = double.parse(json['cgstRate'].toString());
    }

    if (json['sgstRate'] != null) {
      sgstRate = double.parse(json['sgstRate'].toString());
    }

    if (json['igstRate'] != null) {
      igstRate = double.parse(json['igstRate'].toString());
    }

    if (json['taxTemplateMId'] != null) {
      taxTemplateMId = json['taxTemplateMId'];
    }

    if (json['appliedBillPromotionMId'] != null) {
      appliedBillPromotionMId = json['appliedBillPromotionMId'];
    }

    if (json['appliedBillPromotionName'] != null) {
      appliedBillPromotionName = json['appliedBillPromotionName'];
    }
    // attributes for only external use
    if (json['attValue1'] != null) {
      attValue1 = json['attValue1'];
    }

    if (json['attValue2'] != null) {
      attValue2 = json['attValue2'];
    }

    if (json['attValue3'] != null) {
      attValue3 = json['attValue3'];
    }
    if (json['attValue4'] != null) {
      attValue4 = json['attValue4'];
    }

    if (json['attValue5'] != null) {
      attValue5 = json['attValue5'];
    }

    if (json['attValue6'] != null) {
      attValue6 = json['attValue6'];
    }

    if (json['attValue7'] != null) {
      attValue7 = json['attValue7'];
    }

    if (json['attValue8'] != null) {
      attValue8 = json['attValue8'];
    }

    if (json['attValue9'] != null) {
      attValue9 = json['attValue9'];
    }

    if (json['attValue10'] != null) {
      attValue10 = json['attValue10'];
    }

    if (json['att1'] != null) {
      att1 = json['att1'];
    }

    if (json['att2'] != null) {
      att2 = json['att2'];
    }

    if (json['att3'] != null) {
      att3 = json['att3'];
    }
    if (json['att4'] != null) {
      att4 = json['att4'];
    }

    if (json['att5'] != null) {
      att5 = json['att5'];
    }

    if (json['att6'] != null) {
      att6 = json['att6'];
    }

    if (json['att7'] != null) {
      att7 = json['att7'];
    }

    if (json['att8'] != null) {
      att8 = json['att8'];
    }

    if (json['att9'] != null) {
      att9 = json['att9'];
    }

    if (json['att10'] != null) {
      att10 = json['att10'];
    }

    // attributes end

    if (json['hsnCode'] != null) {
      hsnCode = json['hsnCode'];
    }

    if (json['productCode'] != null) {
      productCode = json['productCode'];
    }

    if (json['salesManCode'] != null) {
      salesManCode = json['salesManCode'];
    }

    if (json['productCcuCode'] != null) {
      productCcuCode = json['productCcuCode'];
    }

    if (json['productUcuCode'] != null) {
      productUcuCode = json['productUcuCode'];
    }

    if (json['appliedPromotionName'] != null) {
      appliedPromotionName = json['appliedPromotionName'];
    }
    if (json['promobeforeQuantity'] != null) {
      promobeforeQuantity = json['promobeforeQuantity'];
    }
    if (json['isAddedFromPromotion'] != null) {
      isAddedFromPromotion = json['isAddedFromPromotion'];
    }
    if (json['appliedQuantity'] != null) {
      appliedQuantity = json['appliedQuantity'];
    }

    if (json['itemPromotionMId'] != null) {
      itemPromotionMId = json['itemPromotionMId'];
    }

    if (json['barcodeno'] != null) {
      barcodeno = json['barcodeno'];
    }
    if (json['isProcessing'] != null) {
      isProcessing = json['isProcessing'];
    }

    if (json['isOpenRate'] != null) {
      isOpenRate = json['isOpenRate'];
    }

    if (json['quantityDecimalNo'] != null) {
      quantityDecimalNo = json['quantityDecimalNo'];
    }

    if (json['taxTemplateName'] != null) {
      taxTemplateName = json['taxTemplateName'];
    }

    if (json['languageName'] != null) {
      languageName = json['languageName'];
    }

    if (json['productImageUrl'] != null) {
      productImageUrl = json['productImageUrl'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['saleTId'] = saleTId;
    data['saleMId'] = saleMId;
    data['serialNo'] = serialNo;
    data['productId'] = productId;
    data['productCcuId'] = productCcuId;
    data['productUcuId'] = productUcuId;
    data['productRcuId'] = productRcuId;
    data['metalId'] = metalId;
    data['quantity'] = quantity;
    data['mrp'] = mrp;
    data['baseSalePrice'] = baseSalePrice;
    data['lineDiscAmount'] = lineDiscAmount;
    data['linePromoDiscAmount'] = linePromoDiscAmount;
    //  data['sharedPromoDiscAmount'] = sharedPromoDiscAmount;
    data['sharedDiscAmount'] = sharedDiscAmount;
    data['eachSharedPromoDiscAmount'] = eachSharedPromoDiscAmount;
    data['sharedPromoDiscAmount'] = sharedPromoDiscAmount;

    data['eachSharedDiscAmount'] = eachSharedDiscAmount;
    data['finalSalePrice'] = finalSalePrice;
    data['eachTaxableAmount'] = eachTaxableAmount;
    data['eachTaxAmount'] = eachTaxAmount;
    data['eachFinalAmount'] = eachFinalAmount;
    data['outputTaxId'] = outputTaxId;
    data['outputTaxPerc'] = outputTaxPerc;
    data['taxableAmount'] = taxableAmount;
    data['taxAmount'] = taxAmount;
    data['finalAmount'] = finalAmount;
    data['markCommAmount'] = markCommAmount;
    data['commAmount'] = commAmount;
    data['metalRate'] = metalRate;
    data['salesManId'] = salesManId;
    data['productName'] = productName;
    data['fullName'] = fullName;
    data['taxName'] = taxName;
    data['taxTemplateMId'] = taxTemplateMId;
    data['salesManName'] = salesManName;
    data['appliedPromotionMId'] = appliedPromotionMId;
    data['appliedPromotionName'] = appliedPromotionName;
    data['appliedBillPromotionMId'] = appliedBillPromotionMId;
    data['appliedBillPromotionName'] = appliedBillPromotionName;
    data['appliedQuantity'] = appliedQuantity;
    data['promobeforeQuantity'] = promobeforeQuantity;
    data['metalName'] = metalName;
    data['productCode'] = productCode;
    data['salesManCode'] = salesManCode;
    data['productCcuCode'] = productCcuCode;
    data['productUcuCode'] = productUcuCode;
    data[barcodeno] = barcodeno;
    //  data['isAdded'] = isAdded;
    data['isAddedFromPromotion'] = isAddedFromPromotion;
    data['barcodeno'] = barcodeno;
    data['itemPromotionMId'] = itemPromotionMId;
    data['isProcessing'] = isProcessing;
    data['isOpenRate'] = isOpenRate;
    data['quantityDecimalNo'] = quantityDecimalNo;
    data['taxTemplateName'] = taxTemplateName;
    data['taxType'] = taxType;

    data['cgstAmount'] = cgstAmount;
    data['sgstAmount'] = sgstAmount;
    data['igstAmount'] = igstAmount;
    data['cgstRate'] = cgstRate;
    data['sgstRate'] = sgstRate;
    data['igstRate'] = igstRate;

// for sale return not using in sales

    data['returnQuantity'] = returnQuantity;
    data['balanceQuantity'] = balanceQuantity;

    // attribues for external use

    data['hsnCode'] = hsnCode;
    data['attValue1'] = attValue1;
    data['attValue2'] = attValue2;
    data['attValue3'] = attValue3;
    data['attValue4'] = attValue4;
    data['attValue5'] = attValue5;
    data['attValue6'] = attValue6;
    data['attValue7'] = attValue7;
    data['attValue8'] = attValue8;
    data['attValue9'] = attValue9;
    data['attValue10'] = attValue10;

    data['att1'] = att1;
    data['att2'] = att2;
    data['att3'] = att3;
    data['att4'] = att4;
    data['att5'] = att5;
    data['att6'] = att6;
    data['att7'] = att7;
    data['att8'] = att8;
    data['att9'] = att9;
    data['att10'] = att10;
    data['languageName'] = languageName;
    data['productImageUrl'] = productImageUrl;
    //
    return data;
  }
}

class SalePaymodeDbDto {
  int salePayModeId = 0;
  int saleMId = 0;
  int payModeId = 0;
  double amount = 0;
  String payModeName = '';
  String imageUrl = '';

  SalePaymodeDbDto();

  SalePaymodeDbDto.fromJson(Map<String, dynamic> json) {
    salePayModeId = json['salePayModeId'];
    saleMId = json['saleMId'];
    payModeId = json['payModeId'];
    amount = double.parse(json['amount'].toString());
    payModeName = json['payModeName'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['salePayModeId'] = salePayModeId;
    data['saleMId'] = saleMId;
    data['payModeId'] = payModeId;
    data['amount'] = amount;
    data['payModeName'] = payModeName;
    data['imageUrl'] = imageUrl;
    return data;
  }
}

class SaleGstSplitDto {
  String hsnCode = '';
  String taxName = '';
  double taxableAmount = 0;
  double cgstAmount = 0;
  double sgstAmount = 0;
  double igstAmount = 0;
  double taxAmount = 0;

  SaleGstSplitDto.fromJson(Map<String, dynamic> json) {
    hsnCode = json['hsnCode'];
    taxName = json['taxName'];
    taxableAmount = double.parse(json['taxableAmount'].toString());
    cgstAmount = double.parse(json['cgstAmount'].toString());
    sgstAmount = double.parse(json['sgstAmount']);
    igstAmount = double.parse(json['igstAmount']);
    taxAmount = double.parse(json['taxAmount']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hsnCode'] = hsnCode;
    data['taxName'] = taxName;
    data['taxableAmount'] = taxableAmount;
    data['cgstAmount'] = cgstAmount;
    data['sgstAmount'] = sgstAmount;
    data['igstAmount'] = igstAmount;
    data['taxAmount'] = taxAmount;
    return data;
  }
}
