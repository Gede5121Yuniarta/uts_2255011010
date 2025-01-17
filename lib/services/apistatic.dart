// import 'dart:async';
// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:uts_2255011010/models/customer.dart';
// import 'package:uts_2255011010/models/division.dart';
// import 'package:uts_2255011010/models/errmsg.dart';
// import 'package:uts_2255011010/models/priority.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class APiService {
//   //static final host='http://192.168.43.189/webtani/public';
//   static final host = 'https://simobile.singapoly.com';
//   static var _token = "8|x6bKsHp9STb0uLJsM11GkWhZEYRWPbv0IqlXvFi7";
//   Future<SharedPreferences> preferences = SharedPreferences.getInstance();
//   static Future<void> getPref() async {
//     Future<SharedPreferences> preferences = SharedPreferences.getInstance();
//     final SharedPreferences prefs = await preferences;
//     _token = prefs.getString('token') ?? "";
//   }

//   static getHost() {
//     return host;
//   }

//   // Fetch all petani
//   Future<List<CustomerService>> fetchDataCustomer() async {
//     final response = await http.get(Uri.parse("$host/api/trpl/customer-service/2255011010"));

//     if (response.statusCode == 200) {
//       var json = jsonDecode(response.body);
//       final data = json['datas'];

//       if (data is List) {
//         return data
//             .map((petaniJson) => CustomerService.fromJson(petaniJson))
//             .toList();
//       } else {
//         throw Exception('Data is not in the expected format');
//       }
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   // Create a new petani tanpa file-------------------------------------------
//   // Future<CustomerService> createData(CustomerService instance) async {
//   //   final response = await http.post(Uri.parse("$host/api/trpl/customer-service/2255011010/"),
//   //     headers: {
//   //       'Content-Type': 'application/json',
//   //     },
//   //     body: jsonEncode({
//   //       // sesuaikan dengan form dari postman collection
//   //       'id_division_target': instance.idDivisionTarget,
//   //       'id_priority': instance.idPriority,
//   //       'title_issues': instance.titleIssues,
//   //       'description_issues': instance.descriptionIssues,
//   //       'rating': instance.rating,
//   //       'division_departmen_name': instance.divisionDepartmentName,
//   //       'priority_name': instance.priorityName,
//   //     }),
//   //   );

//   //   if (response.statusCode == 201) {
//   //     return CustomerService.fromJson(jsonDecode(response.body));
//   //   } else {
//   //     throw Exception('Failed to create petani');
//   //   }
//   // }

//   // Update an existing petani dengan file
//   static Future<ErrorMSG> editDataWithFile(id, instance, filepath) async {
//     try {
//       print(instance);
//       print(id);

//       var url = Uri.parse('$host/api/trpl/customer-service/2255011010/$id');

//       var request = http.MultipartRequest('POST', url);
//       request.fields['title_issues'] = instance.titleIssues!;
//       request.fields['description_issues'] = instance.descriptionIssues!;
//       request.fields['rating'] = instance.rating!.toString();
//       request.fields['id_priority'] = instance.idPriority!.toString();
//       request.fields['id_division_target'] = instance.idDivisionTarget!.toString();

//       if (filepath != '') {
//         request.files.add(await http.MultipartFile.fromPath('image_url', filepath));
//       }
//       request.headers.addAll({
//         'Authorization': 'Bearer ' + _token,
//       });
//       var response = await request.send();

//       // sesuaikan dengan response json yang diberikan
//       if (response.statusCode == 200) {
//         final respStr = await response.stream.bytesToString();
//         print(jsonDecode(respStr));
//         return ErrorMSG.fromJson(jsonDecode(respStr));
//       } else {
//         throw Exception('Failed to update');
//       }
//     } catch (e) {
//       print(e);
//       throw Exception('Error $e');
//     }
//   }
//   //--------------------------------------------------------------------------------

//   // Delete a petani
//   Future<void> deleteDataCustomer(int id) async {
//     final response = await http.delete(
//       Uri.parse('$host/api/trpl/customer-service/2255011010/$id'),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Failed to delete data');
//     }
//   }

//   // get kelompok petani
//    Future<List<DivisionDepartment>> getDataDepartment() async {
//     try {
//       // ubah url sesuai dengan url di collection
//       // const url = 'api/priority-issues';
//       // ubah url sesuai dengan url di collection
//       final response =
//           await http.get(Uri.parse("$host/api/division-department"), headers: {
//         'Authorization': 'Bearer ' + _token,
//       });
//       if (response.statusCode == 200) {
//         var json = jsonDecode(response.body);
//         var data = json.datas;
//         final parsed = data.cast<Map<String, dynamic>>();
//         return parsed
//             .map<DivisionDepartment>(
//                 (json) => DivisionDepartment.fromJson(json))
//             .toList();
//         // ignore: dead_code
//         print(parsed);
//       } else {
//         return [];
//       }
//     } catch (e) {
//       return [];
//     }
//   }
//    Future<List<PriortyIssue>> getDataPriority() async {
//     try {
//       // ubah url sesuai dengan url di collection
//       // const url = 'api/priority-issues';
//       // ubah url sesuai dengan url di collection
//       final response =
//           await http.get(Uri.parse("$host/api/priority-issues"), headers: {
//         'Authorization': 'Bearer ' + _token,
//       });
//       if (response.statusCode == 200) {
//         var json = jsonDecode(response.body);
//         var data = json.datas;
//         final parsed = data.cast<Map<String, dynamic>>();
//         return parsed
//             .map<DivisionDepartment>(
//                 (json) => DivisionDepartment.fromJson(json))
//             .toList();
//         // ignore: dead_code
//         print(parsed);
//       } else {
//         return [];
//       }
//     } catch (e) {
//       return [];
//     }
//   }

//   static Future<ErrorMSG> saveData(instance, filepath) async {
//     try {
//       print(instance);
//       var url = Uri.parse('$host/api/trpl/customer-service/2255011010');
//       // if (id != 0) {
//       //   url = Uri.parse('$host/api//' + id.toString());
//       // }

//       var request = http.MultipartRequest('POST', url);
//       request.fields['title_issues'] = instance.titleIssue;
//       request.fields['description_issues'] = instance.descriptionIssues;
//       request.fields['rating'] = instance.rating;
//       // request.fields['image'] = instance.telp;
//       request.fields['id_division_target'] = instance.idDivisionTarget;
//       request.fields['id_priority'] = instance.idPriority;
//       if (filepath != '') {
//         request.files.add(await http.MultipartFile.fromPath('image', filepath));
//       }
//       request.headers.addAll({
//         'Authorization': 'Bearer ' + _token,
//       });
//       var response = await request.send();

//       if (response.statusCode == 200) {
//         final respStr = await response.stream.bytesToString();
//         print(jsonDecode(respStr));
//         return ErrorMSG.fromJson(jsonDecode(respStr));
//       } else {
//         throw Exception('Failed to create data');
//       }
//     } catch (e) {
//       print(e);
//       throw Exception('Error $e');
//     }
//   }
// }