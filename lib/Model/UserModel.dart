/// id : 4
/// phoneId : "HelloWorld"
/// email : "devloperrb73375@gmail.com"
/// appleIdCode : "112kn2j1knjnsj"
/// oneSignalId : ""
/// appPackage : "com.app.apple"
/// appVersion : ""
/// userCountry : ""
/// networkData : ""
/// vpnCountry : ""
/// appTrans : 0
/// coins : "12"
/// deviceData : ""
/// adLoaded : "0"
/// adFailed : "0"
/// adWatched : "0"
/// adClicked : "0"
/// created_at : "2023-04-02T06:42:11.000000Z"
/// updated_at : "2023-04-02T06:49:58.000000Z"

class UserModel {
  UserModel({
    num? id,
    String? phoneId,
    String? email,
    String? appleIdCode,
    String? oneSignalId,
    String? appPackage,
    String? appVersion,
    String? userCountry,
    String? networkData,
    String? vpnCountry,
    num? appTrans,
    String? coins,
    String? deviceData,
    String? adLoaded,
    String? adFailed,
    String? adWatched,
    String? adClicked,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _phoneId = phoneId;
    _email = email;
    _appleIdCode = appleIdCode;
    _oneSignalId = oneSignalId;
    _appPackage = appPackage;
    _appVersion = appVersion;
    _userCountry = userCountry;
    _networkData = networkData;
    _vpnCountry = vpnCountry;
    _appTrans = appTrans;
    _coins = coins;
    _deviceData = deviceData;
    _adLoaded = adLoaded;
    _adFailed = adFailed;
    _adWatched = adWatched;
    _adClicked = adClicked;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  UserModel.fromJson(dynamic json) {
    _id = json['id'];
    _phoneId = json['phoneId'];
    _email = json['email'];
    _appleIdCode = json['appleIdCode'];
    _oneSignalId = json['oneSignalId'];
    _appPackage = json['appPackage'];
    _appVersion = json['appVersion'];
    _userCountry = json['userCountry'];
    _networkData = json['networkData'];
    _vpnCountry = json['vpnCountry'];
    _appTrans = json['appTrans'];
    _coins = json['coins'];
    _deviceData = json['deviceData'];
    _adLoaded = json['adLoaded'];
    _adFailed = json['adFailed'];
    _adWatched = json['adWatched'];
    _adClicked = json['adClicked'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  num? _id;
  String? _phoneId;
  String? _email;
  String? _appleIdCode;
  String? _oneSignalId;
  String? _appPackage;
  String? _appVersion;
  String? _userCountry;
  String? _networkData;
  String? _vpnCountry;
  num? _appTrans;
  String? _coins;
  String? _deviceData;
  String? _adLoaded;
  String? _adFailed;
  String? _adWatched;
  String? _adClicked;
  String? _createdAt;
  String? _updatedAt;

  UserModel copyWith({
    num? id,
    String? phoneId,
    String? email,
    String? appleIdCode,
    String? oneSignalId,
    String? appPackage,
    String? appVersion,
    String? userCountry,
    String? networkData,
    String? vpnCountry,
    num? appTrans,
    String? coins,
    String? deviceData,
    String? adLoaded,
    String? adFailed,
    String? adWatched,
    String? adClicked,
    String? createdAt,
    String? updatedAt,
  }) =>
      UserModel(
        id: id ?? _id,
        phoneId: phoneId ?? _phoneId,
        email: email ?? _email,
        appleIdCode: appleIdCode ?? _appleIdCode,
        oneSignalId: oneSignalId ?? _oneSignalId,
        appPackage: appPackage ?? _appPackage,
        appVersion: appVersion ?? _appVersion,
        userCountry: userCountry ?? _userCountry,
        networkData: networkData ?? _networkData,
        vpnCountry: vpnCountry ?? _vpnCountry,
        appTrans: appTrans ?? _appTrans,
        coins: coins ?? _coins,
        deviceData: deviceData ?? _deviceData,
        adLoaded: adLoaded ?? _adLoaded,
        adFailed: adFailed ?? _adFailed,
        adWatched: adWatched ?? _adWatched,
        adClicked: adClicked ?? _adClicked,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  num? get id => _id;

  String? get phoneId => _phoneId;

  String? get email => _email;

  String? get appleIdCode => _appleIdCode;

  String? get oneSignalId => _oneSignalId;

  String? get appPackage => _appPackage;

  String? get appVersion => _appVersion;

  String? get userCountry => _userCountry;

  String? get networkData => _networkData;

  String? get vpnCountry => _vpnCountry;

  num? get appTrans => _appTrans;

  String? get coins => _coins;

  String? get deviceData => _deviceData;

  String? get adLoaded => _adLoaded;

  String? get adFailed => _adFailed;

  String? get adWatched => _adWatched;

  String? get adClicked => _adClicked;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['phoneId'] = _phoneId;
    map['email'] = _email;
    map['appleIdCode'] = _appleIdCode;
    map['oneSignalId'] = _oneSignalId;
    map['appPackage'] = _appPackage;
    map['appVersion'] = _appVersion;
    map['userCountry'] = _userCountry;
    map['networkData'] = _networkData;
    map['vpnCountry'] = _vpnCountry;
    map['appTrans'] = _appTrans;
    map['coins'] = _coins;
    map['deviceData'] = _deviceData;
    map['adLoaded'] = _adLoaded;
    map['adFailed'] = _adFailed;
    map['adWatched'] = _adWatched;
    map['adClicked'] = _adClicked;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
