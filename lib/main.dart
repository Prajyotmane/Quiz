import 'package:flutter/material.dart';
import 'package:my_flutter_app/userinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _getDetails().then((value) {
    if (value == true) {
      runApp(UserInfo());
    } else {
      runApp(MyApp());
    }
  });
}

Future<bool> _getDetails() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool("info_saved");
}

Future<bool> _saveDetails(
    String _firstName, String _lastName, String _nickName, int _age) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool("info_saved", true);
  prefs.setString("First_name", _firstName);
  prefs.setString("Last_name", _lastName);
  prefs.setString("Nickname", _nickName);
  prefs.setInt("Age", _age);
  return prefs.commit();
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  String _firstName, _lastName, _nickName;
  int _age;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Quiz"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  decoration:
                      InputDecoration(labelText: "Enter First (given) name"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter first name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _firstName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: "Enter your Family (last) name"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter family name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _lastName = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Enter your Nickname"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter nickname';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nickName = value;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Enter your age"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter age';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _age = int.parse(value);
                  },
                ),
                Builder(
                  builder: (context) => Container(
                      padding: EdgeInsets.all(5.0),
                      child: ElevatedButton(
                          onPressed: () {
                            print("Button pressed");
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              _saveDetails(
                                      _firstName, _lastName, _nickName, _age)
                                  .then((value) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserInfo()),
                                );
                                // Navigator.pop(context);
                              });
                            }
                          },
                          child: Text("Done"))),
                ),
                // Container(
                //     padding: EdgeInsets.all(5.0),
                //     child: ElevatedButton(
                //         onPressed: () {}, child: Text("Take a Quiz")))
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
