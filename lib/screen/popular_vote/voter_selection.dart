//import 'dart:math';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'determine_point.dart';

class voterSelection extends StatefulWidget {
  final String id; // 表示用
  final String page; //いつかデータベースに入れるとき用

  const voterSelection({Key? key, required this.id, required this.page})
      : super(key: key);

  @override
  State<voterSelection> createState() => _PopularVoteState(id: id, page: page);
}

class _PopularVoteState extends State<voterSelection> {
  bool isRunning = false; //ボタンの時に変化する用
  int popularVotePoint = 0; //今から投票するポイント
  final int popularVoteCurrentPoint = 80; //持っているポイント
  final String id; // 表示用
  final String page; //いつかデータベースに入れるとき用

  _PopularVoteState({required this.id, required this.page});
  //int _counter = 0;

  //void _incrementCounter() {
  //  setState(() {
  //    _counter++;
  //  });
  //}

  void toggleSwitch() {
    setState(() {
      isRunning = !isRunning;
    });
  }

  void changePoint(value) {
    setState(() {
      value ? popularVotePoint-- : popularVotePoint++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('人気投票'),
      ),
      body:
          //政治家・入力分割
          Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromARGB(255, 255, 255, 255),
        child: ClipRect(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: id,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 85, 142, 124),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: 'ランキング',
                        style: TextStyle(
                          color: Color.fromARGB(255, 137, 198, 179),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              //政治家Widgetを書き込む
              Container(
                height: MediaQuery.of(context).size.height - 355,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(
                    Radius.circular(13),
                  ),
                ),
                child: buildLowersList(),
              ),
              //＋ー・円スライダー分割
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
//                border: Border.all(color: Colors.yellow),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                width: MediaQuery.of(context).size.width,
                height: 150,
                child: buildCircleSlider(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCircleSlider() {
    return Stack(
      alignment: AlignmentDirectional.center,
      //＋ーと円スライダー
      children: [
        Positioned(
          bottom: -120,
          child: SleekCircularSlider(
            appearance: CircularSliderAppearance(
              size: 260,
              startAngle: 180,
              angleRange: 180,
              customWidths: CustomSliderWidths(
                trackWidth: 3,
                progressBarWidth: 5,
                handlerSize: 0,
              ),
              customColors: CustomSliderColors(
                trackColor: Color.fromARGB(255, 103, 139, 145),
                hideShadow: true,
                progressBarColor: Color.fromARGB(255, 137, 198, 179),
              ),
            ),
            min: 0,
            max: 100,
            initialValue: 100 - popularVoteCurrentPoint * 1.0,
            innerWidget: (double value) {
              return Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      bottom: 43.0,
                      left: 180,
                    ),
                    child: Text(
                      '/100',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      bottom: 200.0,
                      left: 0,
                    ),
                    child: Text(
                      '残り',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 100.0),
                    child: Text(
                      popularVoteCurrentPoint.round().toString(),
                      style: TextStyle(
                        color: const Color.fromARGB(255, 89, 191, 184),
                        fontSize: 90,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildLowersList() {
    return ListView(
      children: <Widget>[
        for (int i = 0; i < 6; i++)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ConfirmVotingPage(
                  popularVoteCurrentPoint: popularVoteCurrentPoint,
                ),
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
                      border: Border.all(
                        color: Color.fromARGB(255, 183, 230, 215),
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 36.0,
                      backgroundImage:
                          AssetImage('assets/images/politician_img.png'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 50,
                        ),
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
                  //CheckBox(),
//                  Center(
//                    child: CheckboxWidget(),
//                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
