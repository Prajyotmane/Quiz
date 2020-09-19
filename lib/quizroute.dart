import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

class ReadQuestions extends StatefulWidget {
  @override
  _ReadQuestionsState createState() => _ReadQuestionsState();
}

class _ReadQuestionsState extends State<ReadQuestions> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString("assets/questions.json"),
        builder: (context,snapshot){
          List questions = json.decode(snapshot.data.toString());
          if(questions==null){
            return MaterialApp(
              home: Scaffold(
                body: Text("Loading"),
              ),
            );
          }else{
            return QuizWindow(questions:questions);
          }

        });
  }
}



class QuizWindow extends StatefulWidget {
  List questions;
  QuizWindow({Key key, @required this.questions}):super(key:key);
  @override
  _QuizWindowState createState() => _QuizWindowState(questions);
}

class _QuizWindowState extends State<QuizWindow> {
  String _option = "";
  List questions;
  _QuizWindowState(this.questions);
  int _currQuestionNumber = 0;
  bool _visible = false;
  List<String> _answers = ["","","",""];
  String _nextButtonLabel = "Next";

  Widget _radioButton(String label) {
    return ListTile(
      title: Text(label+": "+questions[1][_currQuestionNumber.toString()][label],
      style: TextStyle(fontWeight: FontWeight.bold),),
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

  Future<bool> _nextQuestion() async{
    _option = "";

    if(_currQuestionNumber<3){
      setState(() {
        _currQuestionNumber+=1;
        _visible = false;
      });
    }else{
      int score = 0;
      for(int i=0;i<4;i+=1){
        print(_answers[i]+" - "+questions[2][i.toString()]);
        if(_answers[i]==questions[2][i.toString()]){
          score+=1;
        }
      }
      final directory = await getApplicationDocumentsDirectory();
      String path = directory.path;
      print(path);
      File _localFile = File('$path/score.txt');
      _localFile.writeAsString('$score');
     return true;
    }
    if(_currQuestionNumber==3){
      setState(() {
        _visible = false;
        _nextButtonLabel = "End";
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: WillPopScope(
          onWillPop: () async{
            if(_currQuestionNumber>0){
              setState(() {
                _currQuestionNumber-=1;
                _option = _answers[_currQuestionNumber];
                _visible = true;
              });
              return false;
            }else{
              return true;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Quiz"),
              backgroundColor: Colors.red,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(14.0),
                      alignment: Alignment.center,
                      child: Text(questions[0][_currQuestionNumber.toString()],
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _radioButton("a"),
                          _radioButton("b"),
                          _radioButton("c"),
                          _radioButton("d")
                        ],
                      ),
                    )),
                Expanded(
                    flex: 2,
                    child: Builder(
                      builder:(context)=> Container(
                        alignment: Alignment.center,
                        child: Visibility(
                          visible: _visible,
                          child: ElevatedButton(
                            onPressed: () {
                              print("Button pressed");
                              _nextQuestion().then((value){
                                if(value==true){
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

