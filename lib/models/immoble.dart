class Immoble {
  String id;
  String reference;
  String name;
  String? longDesc;
  int isNew;
  String? title;
  String? subtitle;
  double price;
  String imagePortada;
  List<String> imageLinks;
  Map<String, String> features;

  Immoble({
    required this.id,
    required this.reference,
    required this.name,
    this.longDesc,
    required this.isNew,
    this.title,
    this.subtitle,
    required this.price,
    required this.imagePortada,
    this.imageLinks = const [],
    this.features = const {},
  });

  Immoble.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        reference = json['reference'],
        name = json['name'],
        longDesc = json['long_desc'],
        isNew = json['is_new'],
        title = json['title'],
        subtitle = json['subtitle'],
        price = json['price'],
        imagePortada = json['image_portada'],
        imageLinks = json['image_links'].cast<String>(),
        features = json['features'].cast<String, String>();

  Map<String, dynamic> toJson() => {
        'id': id,
        'reference': reference,
        'name': name,
        'long_desc': longDesc,
        'is_new': isNew,
        'title': title,
        'subtitle': subtitle,
        'price': price,
        'image_portada': imagePortada,
        'image_links': imageLinks,
        'features': features,
      };
}
