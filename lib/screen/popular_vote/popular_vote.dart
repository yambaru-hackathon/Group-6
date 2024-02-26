//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PopularVote extends StatefulWidget {
  const PopularVote({Key? key}) : super(key: key);

  @override
  State<PopularVote> createState() => _PopularVoteState();
}

class _PopularVoteState extends State<PopularVote> {
  bool isRunning = false; //ボタンの時に変化する用
  int popularVotePoint = 5; //今から投票するポイント
  final int popularVoteCurrentPoint = 50; //持っているポイント

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
    double sangle = (180 / 100 * popularVoteCurrentPoint) + 180;
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleek Circular Slider Example'),
      ),
      body:
          //政治家・入力分割
          Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            //政治家Widgetを書き込む
            Container(
              height: MediaQuery.of(context).size.height - 400,
              color: Colors.green,
            ),
            //＋ー・円スライダー分割
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow),
              ),
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Stack(
                alignment: AlignmentDirectional.center,
                //＋ーと円スライダー
                children: [
                  //+-
//                  Positioned(
//                    child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceAround,
//                      children: <Widget>[
//                        FloatingActionButton(
//                          onPressed: () {
//                            changePoint(true);
//                          },
//                          child: const Icon(Icons.remove),
//                        ),
//                        Text('$popularVotePoint'),
//                        FloatingActionButton(
//                          onPressed: () {
//                            changePoint(false);
//                          },
//                          child: const Icon(Icons.add),
//                        ),
//                      ],
//                    ),
//                  ),
                  Positioned(
                    bottom: -120,
                    child: SleekCircularSlider(
                      key: Key(popularVotePoint.toString()),
                      appearance: CircularSliderAppearance(
                        size: 260,
                        startAngle: sangle,
                        angleRange: sangle - 180,
                        animationEnabled: false,
                        infoProperties: InfoProperties(
                          topLabelText: popularVotePoint.toString(),
                          mainLabelStyle: null,
                        ),
                        customWidths: CustomSliderWidths(
                          trackWidth: 3,
                          progressBarWidth: 5,
                          handlerSize: 0,
                        ),
                        customColors: CustomSliderColors(
                            trackColor: Color.fromARGB(255, 0, 30, 36),
                            hideShadow: true,
                            progressBarColors: [
                              Color.fromARGB(255, 18, 123, 114),
                              Color.fromARGB(255, 40, 97, 147)
                            ]),
                      ),
                      min: 0,
                      max: 100 - popularVoteCurrentPoint * 1.0,
                      initialValue: popularVotePoint.toDouble(),
                      onChange: (double value) {
                        setState(() {
                          popularVotePoint = value.round();
                        });
                      },
                    ),
                  ),
                  Positioned(
                    bottom: -120,
                    child: SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        size: 260,
                        startAngle: 180,
                        angleRange: 180,
                        customWidths: CustomSliderWidths(
                          trackWidth: 10,
                          progressBarWidth: 5,
                          handlerSize: 0,
                        ),
                        customColors: CustomSliderColors(
                            trackColor: const Color.fromARGB(0, 255, 255, 255),
                            hideShadow: true,
                            progressBarColors: [
                              Colors.red,
                              Color.fromARGB(255, 221, 0, 255)
                            ]),
                      ),
                      min: 0,
                      max: 100,
                      initialValue: 100 - popularVoteCurrentPoint * 1.0,
                      innerWidget: (double value) {
                        return Text(
                          popularVoteCurrentPoint.toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: -140,
                    child: SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        size: 300,
                        startAngle: 180,
                        angleRange: 180,
                        customWidths: CustomSliderWidths(
                          trackWidth: 10,
                          progressBarWidth: 10,
                          handlerSize: 9,
                        ),
                        customColors: CustomSliderColors(
                          trackColor: Color.fromARGB(255, 103, 139, 145),
                          progressBarColors: [
                            Color.fromARGB(255, 86, 255, 241),
                            Color.fromARGB(255, 84, 229, 255),
                          ],
                          dotColor: Colors.yellow,
                        ),
                        infoProperties:
                            InfoProperties(bottomLabelText: "aiueo"),
                      ),
                      min: 0,
                      max: popularVoteCurrentPoint * 1.0,
                      initialValue: 0,
                      onChange: (double value) {
                        setState(() {
                          popularVotePoint = value.round();
                          print(popularVotePoint);
                        });
                      },
                      onChangeStart: (double startValue) {
                        // パンジェスチャーが開始されたときに始まる値を提供するコールバック
                      },
                      onChangeEnd: (double endValue) {
                        // パンジェスチャーが終了したときに終了する値を提供するコールバック
                      },
                      innerWidget: (double value) {
                        // スライダー内部にカスタムウィジェットを使用する（コールバックからスライダーの値を取得）
                        return Text(
                          value.round().toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
