import 'dart:convert';

import 'package:maps_app/constants/constants.dart';
import 'package:http/http.dart' as http;

class Places {
  Future<String> getPlaceId(String input) async {
    String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$apiKey';

    var response = await http.get(Uri.parse(url));

    var json = await jsonDecode(response.body);
    print(json);
    var placeId = json['candidates'][0]['place_id'] as String;
    print("Here");
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String place) async {
    print(place);
    String placeId = await getPlaceId(place);
    print(placeId);
    String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?place_id=$placeId&key=$apiKey';
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;
    print(results);
    print("Here 1");
    return results;
  }
}
