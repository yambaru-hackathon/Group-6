import 'package:flutter/material.dart';

class LowerHouse extends StatefulWidget {
  const LowerHouse({super.key});

  @override
  State<LowerHouse> createState() => _LowerHouseState();
}

class Completed extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Container(
          child: Text(
            '投票ありがとうございました',
          ),
        ),

      ),
    );
  }
}

class ConfirmVotingPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('next page'),
      ),

body: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 10),
        Container(
          padding: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Color.fromARGB(255, 137, 198, 179), width: 3,),
          ),
          child: CircleAvatar(
            radius: 36.0,
            backgroundImage: AssetImage('assets/images/politician_img.png'),
          ),
        ),
        SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Texttttttttttttttt',
              style: TextStyle(fontSize: 16.0),
            ),
            Container(
              width: 150,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 137, 198, 179),
                    width: 5,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'よろしいですか？',
              style: TextStyle(fontSize: 12),
            ),
            Text(
              '変更、再投票はできません',
              style: TextStyle(fontSize: 8,),
            ),
          ],
        ),
      ],
    ),
    SizedBox(height: 20), // テキストとボタンの間隔
    ElevatedButton(
      onPressed: () {
        //print('投票完了');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Completed(),
        ));
      }, 
      child: Text('投票する'),
    ),
  ],
),

    );
  }
}

/*class CheckBox extends StatefulWidget{
  @override
  _CheckboxState createState() => _CheckboxState();
}*/

/*class _CheckboxState extends State<CheckBox> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text('Checkbox'),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}*/
class CheckboxWidget extends StatefulWidget {
  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

class _LowerHouseState extends State<LowerHouse> {
  // int _counter = 0;

  void _incrementCounter() {
    // setState(() {
    //   _counter++;
    // });
  }

  /*Widget buildLowersList() {
    return Column(
      children: <Widget>[
        for (int i = 0; i < 3; i++)
      
        Expanded(
          child: ListView(
            children: [
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ConfirmVotingPage(),
                  ));
                },
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(width: 10),
                      Container(
                        //margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Color.fromARGB(255, 183, 230, 215), width: 3,),
                        ),
                        child: CircleAvatar(
                          radius: 36.0,
                          backgroundImage: AssetImage('assets/images/politician_img.png'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 50,),
                            Text(
                              'Texttttttttttttttt',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Container(
                              width: 150,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromARGB(255, 137, 198, 179),
                                    width: 5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Image.asset(
                        'assets/images/politician_img.png',
                        width: 24.0,
                        height: 24.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
*/

  Widget buildLowersList() {
    return ListView(
      children: <Widget>[
        for (int i = 0; i < 3; i++)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ConfirmVotingPage(),
              ));
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Color.fromARGB(255, 183, 230, 215), width: 3,),
                    ),
                    child: CircleAvatar(
                      radius: 36.0,
                      backgroundImage: AssetImage('assets/images/politician_img.png'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(width: 50,),
                        Text(
                          'Texttttttttttttttt',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Container(
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color.fromARGB(255, 137, 198, 179),
                                width: 5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  //CheckBox(),
                  Center(
                    child: CheckboxWidget(),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: buildLowersList(),
          /*
          Expanded(
            child: ListView(
              children: [
                buildLowersList(),
                // ひとつめのコンテンツ
                /*
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ConfirmVotingPage(),
                    ));
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SizedBox(width: 10),
                        Container(
                          //margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Color.fromARGB(255, 183, 230, 215), width: 3,),
                          ),
                          child: CircleAvatar(
                            radius: 36.0,
                            backgroundImage: AssetImage('assets/images/politician_img.png'),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(width: 50,),
                              Text(
                                'Texttttttttttttttt',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromARGB(255, 137, 198, 179),
                                      width: 5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Image.asset(
                          'assets/images/politician_img.png',
                          width: 24.0,
                          height: 24.0,
                        ),
                      ],
                    ),
                  ),
                ),*/
              ],
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                // いくつめのコンテンツ
              ],
            ),
          ),
          */
        
      
    );
  }
}

/*
body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is lower house election screen.',
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const EnterPersonalData())
                // );
              },
              child: const Text('to election list')),
          ],
        ),
      ), */