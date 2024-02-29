//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'popular_vote.dart';

class Completed extends StatelessWidget {
  final int popularVotePoint;

  Completed({Key? key, required this.popularVotePoint}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              child: Text(
                '$popularVotePointポイント割り振り完了しました。',
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PopularVote()),
                );
              },
              child: const Text(
                '人気投票トップに戻る',
                style: TextStyle(color: Color.fromARGB(255, 46, 180, 117)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfirmVotingPage extends StatefulWidget {
  final int popularVoteCurrentPoint;

  ConfirmVotingPage({Key? key, required this.popularVoteCurrentPoint})
      : super(key: key);

  @override
  _ConfirmVotingPageState createState() => _ConfirmVotingPageState();
}

class _ConfirmVotingPageState extends State<ConfirmVotingPage> {
  int popularVotePoint = 0; //今から投票するポイント
  int popularVoteCurrentPoint = 80; //持っているポイント

  void changePoint(value) {
    setState(() {
      value ? popularVotePoint-- : popularVotePoint++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleek Circular Slider Example'),
      ),
      body:
          //政治家・入力分割
          Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromARGB(255, 255, 255, 255),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //政治家Widgetを書き込む
            Container(
              height: MediaQuery.of(context).size.height - 355,
              decoration: BoxDecoration(
//                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.all(
                  Radius.circular(13),
                ),
              ),
              child: voter(),
            ),
            //＋ー・円スライダー分割
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
//                border: Border.all(color: Colors.yellow),
//                color: Color.fromARGB(255, 249, 249, 249),
                  ),
              width: MediaQuery.of(context).size.width,
              height: 180,
              child: buildCircleSlider(),
            ),
          ],
        ),
      ),
    );
  }

  Widget voter() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color.fromARGB(255, 137, 198, 179),
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 36.0,
                  backgroundImage:
                      AssetImage('assets/images/politician_img.png'),
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
                    style: TextStyle(
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 90), // テキストとボタンの間隔
          ElevatedButton(
            onPressed: popularVotePoint == 0
                ? null
                : () {
                    //print('投票完了');
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Completed(
                        popularVotePoint: popularVotePoint,
                      ),
                    ));
                  },
            style: TextButton.styleFrom(
              fixedSize: Size(300, 100),
            ),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$popularVotePoint',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 85, 142, 124),
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(
                    text: 'Pt\n' '割り振る',
                    style: TextStyle(
                      color: Color.fromARGB(255, 137, 198, 179),
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCircleSlider() {
    double sangle = (180 / 100 * (100 - popularVoteCurrentPoint)) + 180;
    return Stack(
      alignment: AlignmentDirectional.center,
      //＋ーと円スライダー
      children: [
        //+-
//        Positioned(
//          top: 0,
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
//            children: <Widget>[
//              FloatingActionButton(
//                onPressed: popularVotePoint > 0
//                    ? () {
//                        changePoint(true);
//                      }
//                    : null,
//                child: const Icon(Icons.remove),
//              ),
//              FloatingActionButton(
//                onPressed: popularVotePoint < popularVoteCurrentPoint
//                    ? () {
//                        changePoint(false);
//                      }
//                    : null,
//                child: const Icon(Icons.add),
//              ),
//            ],
//          ),
//        ),

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
                progressBarColor: Color.fromARGB(255, 110, 160, 144),
              ),
            ),
            min: 0,
            max: 100,
            initialValue: 100 - popularVoteCurrentPoint * 1.0,
            innerWidget: (double value) {
              // スライダー内部にカスタムウィジェットを使用する（コールバックからスライダーの値を取得）
              return Container();
            },
          ),
        ),
        Positioned(
          bottom: -120,
          child: SleekCircularSlider(
            key: Key(popularVotePoint.toString()),
            appearance: CircularSliderAppearance(
              size: 260,
              startAngle: sangle,
              angleRange: 360 - sangle,
              animationEnabled: false,
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
            max: popularVoteCurrentPoint * 1.0,
            initialValue: popularVotePoint.toDouble(),
            onChange: (double value) {
              setState(() {
                popularVotePoint = value.round();
              });
            },
            innerWidget: (double value) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(
                  bottom: 43.0,
                  left: 180,
                ),
                child: Text(
                  '/' + popularVoteCurrentPoint.round().toString(),
                  style: TextStyle(fontSize: 20),
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
                handlerSize: 12,
              ),
              customColors: CustomSliderColors(
                trackColor: Color.fromARGB(255, 103, 139, 145),
                progressBarColor: Color.fromARGB(255, 89, 191, 184),
                hideShadow: true,
                dotColor: Color.fromARGB(255, 89, 191, 184),
              ),
              infoProperties: InfoProperties(bottomLabelText: "aiueo"),
            ),
            min: 0,
            max: popularVoteCurrentPoint * 1.0,
            initialValue: 0,
            onChange: (double value) {
              setState(() {
                popularVotePoint = value.round();
              });
            },
            onChangeStart: (double startValue) {
              // パンジェスチャーが開始されたときに始まる値を提供するコールバック
            },
            onChangeEnd: (double endValue) {
              // パンジェスチャーが終了したときに終了する値を提供するコールバック
            },
            innerWidget: (double value) {
              return Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 100.0),
                child: Text(
                  popularVotePoint.round().toString(),
                  style: TextStyle(
                    color: const Color.fromARGB(255, 89, 191, 184),
                    fontSize: 90,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
