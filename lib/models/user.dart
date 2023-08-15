class CustomUser {
  String uuid;
  DateTime? firstLogin;
  bool isEnabled;

  CustomUser({ required this.uuid, this.firstLogin, required this.isEnabled });
}