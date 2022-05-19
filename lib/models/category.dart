class Category {
  Category(k, v) {
    key = k;
    name = v['Name'];
    icon = v['Icon'] ?? 'dining-room';
    color = v['Color'];
  }
  String key = '';
  String name = '';
  String icon = 'dining-room';
  String? color;

  Object saveObject() {
    return {
      'Name': this.name,
      'Icon': this.icon,
      'Color': this.color!.toUpperCase()
    };
  }
}