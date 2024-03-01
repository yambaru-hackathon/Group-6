//import 'dart:math';
//import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

//local
import '../../components/app_bar.dart';
import 'determine_point.dart';

class VoterSelection extends StatefulWidget {
  final String id; // 表示用

  const VoterSelection({Key? key, required this.id}) : super(key: key);

  @override
  State<VoterSelection> createState() => _PopularVoteState(id: id);
}

class _PopularVoteState extends State<VoterSelection> {
  bool isRunning = false; //ボタンの時に変化する用
  int popularVotePoint = 0; //今から投票するポイント
  final int popularVoteCurrentPoint = 80; //持っているポイント
  final String id; // 表示用

  _PopularVoteState({required this.id});
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
      appBar: myAppBar(context, id),
      body:
          //政治家・入力分割
          Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //政治家Widgetを書き込む
          Container(
            height: MediaQuery.of(context).size.height - 355,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(13),
              ),
            ),
            child: buildLowersList(),
          ),
          //＋ー・円スライダー分割
          Expanded(
            child: buildCircleSlider(),
          ),
        ],
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
                trackColor: const Color.fromARGB(255, 103, 139, 145),
                hideShadow: true,
                progressBarColor: const Color.fromARGB(255, 137, 198, 179),
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
                    padding: const EdgeInsets.only(
                      bottom: 43.0,
                      left: 180,
                    ),
                    child: const Text(
                      '/100',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                      bottom: 200.0,
                      left: 0,
                    ),
                    child: const Text(
                      '残り',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(bottom: 100.0),
                    child: Text(
                      popularVoteCurrentPoint.round().toString(),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 89, 191, 184),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          for (int i = 0; i < 10; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ConfirmVotingPage(
                      popularVoteCurrentPoint: popularVoteCurrentPoint,
                    ),
                  ));
                },
                child: Row(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromARGB(255, 183, 230, 215),
                          width: 2,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 36.0,
                        backgroundImage:
                            AssetImage('assets/images/politician_img.png'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 50,
                          ),
                          const Text(
                            'Texttttttttttttttt',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Container(
                            width: 150,
                            decoration: const BoxDecoration(
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
      ),
    );
  }
}
