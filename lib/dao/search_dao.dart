import 'package:demo/model/search_model.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchDao {
  static Future<SearchModel> fetch(String url, String keyword) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //修复中文乱码问题
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      //动态添加keyword
      SearchModel searchModel = SearchModel.fromJson(result);
      searchModel.keyword = keyword;
      return searchModel;
    } else {
      throw Exception('网络请求失败');
    }
  }
}
