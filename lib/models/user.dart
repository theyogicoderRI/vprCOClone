class MyUser {
  MyUser({this.uid, this.phoneNumber, this.img, this.email});
  final String? uid;
  final String? phoneNumber;
  final String? img;
  final String? email;

  //formatting to upload user fields to Firebase when creating user
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'phoneNumber': phoneNumber,
        'img': img,
        'email': email,
      };
}

class AddUser {
  AddUser({this.phoneNumber, this.img, this.email});

  late String? phoneNumber;
  final String? img;
  final String? email;

  //formatting to upload user fields to Firebase when creating user
  Map<String, dynamic> toJson() =>
      {'phoneNumber': phoneNumber, 'img': img, 'email': email};
}
