import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  List<dynamic> dataList = [];

  fetchData() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/albums');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        dataList = jsonDecode(response.body);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _txtCtrl = TextEditingController();
  String _result = "wait";

  @override
  void dispose() {
    _txtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Validation"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _txtCtrl,
              validator: (value) {
                if (value!.isEmpty || value.isEmpty) {
                  return "Min 8 characters";
                }
                return null;
              },
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print("FORM SUDAH LENGKAP");

                  setState(() {
                    _result = _txtCtrl.text;
                  });

                  if (_result == "heri tampan") {
                    fetchData();
                  } else {
                    dataList.clear();
                  }
                }
              },
              child: const Text("Submit"),
            ),
            Text(_result),
            if (_result == "heri tampan")
              Expanded(
                child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        dataList[index]['title'],
                        style: TextStyle(color: Colors.blueAccent),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
