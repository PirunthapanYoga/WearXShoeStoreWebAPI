import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/store.dart';


class GetData{

  Future<http.Response> fetchResponse(){
    return http.get(Uri.parse('https://s3-eu-west-1.amazonaws.com/api.themeshplatform.com/products.json'));
  }

  Future<Store?> getProduct() async {
    var response = await fetchResponse();
    if(response.statusCode == 200){
      Map<String, dynamic> data = jsonDecode(response.body);
      return Store.fromJson(data);
    }else{
      print(response.statusCode);
    }
    return null;
  }
}