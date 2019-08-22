//搜索模型
class SearchModel {
  final List<SearchItem> data;
  String keyword;

  SearchModel({this.data, this.keyword});

  //工厂方法
  factory SearchModel.fromJson(Map<String, dynamic> json) {
    var datajson = json['data'] as List;
    List<SearchItem> d =
        datajson.map((item) => SearchItem.fromJson(item)).toList();
    return SearchModel(
      data: d,
    );
  }
}

class SearchItem {
  final String word;
  final String type;
  final String price;
  final String star;
  final String zonename;
  final String districtname;
  final String url;

  SearchItem(
      {this.word,
      this.type,
      this.price,
      this.star,
      this.zonename,
      this.districtname,
      this.url});

  //工厂方法
  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
        word: json['word'],
        type: json['type'],
        price: json['price'],
        star: json['star'],
        zonename: json['zonename'],
        districtname: json['districtname'],
        url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'type': type,
      'price': price,
      'star': star,
      'zonename': zonename,
      'districtname': districtname,
      'url': url,
    };
  }
}
