import 'dart:convert';
import 'dart:io';
import 'package:uts_2255011010/dto/division.dart';
import 'package:uts_2255011010/dto/priority.dart';
import 'package:uts_2255011010/main.dart';
// import 'package:uts_2255011010/screens/cs_screen.dart';
import 'package:uts_2255011010/services/datastatic.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:uts_2255011010/endpoints/endpoints.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Priority? _selectedPriority;
  List<Priority> _priorityOptions = [];
  Division? _selectedDepartment;
  List<Division> _departmentOptions = [];

  String _title = "";
  String _description = "";
  int _rating = 0;

  File? galleryFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchDataPriority();
    _fetchDataDepartment();
    _selectedPriority = null;
    _selectedDepartment = null;
    _titleController.text = "";
    _descriptionController.text = "";
  }

  Future<void> _fetchDataPriority() async {
    try {
      final response = await http
          .get(Uri.parse('https://simobile.singapoly.com/api/priority-issues'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['datas'];
        setState(() {
          _priorityOptions =
              data.map((item) => Priority.fromJson(item)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load priority options')),
        );
      }
    } catch (error) {
      print('Error fetching priority options: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching priority options: $error')),
      );
    }
  }

  Future<void> _fetchDataDepartment() async {
    try {
      final response = await http.get(
          Uri.parse('https://simobile.singapoly.com/api/division-department'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['datas'];
        setState(() {
          _departmentOptions =
              data.map((item) => Division.fromJson(item)).toList();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load department options')),
        );
      }
    } catch (error) {
      print('Error fetching department options: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching department options: $error')),
      );
    }
  }

  void _showPicker({required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('PhotoLibrary'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getImage(ImageSource img) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(() {
      if (xfilePick != null) {
        galleryFile = File(pickedFile!.path);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Nothing is selected')));
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void saveData() {
    debugPrint(_title);
  }

  Future<void> _postDataWithImage(BuildContext context) async {
    if (galleryFile == null) {
      return;
    }

    try {
      await DataService.postDataWithImage(
        _titleController.text,
        _descriptionController.text,
        _rating,
        _selectedPriority?.priorityName ?? '',
        _selectedDepartment?.divisionDepartmentName ?? '',
        galleryFile!,
      );

      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const CustomerScreen(),
      //   ),
      // );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error posting data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(126, 21, 0, 255),
        title: Text("Tambah Customer Service"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  _showPicker(context: context);
                },
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: galleryFile == null
                        ? Text(
                            "Tap to select an image",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[600],
                            ),
                          )
                        : Image.file(
                            galleryFile!,
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Issue",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Rating",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey[800],
                ),
              ),
              RatingBar.builder(
                initialRating: _rating.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating.toInt();
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Priority>(
                items: _priorityOptions.map((Priority value) {
                  return DropdownMenuItem<Priority>(
                    value: value,
                    child: Text(value.priorityName!),
                  );
                }).toList(),
                onChanged: (Priority? value) {
                  setState(() {
                    _selectedPriority = value;
                  });
                },
                value: _selectedPriority,
                hint: const Text("Select Priority"),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<Division>(
                items: _departmentOptions.map((Division value) {
                  return DropdownMenuItem<Division>(
                    value: value,
                    child: Text(value.divisionDepartmentName!),
                  );
                }).toList(),
                onChanged: (Division? value) {
                  setState(() {
                    _selectedDepartment = value;
                  });
                },
                value: _selectedDepartment,
                hint: const Text("Select Department"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        tooltip: 'Save',
        onPressed: () {
          _postDataWithImage(context);
        },
        child: const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }
}
