class BookModel {
  late String id;
  late String name;
  late String desciption;
  late String price;
  late String author;
  late String imageUrl;

  BookModel(
      {required this.id,
      required this.name,
      required this.desciption,
      required this.price,
      required this.author,
      required this.imageUrl});

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    desciption = json['desciption'];
    price = json['price'];
    author = json['author'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['desciption'] = this.desciption;
    data['price'] = this.price;
    data['author'] = this.author;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
