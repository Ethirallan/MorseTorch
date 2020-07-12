import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:morsetorch/constants.dart';

class AlphabetPage extends StatelessWidget {

  final List codes = morseCode.entries.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Morse alphabet'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: AnimationLimiter(
          child: GridView.builder(
            itemCount: codes.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 6, mainAxisSpacing: 6,),
            itemBuilder: (BuildContext context, int index) {
              var code = codes[index];
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: Duration(milliseconds: 500),
                columnCount: 3,
                child: ScaleAnimation(
                  child: FadeInAnimation(
                    child: Card(
                      elevation: 3,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(code.key, style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.lightBlue,),),
                            SizedBox(height: 10,),
                            Text(code.value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}