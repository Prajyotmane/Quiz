import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/constants.dart';
import 'package:my_flutter_app/quizroute.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//This is the main screen of the application
void main() async {
  runApp(MyApp());
}

Future<bool> _areDetailsSaved() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(infoSavedFlag);
}

//Saves the user's details when all the fields have been validated
Future<bool> _saveDetails(
    String _firstName, String _lastName, String _nickName, String _age) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(infoSavedFlag, true);
  prefs.setString(firstNameKey, _firstName);
  prefs.setString(lastNameKey, _lastName);
  prefs.setString(nickNameKey, _nickName);
  prefs.setString(ageKey, _age);
  return true;
}

//The stateful widget of the application
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = "",
      _lastName = "",
      _nickName = "",
      _age = "",
      score = "",
      scoreText = "";

  //Function to fetch the user's information from the sharedpreferences
  Future<bool> _getDetails() async {
    final prefs = await SharedPreferences.getInstance();
    _firstName = prefs.getString(firstNameKey) ?? "";
    _lastName = prefs.getString(lastNameKey) ?? "";
    _nickName = prefs.getString(nickNameKey) ?? "";
    _age = prefs.getString(ageKey) ?? "";
    final directory = await getApplicationDocumentsDirectory();
    String path = directory.path;
    print("my path is " + path);
    File _localFile = File('$path/score.txt');

    //This will fetch the score from the file,
    // if file is not present then exception will be thrown and no score will be displayed on the first page
    try {
      String scoreFromFile = await _localFile.readAsString();
      if (scoreFromFile != null) {
        scoreText = scoreLabelText;
        score = scoreFromFile;
        print("File found. Reading the score from the file");
      }
    } catch (e) {
      print("No file found, User haven't attempted any quiz yet.");
    }

    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(userInfoLabel),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
          //Future builder to make sure that we have fetched the values from the
          // sharedpreferences before rendering the form
          future: _getDetails(),
          builder: (context, snapshot) {
            print(snapshot.data);
            if (snapshot.data == true) {
              return SingleChildScrollView(
                child: Padding(
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
                                InputDecoration(labelText: firstNameLabel),
                            validator: (value) {
                              if (value.isEmpty) {
                                return firstNameErrorText;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _firstName = value;
                            },
                            initialValue: "$_firstName",
                          ),
                          TextFormField(
                            initialValue: "$_lastName",
                            decoration:
                                InputDecoration(labelText: lastNameLabel),
                            validator: (value) {
                              if (value.isEmpty) {
                                return lastNameErrorText;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _lastName = value;
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(labelText: nickNameLabel),
                            validator: (value) {
                              if (value.isEmpty) {
                                return nickNameErrorText;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _nickName = value;
                            },
                            initialValue: "$_nickName",
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(labelText: ageLabel),
                            validator: (value) {
                              if (value.isEmpty) {
                                return ageErrorText;
                              } else if (double.tryParse(value) == null) {
                                return invalidAgeError;
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _age = value;
                            },
                            initialValue: "$_age",
                          ),
                          Builder(
                            builder: (context) => Column(
                              children: [
                                Container(
                                    padding: EdgeInsets.all(5.0),
                                    child: RaisedButton(
                                        color: Theme.of(context).dividerColor,
                                        onPressed: () {
                                          print("Button pressed");
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            _saveDetails(_firstName, _lastName,
                                                    _nickName, _age)
                                                .then((value) {
                                              final snackBar = SnackBar(
                                                  content: Text(
                                                      acknowledgeSaveDetails));
                                              Scaffold.of(context)
                                                  .showSnackBar(snackBar);
                                            });
                                          }
                                        },
                                        child: Text(saveLabel))),
                                Container(
                                  child: RaisedButton(
                                    color: Theme.of(context).dividerColor,
                                    onPressed: () {
                                      _areDetailsSaved().then((value) {
                                        if (value == true) {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ReadQuestions()),
                                          );
                                        } else {
                                          final snackBar = SnackBar(
                                              content:
                                                  Text(noDataEnteredErrorText));
                                          Scaffold.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      });
                                    },
                                    child: Text(startQuizLabel),
                                  ),
                                ),
                                Container(
                                  //Container to display the score
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(scoreText,
                                          style: TextStyle(fontSize: 16.0)),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          score,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } else {
              //If data is still being loaded from the sharedpreferences, then this placeholder would be displayed
              return Scaffold(
                body: Center(
                    child: Text(
                  loadingMessage,
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
              );
            }
          }),
    ));
  }
}
