class Favorits {
  String UID;
  String idproducte;

  Favorits({required this.UID, required this.idproducte});

  Favorits.fromJson(Map<String, dynamic> json)
      : this(UID: json["UID"], idproducte: json["idproducte"]);

  Map<String, dynamic> toJson() => {
        "UID": UID,
        "idproducte": idproducte,
      };

  @override
  operator ==(covariant Favorits other) {
    return UID == other.UID && idproducte == other.idproducte;
  }

  @override
  int get hashCode => (UID + idproducte).hashCode;
}
