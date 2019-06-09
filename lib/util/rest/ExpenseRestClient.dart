import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:share_pool/common/Constants.dart';
import 'package:share_pool/model/dto/expense/ExpenseConfirmationDto.dart';
import 'package:share_pool/model/dto/expense/ExpenseRequestResponse.dart';
import 'package:share_pool/util/PreferencesService.dart';

class ExpenseRestClient {
  static const String BASE_URL = Constants.BASE_REST_URL + "/expenses/";

  static Future<ExpenseRequestResponseDto> requestExpense(int tourId) async {
    var response = await post(BASE_URL + tourId.toString(), headers: {
      "Content-Type": "application/json",
      HttpHeaders.authorizationHeader: await PreferencesService.getUserToken()
    });

    print(response.body);

    if (response.statusCode == 200) {
      return ExpenseRequestResponseDto.fromJson(json.decode(response.body));
    }

    return null;
  }

  static Future<bool> confirmExpense(
      ExpenseConfirmationDto expenseConfirmationDto) async {
    var body = "";

    var response = await put(
        BASE_URL + "/confirmations/" + expenseConfirmationDto.tourId.toString(),
        body: body,
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader:
          await PreferencesService.getUserToken()
        });

    print(response.body);

    return response.statusCode == 201;
  }
}