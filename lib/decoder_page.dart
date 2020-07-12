import 'package:flutter/material.dart';
import 'package:morsetorch/constants.dart';

class DecoderPage extends StatefulWidget {
  @override
  _DecoderPageState createState() => _DecoderPageState();
}

class _DecoderPageState extends State<DecoderPage> {
  String code = '';
  String decodedMessage = '';
  List<int> log = [];

  void decode() {
    if (code.length == 0) {
      setState(() {
        decodedMessage = '';
      });
      return;
    }
    List<String> words = code.split('       ');
    decodedMessage = '';

    for (int i = 0; i < words.length; i++) {
      List<String> letters = words[i].split('   ');
      for (int j = 0; j < letters.length; j++) {
        String letter = letters[j].replaceAll(' ', '');
        decodedMessage += morseCode.keys.firstWhere(
            (k) => morseCode[k].replaceAll(' ', '') == letter,
            orElse: () => '?');
      }
      decodedMessage += ' ';
    }

    setState(() {});
  }

  /// 0 -> '• '
  /// 1 -> '– '
  /// 2 -> '   '
  /// 3 -> '       '
  void appendSign(int sign) {
    log.add(sign);
    if (sign == 0) {
      setState(() {
        code += '• ';
      });
    } else if (sign == 1) {
      setState(() {
        code += '– ';
      });
    } else if (sign == 2) {
      setState(() {
        code += '   ';
      });
    } else if (sign == 3) {
      setState(() {
        code += '       ';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Decoder'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Morse code'),
            Text(code),
            Divider(),
            SizedBox(
              height: 10,
            ),
            Text('Decoded message'),
            Text(decodedMessage),
            Divider(),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: Colors.lightBlue,
              textColor: Colors.white,
              child: Text('Decode message'),
              onPressed: decode,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    child: Text(
                      '•',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => appendSign(0),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    child: Text(
                      '–',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => appendSign(1),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    child: Text(
                      'Short pause',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => appendSign(2),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    child: Text(
                      'Long pause',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => appendSign(3),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    child: Text(
                      'Clear one',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      int last = log.last;
                      log.removeLast();
                      setState(() {
                        if (last == 0 || last == 1) {
                          code = code.substring(0, code.length - 2);
                        } else if (last == 2) {
                          code = code.substring(0, code.length - 3);
                        } else if (last == 3) {
                          code = code.substring(0, code.length - 7);
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: RaisedButton(
                    color: Colors.lightBlue,
                    textColor: Colors.white,
                    child: Text(
                      'Clear all',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        code = '';
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
