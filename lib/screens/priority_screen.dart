import 'package:uts_2255011010/dto/priority.dart';
import 'package:uts_2255011010/services/datastatic.dart';
import 'package:uts_2255011010/utils/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PriorityScreen extends StatefulWidget {
  const PriorityScreen({Key? key}) : super(key: key);

  @override
  _PriorityScreenState createState() => _PriorityScreenState();
}

class _PriorityScreenState extends State<PriorityScreen> with WidgetsBindingObserver {
  Future<List<Priority>>? priorities;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    priorities = DataService.fetchPriority();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<bool> didPopRoute() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Priorities Issues"),
          backgroundColor: const Color.fromARGB(126, 21, 0, 255),
        ),
        drawer: CustomDrawer(),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        //   tooltip: 'Add New Priority',
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const FormScreen()),
        //     );
        //   },
        //   child: const Icon(Icons.add),
        // ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: FutureBuilder<List<Priority>>(
                      future: priorities,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data!;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final item = data[index];
                              return Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Text(
                                  'Priority: ${item.priorityName}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: const Color.fromARGB(255, 36, 31, 31),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Center(child: Text('${snapshot.error}'));
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}