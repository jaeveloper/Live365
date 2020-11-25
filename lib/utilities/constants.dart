import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final _firestore = Firestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = _firestore.collection('users');
final coinRequestRef = _firestore.collection('coinRequest');
final bynaseRef = _firestore.collection('bynase');
final bitcoinRef = _firestore.collection('bitcoin');
final ethereumRef = _firestore.collection('ethereum');
final litecoinRef = _firestore.collection('litecoin');
final bitbotRef = _firestore.collection('bitbot');
final rippleRef = _firestore.collection('ripple');
final cardanoRef = _firestore.collection('cardano');
final stellarRef = _firestore.collection('stellar');
final zainRef = _firestore.collection('zain');
final moneroRef = _firestore.collection('monero');
