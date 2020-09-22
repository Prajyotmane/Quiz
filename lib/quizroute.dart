import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_flutter_app/AlertDialog.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'main.dart';
import 'package:my_flutter_app/constants.dart';

//This Route used to display the quiz
class ReadQuestions extends StatefulWidget {
  @override
  _ReadQuestionsState createState() => _ReadQuestionsState();
}

//This will read the questiosns from the JSON file
class _ReadQuestionsState extends State<ReadQuestions> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            DefaultAssetBundle.of(context).loadString("assets/questions.json"),
        builder: (context, snapshot) {
          List questions = json.decode(snapshot.data.toString());
          if (questions == null) {
            return MaterialApp(
              home: Scaffold(
                body: Text(loadingMessage),
              ),
            );
          } else {
            return QuizWindow(questions: questions);
          }
        });
  }
}

class QuizWindow extends StatefulWidget {
  List questions;

  QuizWindow({Key key, @required this.questions}) : super(key: key);

  @override
  _QuizWindowState createState() => _QuizWindowState(questions);
}

class _QuizWindowState extends State<QuizWindow> {
  String _option = "";
  List questions;

  _QuizWindowState(this.questions);

  int _currQuestionNumber = 0; //Index used to point to the current question
  bool _visible = false; //This handles the visibility of the button
  List<String> _answers = ["", "", "", ""]; //This will keep the track of choices the user has selected
  String _nextButtonLabel = next; //This holds the button lable and it changes to "End" when at the last question

  //This function displays the radio button for each choice of the answer
  Widget _radioButton(String label) {
    return ListTile(
      title: Text(
        label + ": " + questions[1][_currQuestionNumber.toString()][label],
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      leading: Radio(
        value: questions[1][_currQuestionNumber.toString()][label],
        groupValue: _option,
        onChanged: (value) {
          setState(() {
            _visible = true;
            _option = value;
            _answers[_currQuestionNumber] = value;
          });
        },
      ),
    );
  }

  Future<bool> _nextQuestion() async {
    _option = "";

    if (_currQuestionNumber < 3) {
      setState(() {
        _currQuestionNumber += 1;
        _visible = false;
      });
    } else {
      int score = 0;
      for (int i = 0; i < 4; i += 1) {
        print(_answers[i] + " - " + questions[2][i.toString()]);
        if (_answers[i] == questions[2][i.toString()]) {
          score += 1;
        }
      }
      final directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      print(path);
      File _localFile = File('$path/score.txt');
      _localFile.writeAsString('$score');
      return true;
    }
    if (_currQuestionNumber == 3) {
      setState(() {
        _visible = false;
        _nextButtonLabel = end;
      });
    }
    return false;
  }

  Future<bool> _goBack() async {
    if (_currQuestionNumber > 0) {
      setState(() {
        _currQuestionNumber -= 1;
        _option = _answers[_currQuestionNumber];
        _visible = true;
      });
      return false;
    } else {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ShowAlertDialog();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(quiz),
          backgroundColor: Colors.black,
        ),
        body: WillPopScope(
          onWillPop: () async {
            if (await _goBack() == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            }
            return false;
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.black87,
                    padding: EdgeInsets.all(14.0),
                    alignment: Alignment.center,
                    child: Text(questions[0][_currQuestionNumber.toString()],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold)),
                  )),
              Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.black12,
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _radioButton(optionA),
                        _radioButton(optionB),
                        _radioButton(optionC),
                        _radioButton(optionD)
                      ],
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Builder(
                    builder: (context) => Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: Visibility(
                        visible: _visible,
                        child: RaisedButton(
                          color: Theme.of(context).dividerColor,
                          onPressed: () {
                            print("Button pressed");
                            _nextQuestion().then((value) {
                              if (value == true) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyApp()),
                                );
                              }
                            });
                          },
                          child: Text(_nextButtonLabel),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
