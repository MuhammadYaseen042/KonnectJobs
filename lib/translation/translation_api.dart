import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class GoogleApi{


  static Future<String?> translateText(String textToTranslate, String targetLanguage, String apiKey) async {
    final baseUrl = 'https://translation.googleapis.com/language/translate/v2';
    final endpoint = '$baseUrl?key=$apiKey';

    final Map<String, dynamic> requestBody = {
      'q': textToTranslate,
      'target': targetLanguage,
    };

    final response = await http.post(Uri.parse(endpoint),
        body: json.encode(requestBody),
        headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final translatedText = data['data']['translations'][0]['translatedText'];
      return translatedText;
    } else {
      print('Failed to translate text. Error: ${response.statusCode}');
      return null;
    }
  }


  static Future<int> checkForBadWords(String description) async {
    String content = description;
    final response = await http.post(
      Uri.parse('https://language.googleapis.com/v1/documents:analyzeSentiment?key=AIzaSyATbdtvTacdo7zq_sC2famxyDSNHxRIcwo'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "document": {"type": "PLAIN_TEXT", "content": content},
        "encodingType": "UTF8",
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      double sentimentScore = data['documentSentiment']['score'];
      if (sentimentScore < -0.5) {
        return 1;
      } else {
        return 0;
      }
    } else {
      // If API call fails, assume no bad words
      return 0;
    }
  }
}