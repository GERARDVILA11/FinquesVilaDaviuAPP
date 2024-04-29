import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorits.dart';
import '../models/immoble.dart';

abstract class DBService {
  static final CollectionReference<Immoble> _immoblesCollection =
      FirebaseFirestore.instance.collection('immobles').withConverter<Immoble>(
            fromFirestore: (snapshot, _) => Immoble.fromJson(snapshot.data()!),
            toFirestore: (immoble, _) => immoble.toJson(),
          );
  static final CollectionReference<Favorits> _favoritsCollection =
      FirebaseFirestore.instance.collection('favorits').withConverter(
            fromFirestore: (snapshot, _) => Favorits.fromJson(snapshot.data()!),
            toFirestore: (favorit, _) => favorit.toJson(),
          );

  _dbService();

  static Stream<List<Immoble>> immoblesStream() {
    return _immoblesCollection.snapshots().map<List<Immoble>>(
        (snapshot) => snapshot.docs.map<Immoble>((e) => e.data()).toList());
  }

  static Stream<List<Immoble>> immoblesFavoritsStream(
      List<Favorits> llistaFavorits) {
    return _immoblesCollection
        .where("id", whereIn: llistaFavorits.map<String>((f) => f.idproducte))
        .snapshots()
        .map<List<Immoble>>(
            (snapshot) => snapshot.docs.map<Immoble>((e) => e.data()).toList());
  }

  static Stream<List<Favorits>> getFavorites(String uid) {
    return _favoritsCollection
        .where('UID', isEqualTo: uid)
        .snapshots()
        .map<List<Favorits>>(
          (snapshot) => snapshot.docs.map<Favorits>((e) => e.data()).toList(),
        );
  }

  static Stream<bool> isFavorit(Favorits favorit) {
    return _favoritsCollection
        .where('UID', isEqualTo: favorit.UID)
        .where("idproducte", isEqualTo: favorit.idproducte)
        .snapshots()
        .map<bool>(
          (snapshot) => snapshot.docs.isNotEmpty,
        );
  }

  static addFavorite(Favorits favorit) {
    _favoritsCollection.doc(favorit.idproducte + favorit.UID).set(favorit);
  }

  static deleteFavorite(Favorits favorit) {
    _favoritsCollection.doc(favorit.idproducte + favorit.UID).delete();
  }
}
