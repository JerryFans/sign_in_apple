class AppleIdUser {
  String name;
  String familyName;
  String givenName;
  String mail;
  String userIdentifier;
  String authorizationCode;
  String identifyToken;

  AppleIdUser(
      {this.name,
      this.familyName,
      this.givenName,
      this.mail,
      this.userIdentifier,
      this.authorizationCode,
      this.identifyToken});

  AppleIdUser.fromJson(dynamic json) {
    name = json['name'];
    familyName = json['familyName'];
    givenName = json['givenName'];
    mail = json['mail'];
    userIdentifier = json['userIdentifier'];
    authorizationCode = json['authorizationCode'];
    identifyToken = json['identifyToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['familyName'] = this.familyName;
    data['givenName'] = this.givenName;
    data['mail'] = this.mail;
    data['userIdentifier'] = this.userIdentifier;
    data['authorizationCode'] = this.authorizationCode;
    data['identifyToken'] = this.identifyToken;
    return data;
  }
}

