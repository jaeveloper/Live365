import 'package:path/path.dart' as Path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';

class FireStoreClass {
  static final Firestore _db = Firestore.instance;
  static final liveCollection = 'liveuser';
  static final userCollection = 'users';
  static final emailCollection = 'user_email';

  static void createLiveUser({name, id, time, image}) async {
    final snapShot = await _db.collection(liveCollection).document(name).get();
    if (snapShot.exists) {
      await _db.collection(liveCollection).document(name).updateData(
          {'name': name, 'channel': id, 'time': time, 'image': image});
    } else {
      await _db
          .collection(liveCollection)
          .document(name)
          .setData({'name': name, 'channel': id, 'time': time, 'image': image});
    }
  }

  static Future<String> getImage({username}) async {
    final snapShot =
        await _db.collection(userCollection).document(username).get();
    return snapShot.data['photoUrl'];
  }

  static Future<String> getName({username}) async {
    final snapShot =
        await _db.collection(userCollection).document(username).get();
    return snapShot.data['name'];
  }

  static Future<bool> checkUsername({username}) async {
    final snapShot =
        await _db.collection(userCollection).document(username).get();
    //print('Xperion ${snapShot.exists} $username');
    if (snapShot.exists) {
      return false;
    }
    return true;
  }

  static Future<void> regUser({
    name,
    email,
    uid,
    image,
    username,
  }) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('$email/${Path.basename(image.path)}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete; //  Image Upload code

    await storageReference.getDownloadURL().then((fileURL) async {
      // To fetch the uploaded data's url

      await _db.collection(userCollection).document(uid).setData({
        'name': name,
        'uid': uid,
        'email': email,
        'photoUrl': fileURL,
        'displayName': username,
        'followers': '0',
        'following': '0',
        'posts': '0',
        'bio': '',
        'phone': '',
      });
      return true;
    });
  }

  static void deleteUser({username}) async {
    await _db.collection('liveuser').document(username).delete();
  }

  static Future<void> getDetails({email}) async {
    var document = await Firestore.instance.document('user_email/$email').get();
    var checkData = document.data;
    if (checkData == null) return;
  }
}
