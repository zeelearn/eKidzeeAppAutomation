import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:ekidzee/helper/KidzeePref.dart';
import 'package:ekidzee/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum HttpMethod { get, post, put, delete, multipart }

/// Failure class for representing errors

class ApiProvider {
  static Future<Either<String, dynamic>> request(
    String endpoint, {
    HttpMethod method = HttpMethod.get,
    Map<String, String>? headers,
    dynamic body,
    Map<String, String>? fields,
    Map<String, File>? files,
  }) async {
    bool isInternet = await Utility.isInternet();
    if (!isInternet) {
      return Left('No internet connection');
    }
    final uri = Uri.parse(endpoint);
    final token = await KidzeePref().getString('token');
    if (token != null && token.isNotEmpty) {
      headers ??= {};
      headers['Content-Type'] = 'application/json';
      headers['Authorization'] = 'Bearer $token';
    }
    headers ??= {'Content-Type': 'application/json'};

    http.Response response;

    try {
      if (method == HttpMethod.multipart) {
        final request = http.MultipartRequest('POST', uri);
        request.headers.addAll(headers);

        if (fields != null) request.fields.addAll(fields);
        if (files != null) {
          for (var entry in files.entries) {
            final fileStream = http.MultipartFile.fromBytes(
              entry.key,
              await entry.value.readAsBytes(),
              filename: entry.value.path.split("/").last,
            );
            request.files.add(fileStream);
          }
        }

        final streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      } else {
        switch (method) {
          case HttpMethod.get:
            response = await http.get(uri, headers: headers);
            break;
          case HttpMethod.post:
            response =
                await http.post(uri, headers: headers, body: jsonEncode(body));
            break;
          case HttpMethod.put:
            response =
                await http.put(uri, headers: headers, body: jsonEncode(body));
            break;
          case HttpMethod.delete:
            response = await http.delete(uri, headers: headers);
            break;
          default:
            throw UnsupportedError('Unsupported HTTP method');
        }
      }

//       debugPrint('Api url is - $uri error is - ${response.body} request is - $body');

      debugPrint('Api url is -  request is - $body');

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Network error: $e');
      return Left('Something went wrong.');
    }
  }

  static Either<String, dynamic> _handleResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Right(body);
    } else {
      final errorMessage = body?['message'] ??
          'Something went wrong.' /* 'Error: ${response.statusCode}' */;
      return Left(errorMessage);
    }
  }
}
