import 'package:flutter/material.dart';
//import '../article/article.dart';

class Politician extends StatefulWidget {
  const Politician({super.key});

  @override
  State<Politician> createState() => _PoliticianState();
}

class _PoliticianState extends State<Politician> {
  // int _counter = 0;

  void _incrementCounter() {
    // setState(() {
    //   _counter++;
    // });
  }

  final String longText =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
    'nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in '
    'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla '
    'pariatur. Excepteur sint occaecat cupidatat non proident, sunt in '
    'culpa qui officia deserunt mollit anim id est laborum.'
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
    'nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in '
    'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla '
    'pariatur. Excepteur sint occaecat cupidatat non proident, sunt in '
    'culpa qui officia deserunt mollit anim id est laborum.'
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
    'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
    'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
    'nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in '
    'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla '
    'pariatur. Excepteur sint occaecat cupidatat non proident, sunt in '
    'culpa qui officia deserunt mollit anim id est laborum.';
  Widget _myImg(){
    return FittedBox(
      fit: BoxFit.contain,
      child:
      Image.asset('assets/images/politician_img.png',),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('候補者情報', textAlign: TextAlign.center,),
        actions: [
          IconButton(
            icon: Icon(Icons.dehaze_rounded),
            onPressed: () => {},
            ),
        ],
      ),
      body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Column(
                        children: [ //下線ひきたい
                          Padding(
                            padding: EdgeInsets.only(top: 32, bottom: 20),
                            child: Text(
                              'party name', 
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                          ),
                          Text(
                            'politician name', 
                            style: TextStyle(
                              fontSize: 20
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          //color: Color.fromARGB(255, 220, 220, 220),
                          border: Border.all(
                            color: Color.fromARGB(221, 151, 151, 151),
                            width: 3,
                          ),
                        ),
                      child: Container(  //画像
                        padding: const EdgeInsets.all(28),
                        child: _myImg(),
                        //width: 50,
                        height: 120,  //なんか小さくなっちゃう
                      ),
                      
                      
                    ),
                  ),
                ],
              ),
            ),
            // 下半分のwidget 
            Center(
              
              child: Container(
                //color: Color.fromARGB(255, 230, 230, 230),
                width: 320,
                height: 430,
                padding: EdgeInsets.all(20.10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Color.fromARGB(255, 255, 255, 255),
                  border: Border.all(
                    color: Color.fromARGB(221, 180, 180, 180),
                    width: 5,
                  )
                ),
                child: SingleChildScrollView(
                  child: Text(longText),
                ),
              ),
            ),
          ],
      ),
      bottomNavigationBar: BottomAppBar(),
    );

  }
}
//      body: Center(
//        child: Stack(
//          children: <Widget>[
            /*Stack(
              alignment: Alignment.topLeft,
              children: <Widget>[
                Container(  //ID
                  alignment: AlignmentDirectional.topStart,
                  width: 180,
                  height: 200,
                  color: Colors.pink[50],
                  child: Row(
                    children: [
                      Text(
                        'political party id',
                      ),
                      Text(
                        'politician name',
                      ),
                    ],
                    
                  ),
                ),
                
                Container(  //画像
                  alignment: AlignmentDirectional.topEnd,
                  width: 200,
                  height: 180,
                  color: Colors.green[50],
                ),
              ],
            ),*/
              /*Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('political party id'),
                    ),
                  ],
              ),*/
              /*Align(
                alignment: Alignment.centerLeft,
                child: Text('politician name'),
              ),*/

              /*Container(
                padding: const EdgeInsets.all(28),
                child: _myImg(),
                width: 200,
                height: 200,
              ),*/

              //記事画面へ
              /*
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Article())
                  );
                },
                child: const Text('記事A'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Article())
                  );
                },
                child: const Text('記事B'),
              ),
              */
            
//          ],
//        ),
//      ),
      
      


  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is politician screen.',
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Article())
                );
              },
              child: const Text('to article screen')
            )
          ],
        ),
      ),
    );
  }
  */


//test