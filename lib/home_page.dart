import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:morsetorch/alphabet_page.dart';
import 'package:morsetorch/decoder_page.dart';
import 'package:torch_compat/torch_compat.dart';
import 'dart:core';
import 'constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textCtrl = new TextEditingController();

  int unit = 200;

  bool flashing = false;
  String flashingCode = '';
  double progress;

  /// 1. The length of a dot is 1 unit.
  /// 2. The length of a dash is 3 units.
  /// 3. The space between parts of the same letter is 1 unit.
  /// 4. The space between letters is 3 units.
  /// 5. The space between words is 7 units.
  ///
  /// Hello word => 5*(L, 3), 7, 4*(L, 3)
  void flashText() async {
    hideKeyboard();
    setState(() {
      flashing = true;
    });

    String text = textCtrl.text;
    List<String> words = text.split(' ');

    int max = text.length;
    setState(() {
      progress = 0;
    });

    for (int i = 0; i < words.length; i++) {
      await flashWord(words[i], max);
      if (i != words.length - 1) {
        await Future.delayed(Duration(milliseconds: 7 * unit), () {});
        setState(() {
          progress += (1 / max);
        });
      } else {
        setState(() {
          progress = 1;
        });
      }
    }
    setState(() {
      flashingCode = '';
      flashing = false;
      progress = null;
    });
  }

  Future flashWord(String word, int max) async {
    for (int i = 0; i < word.length; i++) {
      await flashLetter(morseCode[word[i]]);
      setState(() {
        progress += (1 / max);
      });
      if (i != word.length - 1) {
        await Future.delayed(Duration(milliseconds: 3 * unit), () {});
      }
    }
  }

  Future flashLetter(String code) async {
    setState(() {
      flashingCode = code;
    });
    for (int i = 0; i < code.length; i++) {
      if (code[i] == '•') {
        await TorchCompat.turnOn();
        await Future.delayed(Duration(milliseconds: unit), () async {
          await TorchCompat.turnOff();
        });
      } else if (code[i] == '–') {
        await TorchCompat.turnOn();
        await Future.delayed(Duration(milliseconds: 3 * unit), () async {
          await TorchCompat.turnOff();
        });
      } else {
        await Future.delayed(Duration(milliseconds: unit), () {});
      }
    }
    setState(() {
      flashingCode = '';
    });
  }

  void hideKeyboard() {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: hideKeyboard,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Morse Torch'),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(50, 10, 50, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: TextFormField(
                  controller: textCtrl,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (val) {
                    setState(() {});
                  },
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp('[A-Z0-9]'),),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter message',
                    suffixIcon: textCtrl.text.length > 0
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              textCtrl.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              progress != null
                  ? LinearProgressIndicator(
                      value: progress,
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Text(
                flashingCode,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              //Text('Speed slider', textAlign: TextAlign.center, style: TextStyle(color: Colors.lightBlue, fontSize: 18),),
              Slider(
                value: unit.toDouble(),
                onChanged: (double val) {
                  setState(() {
                    unit = val.toInt();
                  });
                },
                divisions: 18,
                min: 100,
                max: 1000,
                label: '1 unit: $unit ms',
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                color: Colors.lightBlue,
                textColor: Colors.white,
                child: Text('Flash'),
                onPressed: flashing ? null : flashText,
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                color: Colors.lightBlue,
                textColor: Colors.white,
                child: Text('View alphabet'),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AlphabetPage())),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                color: Colors.lightBlue,
                textColor: Colors.white,
                child: Text('Open decoder'),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DecoderPage())),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    TorchCompat.dispose();
    super.dispose();
  }
}
