import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import '../App.dart';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';

//firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final users = FirebaseFirestore.instance.collection('users');

final ProfileData _data = ProfileData();
final myNumberController = TextEditingController();
final postcodeController = TextEditingController();
bool isSaveText = false;


enum CameraPermissionStatus {
  granted,
  denied,
  restricted,
  limited,
  permanentlyDenied
}

class CameraPermissionsHandler {
  Future<bool> get isGranted async {
    final status = await Permission.camera.status;
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.denied:
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:
        return false;
      default:
        return false;
    }
  }

  Future<CameraPermissionStatus> request() async {
    final status = await Permission.camera.request();
    switch (status) {
      case PermissionStatus.granted:  //許可されている状態
        return CameraPermissionStatus.granted;
      case PermissionStatus.denied:   //拒否されている状態
        return CameraPermissionStatus.denied;
      case PermissionStatus.limited:  //一時的に制限されている
        return CameraPermissionStatus.limited;
      case PermissionStatus.restricted: //
        return CameraPermissionStatus.restricted;
      case PermissionStatus.permanentlyDenied:
        return CameraPermissionStatus.permanentlyDenied;
      default:
        return CameraPermissionStatus.denied;
    }
  }
}


Future<void> bulidCamera() async {
  // main 関数内で非同期処理を呼び出すための設定
  WidgetsFlutterBinding.ensureInitialized();
  // デバイスで使用可能なカメラのリストを取得
  final cameras = await availableCameras();
  // 利用可能なカメラのリストから特定のカメラを取得
  final firstCamera = cameras.first;

  CameraPermissionStatus permissionStatus = await CameraPermissionsHandler().request();
  if (permissionStatus == CameraPermissionStatus.granted){
    runApp(MyApp(camera: firstCamera));
  }
  else {
    print('カメラの使用を許可してください');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera Example',
      theme: ThemeData(),
      home: TakePictureScreen(camera: camera),
    );
  }
}


/// 写真撮影画面
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      // カメラを指定
      widget.camera,
      // 解像度を定義
      ResolutionPreset.medium,
    );

    // コントローラーを初期化
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // ウィジェットが破棄されたら、コントローラーを破棄
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return CameraPreview(_controller);
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 写真を撮る
          final image = await _controller.takePicture();
          // 表示用の画面に遷移
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DisplayPictureScreen(imagePath: image.path),
              fullscreenDialog: true,
            ),
          );
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// 撮影した写真を表示する画面
class DisplayPictureScreen extends StatelessWidget {
  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: Center(
        child: Column(
          children: [
            Image.file(File(imagePath)),
            ElevatedButton(
              onPressed: () {
                //onpressed,
                 Navigator.pop(context);
              },
              child: Text('取り直す'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EnterPersonalData()),
                );
              },
              child: Text('確認した'),
            ),
          ],
        ),
      ),
    );
  }
}

// 最初の画面
class EnterPersonalData extends StatefulWidget {
  @override
  State<EnterPersonalData> createState() => EnterPersonalDataState();
}

class ProfileData {
  String postcode = '';
  String myNumber = '';
}

FormFieldValidator _requiredValidator(BuildContext context) =>
    (val) => val.isEmpty ? "必須" : null;

class EnterPersonalDataState extends State<EnterPersonalData> {
  // FormField
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final uid = FirebaseAuth.instance.currentUser?.uid;

    // 郵便番号
  String postcode = '';
  String postcodeFirst = '';

  //選挙区コード
  String prefectureCode = '';
  String districtNum = '';

  // 選挙区
  String prefectureText = '';
  String hireiDistrictText = '';
  String electoralDistrictText = '';

  Future<void> loadJsonAsset() async {
    final String hireiJsonString =
        await rootBundle.loadString('assets/json/hirei.json');
    final dynamic hireiJsonResponse = json.decode(hireiJsonString);
    final String postalJsonString =
        await rootBundle.loadString('assets/json/postal2senkyoku.light.json');
    final dynamic postalJsonResponse = json.decode(postalJsonString);
    setState(() {
      postcodeFirst = postcodeController.text.substring(0, 3);
      try {
        if (postalJsonResponse[postcodeFirst] != null) {
          prefectureCode = postalJsonResponse[postcodeFirst]['p'];
          districtNum = postalJsonResponse[postcodeFirst]['s'];
        } else {
          prefectureCode = postalJsonResponse[postcodeController.text]['p'];
          districtNum = postalJsonResponse[postcodeController.text]['s'];
        }
        prefectureText = hireiJsonResponse[prefectureCode]['prefecture'];
        hireiDistrictText = hireiJsonResponse[prefectureCode]['region'];

        electoralDistrictText = '$prefectureText $districtNum区';
      } catch (e) {
        prefectureText = 'エラー';
        hireiDistrictText = 'エラー';
        electoralDistrictText = 'エラー';
      }
    });

    debugPrint(prefectureText);
    debugPrint(hireiDistrictText);
    debugPrint(electoralDistrictText);
  }

  Future<void> submit(BuildContext context) async {
    await loadJsonAsset();
    await users.doc(uid).update({
      'postcode': postcodeController.text,
      'myNumber': myNumberController.text,
      'prefecture': prefectureText,
      'senkyokuNum': districtNum,
    });
  }

  @override
  void dispose() {
    debugPrint(postcodeController.text);
    debugPrint(myNumberController.text);
    if (!isSaveText) {
      myNumberController.dispose();
      postcodeController.dispose();
    }
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(myNumberController.text);
    debugPrint(postcodeController.text);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                '投票を行うには、本人認証が必要です。\n今はスキップして、あとで行うこともできます。\nこれらの情報はあとから変更することができません。',
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24),
            // 情報入力フィールド
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 240,
                      height: 90,
                      child: TextFormField(
                        controller: postcodeController,
                        decoration: InputDecoration(
                          labelText: '郵便番号',
                          hintText: '0000000',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLength: 7,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        validator: _requiredValidator(context),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    // マイナンバー
                    SizedBox(
                      width: 240,
                      height: 90,
                      child: TextFormField(
                        controller: myNumberController,
                        decoration: InputDecoration(
                          labelText: 'マイナンバー',
                          hintText: '000000000000',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        maxLength: 12,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        validator: _requiredValidator(context),
                        onSaved: (String? value) => _data.myNumber = value!,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // カメラ
            Container(
              padding: EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  GestureDetector(
                    //this
                    onTap: () async {
                      print('tapped');
                      isSaveText = await true;
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TakePictureScreen()), // カメラ情報を渡す
                      );*/
                      bulidCamera();
                    },
                    child: Container(
                      width: 240,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color.fromARGB(255, 146, 146, 146),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: 36,
                          color: Color.fromARGB(255, 146, 146, 146),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 登録ボタン
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 137, 198, 179),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(45),
              ),
              child: SizedBox(
                width: 150,
                height: 50,
                child: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await submit(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AppScreen()),
                      );
                    }
                  },
                  child: Text(
                    '登録完了',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 137, 198, 179),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: SizedBox(
                width: 100,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AppScreen()),
                    );
                  },
                  child: Text(
                    'あとで',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
