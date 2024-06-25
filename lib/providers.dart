import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:surfpub/flutterPackage.dart';

part 'providers.g.dart';

@riverpod
Future<List<FlutterPackage>> packages(PackagesRef ref) async {
  final response = await http.get(Uri.parse('https://pub.dev/api/packages'));
  //print(response.body);

  // Using dart:convert, we then decode the JSON payload into a Map data structure.
  final json = jsonDecode(response.body) as Map<String, dynamic>;

  // Finally, we convert the Map into an Activity instance.
  List<FlutterPackage> data = [];

  for (var i in json['packages']) {
    data.add(FlutterPackage.fromJson(i));
  }

  return data;
}

class LikedModel extends ChangeNotifier {
  Map<String, bool> likedMap = {};

  addLike(String name) {
    likedMap[name] = true;
    notifyListeners();
  }

  removeLike(String name) {
    likedMap[name] = false;
    notifyListeners();
  }
}

final likesProvider = ChangeNotifierProvider<LikedModel>((ref) {
  return LikedModel();
});
