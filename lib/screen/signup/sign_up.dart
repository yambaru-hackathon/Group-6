import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../../provider/auth_service.dart';
import '../App.dart';
import 'enter_personal_data.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _ProfileData {
  String email = '';
  String emailAgain = '';
  String pass = '';
  String passAgain = '';
}

// 必須チェック
FormFieldValidator _requiredValidator(BuildContext context) =>
    (val) => val.isEmpty ? "必須" : null;

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _ProfileData _data = _ProfileData();
  // 入力の重複調べる変数
  TextEditingController emailin = TextEditingController();
  TextEditingController emailAgainin = TextEditingController();
  TextEditingController passin = TextEditingController();
  TextEditingController passAgainin = TextEditingController();

  // 入力のフォーカス用変数
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _descriptionFocusNode = FocusNode();
  FocusNode _nameFocusNodeAgain = FocusNode();
  FocusNode _descriptionFocusNodeAgain = FocusNode();

  // 入力の重複用ブール
  bool passMismatch = false;
  bool emailMismatch = false;

  // signIn失敗のブール
  bool signInFailed = false;

  // 入力の表示非表示
  bool _isObscure = true;
  bool _isObscureAgain = true;

  bool email_Wrongformat = false;
  bool pass_Wrongformat = false;

  Future<void> _submit() async {
    // バリデートして問題なければ実行
    if (_formKey.currentState!.validate() & !passMismatch & !emailMismatch) {
      // TextFormField の onSavedを実行
      _formKey.currentState!.save();

      // キーボードを隠す（それぞれのonSavedに書いたほうがいいかも）
      _nameFocusNode.unfocus();
      _descriptionFocusNode.unfocus();
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _data.email,
          password: _data.pass,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'lowerHouseVote': '',
          'myNumber': '',
          'postcode': '',
          'prefecture': '',
          'senkyokuNum': ''
        });
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => EnterPersonalData(isInitText: true, isFromAppScreen: false,)));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          print('指定したメールアドレスは登録済みです');
        } else if (e.code == 'invalid-email') {
          print('メールアドレスのフォーマットが正しくありません');

          setState(() {
            email_Wrongformat = true;
          });
        } else if (e.code == 'operation-not-allowed') {
          print('指定したメールアドレス・パスワードは現在使用できません');
        } else if (e.code == 'weak-password') {
          print('パスワードは６文字以上にしてください');

          setState(() {
            pass_Wrongformat = true;
          });
        }

        /// その他エラー
        else {
          print('アカウント作成エラー: ${e.code}');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _nameFocusNodeAgain = FocusNode();
    _descriptionFocusNodeAgain = FocusNode();

    signInFailed = false;
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _nameFocusNodeAgain.dispose();
    _descriptionFocusNodeAgain.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              //アイコン用Column
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 111, 111, 111),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  height: 0,
                ),
                // Container(
                //   height: 5,
                //   width: 200,
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(255, 111, 111, 111),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            const Text(
              'SignUp',
              style: TextStyle(
                  fontSize: 24,
                  // fontWeight: FontWeight.bold,
                  fontFamily: 'Murecho'),
            ),
            Text(
              signInFailed ? 'password or email is wrong' : '',
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        //eメール入力フォーム(ノーマル)
                        TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'email', border: OutlineInputBorder()),
                          validator: _requiredValidator(context),
                          maxLength: 100,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          focusNode: _nameFocusNode,
                          onSaved: (String? value) => _data.email = value!,

                          // focus当てとく
                          autofocus: true,

                          // focus移動
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode),

                          // 重複用
                          controller: emailin,
                        ),
                        const SizedBox(height: 5.0),
                        //eメール入力フォーム(アゲイン)
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'email Again',
                            border: OutlineInputBorder(),
                            errorText:
                                emailMismatch ? 'email do not match' : null,
                          ),
                          validator: _requiredValidator(context),
                          maxLength: 100,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          focusNode: _nameFocusNodeAgain,
                          onSaved: (String? value) => _data.emailAgain = value!,
                          // focus当てとく
                          autofocus: true,

                          // focus移動
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode),

                          // 重複用
                          controller: emailAgainin,

                          onChanged: (value) {
                            setState(() {
                              emailMismatch = emailin.text != value;
                            });
                          },
                        ),
                        Visibility(
                          child: Text('Please @ add'),
                          visible: email_Wrongformat, // ここで隠すか表示するかを選択する
                        ),

                        const SizedBox(height: 16.0),
                        //パスワード入力フィールド(ノーマル)
                        TextFormField(
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                              labelText: 'password',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                  icon: Icon(_isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility))),
                          validator: _requiredValidator(context),
                          maxLength: 10,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          focusNode: _descriptionFocusNode,
                          onSaved: (String? value) => _data.pass = value!,
                          // 複数行対応
                          // keyboardType: TextInputType.multiline,
                          // maxLines: null,

                          // 重複用
                          controller: passin,
                        ),
                        const SizedBox(height: 5.0),
                        //パスワード入力フィールド(アゲイン)
                        TextFormField(
                          obscureText: _isObscureAgain,
                          decoration: InputDecoration(
                            labelText: 'password Again',
                            border: const OutlineInputBorder(),
                            errorText:
                                passMismatch ? 'password do not match' : null,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscureAgain = !_isObscureAgain;
                                  });
                                },
                                icon: Icon(_isObscureAgain
                                    ? Icons.visibility_off
                                    : Icons.visibility)),
                          ),
                          validator: _requiredValidator(context),
                          maxLength: 10,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                          focusNode: _descriptionFocusNodeAgain,
                          onSaved: (String? value) => _data.passAgain = value!,
                          // 複数行対応
                          // keyboardType: TextInputType.multiline,
                          // maxLines: null,

                          // 重複用
                          controller: passAgainin,

                          onChanged: (value) {
                            setState(() {
                              passMismatch = passin.text != value;
                            });
                          },
                        ),
                        Visibility(
                          child: Text('Please 6 or more characters'),
                          visible: pass_Wrongformat, // ここで隠すか表示するかを選択する
                        ),
                        const SizedBox(height: 5.0),
                        ElevatedButton(
                            onPressed: _submit, child: const Text('Submit')),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
