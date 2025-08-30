import 'dart:convert';
import 'dart:io';

import 'package:your_project_name/Models/AppConstants.dart';
import 'package:your_project_name/Models/BadRequestModel.dart';
import 'package:your_project_name/Network/HttpOperations.dart';
import 'package:http/http.dart' as http;

bool isSuccessful(status) {
  return status >= 200 && status <= 300;
}

Future<bool> isJsonValid(json) async {
  try {
    var f = jsonDecode(json) as Map<String, dynamic>;
    f = f;
    return true;
  } catch (e) {
    throw e.toString();
  }
}

Future handleResponse(http.Response response) async {
  try {
    //  if (!await isNetworkAvailable()) {
    //   toast(noInternetMsg);
    // } else {

    if (response.statusCode == 200) {
      String body = response.body;
      if (isSuccessful(response.statusCode)) {
        return jsonDecode(body);
      } else {
        if (await isJsonValid(body)) {
          throw jsonDecode(body)['message'];
        } else {
          //toast(errorMsg);
          throw 'Error';
        }
      }
    } else {
      if (response.statusCode == 404) {
        throw 'server not found';
      } else if (response.statusCode == 500) {
        throw 'internal server error';
      } else if (response.statusCode == 400) {
        BadRequestModel br =
            BadRequestModel.fromJson(jsonDecode(response.body));

        throw br.message ?? 'Bad Request';
      } else if (response.statusCode == 401) {
        throw 'Unauthorized Request Found';
      } else if (response.statusCode == 405) {
        throw 'Method Not Allowed';
      } else if (response.statusCode == 417) {
        if (await isJsonValid(response.body.toString())) {
          throw jsonDecode(response.body.toString())['message'];
        }
      }
    }
    //}
  } catch (e) {
    if (e is SocketException) {
      throw 'No Internet';
    } else {
      throw e.toString();
    }
  }
}

Future getlogin(Map data) async {
  return handleResponse(await HttpOperations()
      .ourpostAsync('${mBaseUrl}login', data, requireToken: false));
}

Future getDb(int agentid, String date) async {
  return handleResponse(await HttpOperations().ourgetAsync(
      '${mBaseUrl}GetQdAppDb?agentid=$agentid&date=$date',
      requireToken: true));
}

Future getDeliveries(int agentid, String date, String status) async {
  return handleResponse(await HttpOperations().ourgetAsync(
      '${mBaseUrl}GetQdAppDeliveyList?agentid=$agentid&status=$status&date=$date',
      requireToken: true));
}

Future getInvoiceDetails(int salemid) async {
  return handleResponse(await HttpOperations().ourgetAsync(
      '${mBaseUrl}GetSaledetails?salemid=$salemid',
      requireToken: true));
}

Future getchangeStatus(int deliveryid, String status, Map data) async {
  return handleResponse(await HttpOperations().ourpostAsync(
      '${mBaseUrl}UpdateStatus?deliveryid=$deliveryid&status=$status', data,
      requireToken: true));
}

Future getTimeSlotList(int branchId) async {
  try {
    print('=== GET TIME SLOT LIST ===');
    print('Branch ID: $branchId');
    
    final response = await HttpOperations().ourgetAsync(
        '${mBaseUrl}GetTimeSlotList?branchid=$branchId',
        requireToken: true);
    
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    
    final result = handleResponse(response);
    print('Time slot list result: $result');
    return result;
  } catch (e) {
    print('Get time slot list error: $e');
    throw e.toString();
  }
}

Future rescheduleDelivery(
    int deliveryid, String newDate, String newTimeSlot) async {
  try {
    print('=== RESCHEDULE DEBUG START ===');
    print('deliveryid: $deliveryid');
    print('newDate: $newDate');
    print('newTimeSlot: $newTimeSlot');
    print('mBaseUrl: $mBaseUrl');
    print('appUser.token: ${appUser.token}');

    // Validate inputs
    if (deliveryid <= 0) {
      throw 'Invalid delivery ID';
    }
    if (newDate.isEmpty) {
      throw 'Invalid date';
    }
    if (newTimeSlot.isEmpty) {
      throw 'Invalid time slot';
    }
    if (appUser.token.isEmpty) {
      throw 'User not authenticated';
    }

    // newTimeSlot is now the timeSlotId directly
    int timeslotid = int.parse(newTimeSlot);
    print('timeslotid: $timeslotid');

    Map<String, String> data = {
      "deliveryid": deliveryid.toString(),
      "date": newDate,
      "timeslotid": timeslotid.toString(),
    };

    print('Data: $data');
    print('=== RESCHEDULE DEBUG END ===');

    final response = await HttpOperations().ourpostAsync(
        '${mBaseUrl}ReSchedule?deliveryid=$deliveryid&date=$newDate&timeslotid=$timeslotid',
        {},
        requireToken: true);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    final result = handleResponse(response);
    print('Reschedule result: $result');
    print('Reschedule result type: ${result.runtimeType}');
    return result;
  } catch (e) {
    print('Reschedule error: $e');
    throw e.toString();
  }
}

int _getTimeSlotId(String timeSlot) {
  switch (timeSlot) {
    case '7am - 9am':
      return 1;
    case '9am - 11am':
      return 2;
    case '11am - 12pm':
      return 3;
    case '12pm - 2pm':
      return 4;
    case '2pm - 4pm':
      return 5;
    case '4pm - 6pm':
      return 6;
    case '6pm - 8pm':
      return 7;
    case '8pm - 10pm':
      return 8;
    default:
      return 1; // Default to first time slot
  }
}




  // Future getViewDtoWithTaggedQuantity(int id) async {
  //   return handleResponse(await HttpOperations(ApiRoute.customerRoute)
  //       .ourgetAsync('$mBaseCusDbUrl${url}GetViewDtoWithTaggedQuantity?id=$id',
  //           requireToken: true));
  // }