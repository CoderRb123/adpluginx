/// id : 1
/// phoneId : "HelloWorld"
/// email : "devloperrb73375@gmail.com"
/// appleIdCode : ""
/// purchaseId : "Dsa kjaskj"
/// productId : "RehanAbbas"
/// appPackage : "com.app.apple"
/// appVersion : ""
/// status : "purcahsed"
/// itemValue : "200"
/// created_at : "2023-04-02T08:07:54.000000Z"
/// updated_at : "2023-04-02T08:07:54.000000Z"

class InAppPurchaseModel {
  InAppPurchaseModel({
      num? id, 
      String? phoneId, 
      String? email, 
      String? appleIdCode, 
      String? purchaseId, 
      String? productId, 
      String? appPackage, 
      String? appVersion, 
      String? status, 
      String? itemValue, 
      String? createdAt, 
      String? updatedAt,}){
    _id = id;
    _phoneId = phoneId;
    _email = email;
    _appleIdCode = appleIdCode;
    _purchaseId = purchaseId;
    _productId = productId;
    _appPackage = appPackage;
    _appVersion = appVersion;
    _status = status;
    _itemValue = itemValue;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  InAppPurchaseModel.fromJson(dynamic json) {
    _id = json['id'];
    _phoneId = json['phoneId'];
    _email = json['email'];
    _appleIdCode = json['appleIdCode'];
    _purchaseId = json['purchaseId'];
    _productId = json['productId'];
    _appPackage = json['appPackage'];
    _appVersion = json['appVersion'];
    _status = json['status'];
    _itemValue = json['itemValue'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  String? _phoneId;
  String? _email;
  String? _appleIdCode;
  String? _purchaseId;
  String? _productId;
  String? _appPackage;
  String? _appVersion;
  String? _status;
  String? _itemValue;
  String? _createdAt;
  String? _updatedAt;
InAppPurchaseModel copyWith({  num? id,
  String? phoneId,
  String? email,
  String? appleIdCode,
  String? purchaseId,
  String? productId,
  String? appPackage,
  String? appVersion,
  String? status,
  String? itemValue,
  String? createdAt,
  String? updatedAt,
}) => InAppPurchaseModel(  id: id ?? _id,
  phoneId: phoneId ?? _phoneId,
  email: email ?? _email,
  appleIdCode: appleIdCode ?? _appleIdCode,
  purchaseId: purchaseId ?? _purchaseId,
  productId: productId ?? _productId,
  appPackage: appPackage ?? _appPackage,
  appVersion: appVersion ?? _appVersion,
  status: status ?? _status,
  itemValue: itemValue ?? _itemValue,
  createdAt: createdAt ?? _createdAt,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  String? get phoneId => _phoneId;
  String? get email => _email;
  String? get appleIdCode => _appleIdCode;
  String? get purchaseId => _purchaseId;
  String? get productId => _productId;
  String? get appPackage => _appPackage;
  String? get appVersion => _appVersion;
  String? get status => _status;
  String? get itemValue => _itemValue;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['phoneId'] = _phoneId;
    map['email'] = _email;
    map['appleIdCode'] = _appleIdCode;
    map['purchaseId'] = _purchaseId;
    map['productId'] = _productId;
    map['appPackage'] = _appPackage;
    map['appVersion'] = _appVersion;
    map['status'] = _status;
    map['itemValue'] = _itemValue;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }

}