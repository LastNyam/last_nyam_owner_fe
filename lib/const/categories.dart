class Category {
  String text;
  String type;

  Category(this.text, this.type);
}

List<Category> categories = [
  Category('전체', 'all'),
  Category('식자재', 'ingredients'),
  Category('완제품', 'product'),
];
