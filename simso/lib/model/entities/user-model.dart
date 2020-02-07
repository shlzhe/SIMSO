class UserModel {
  UserModel({
    this.docID, 
    this.username, 
    this.email,
    });
  UserModel.isEmpty(){
    this.docID='';
    this.username=''; 
    this.email='';
  }
  String docID;
  String username;
  String email;

  UserModel.fromJson(Map<String, dynamic> json): 
    username = json['username'],
    email = json['email'];

  Map<String, dynamic> toJson() {
    return {
      'username' : username,
      'email' : email
    };
  }
}