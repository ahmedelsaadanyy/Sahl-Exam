class UsersModel{
  String? name;
  String? email;
  String? image;
  String? phone;
  bool? isAdmin;
  String? uid;


  UsersModel({
    this.name,
    this.email,
    this.image,
    this.phone,
    this.uid,
    this.isAdmin,

  });

  UsersModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    image = json['image'];
    phone = json['phone'];
    uid = json['uid'];
    isAdmin = json['isAdmin'];
  }



  Map<String,dynamic>? toMap(){
    return {
      'name':name,
      'email':email,
      'phone':phone,
      'image': image,
      'uid': uid,
      'isAdmin': isAdmin,
    };
  }

}