class User {
  final int? id;
  final String? userName;
  final String? userEmail;
  final String? password;
  final String? phoneNumber;


  User({
    this.id,
    this.userName,
    this.userEmail,
    this.password,
    this.phoneNumber,

  });

  factory User.fromMap(Map<String, dynamic> json) => User(
    id: json["id"],
    userName: json["userName"],
    userEmail: json["userEmail"],
    password: json["password"],
    phoneNumber: json["phoneNumber"],

  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "userName": userName,
    "userEmail": userEmail,
    "password": password,
    "phoneNumber": phoneNumber,

  };
}