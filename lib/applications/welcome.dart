import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
              child: Container(
                  padding: EdgeInsets.all(5),
                 
                  color: Colors.amber[500],
                  child: Row(children: [
                    Icon(Icons.warning, color: Color(0xff222222),),
                    Text(
                        ' Warning: You are on a pre-release build of dahliaOS. For your protection, this build has been airgapped. ',
                        overflow: TextOverflow.visible,
                        style:
                            TextStyle(fontSize: 15, color: Color(0xff222222)))
                  ]))),
                  Container(  margin: EdgeInsets.only(left: 0, right: 0, bottom: 0, top: 10),child:
                    new Image.asset(
                      
       'lib/images/logo-color.png',
        fit: BoxFit.fitHeight,
        
        width: 300,
       height:32,
      ),),
          Container(
              width:1.7976931348623157e+308,
              
              
              margin: EdgeInsets.only(left: 50, right: 50, bottom: 20, top: 0),
              child:  
              new ListView(
                shrinkWrap: true,
              children: <Widget>[
              
Text('Welcome to dahliaOS!',
                  style: TextStyle(fontSize: 25, color: Color(0xff000000))),
                  Text('dahliaOS Linux-based rolling v200531.1',
                  style: TextStyle(fontSize: 15, color: Color(0xff000000))),
Text('You are on the latest version of DahliaOS, powered by Linux. This is a pre-release, and not indicative of the final product. If you run into bugs, feel free to create an issue report on Github, Reddit, or Discord.',
                  style: TextStyle(fontSize: 15, color: Color(0xff000000))),
                   Text('Thank you to all of our supporters and developers for making this build possible.',
                  style: TextStyle(fontSize: 15, color: Color(0xff000000))),

              ]),
              ),
             
        ]));
  }
}



