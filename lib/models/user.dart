class User {
  String uid;
  String name;
  String email;
  String photoUrl;
  String displayName;
  String followers;
  String following;
  String posts;
  String bio;
  String phone;

  User(
      {this.uid,
      this.name,
      this.email,
      this.photoUrl,
      this.displayName,
      this.followers,
      this.following,
      this.bio,
      this.posts,
      this.phone});

  Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    data['photoUrl'] = user.photoUrl;
    data['displayName'] = user.displayName;
    data['followers'] = user.followers;
    data['following'] = user.following;
    data['bio'] = user.bio;
    data['posts'] = user.posts;
    data['phone'] = user.phone;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    this.photoUrl = mapData['photoUrl'];
    this.displayName = mapData['displayName'];
    this.followers = mapData['followers'];
    this.following = mapData['following'];
    this.bio = mapData['bio'];
    this.posts = mapData['posts'];
    this.phone = mapData['phone'];
  }
}
