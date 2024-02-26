import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../../provider/auth_service.dart';
import '../App.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}
class _ProfileData{
  String email = '';
  String emailAgain = '';
  String pass = '';
  String passAgain = '';
}
// 必須チェック
FormFieldValidator _requiredValidator(BuildContext context) => (val) => val.isEmpty ? "必須" : null;

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _ProfileData _data = _ProfileData();
  final _authService = AuthService();

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

  Future<void> _submit() async {
    // バリデートして問題なければ実行
    if (_formKey.currentState!.validate() & !passMismatch & !emailMismatch) {
      // TextFormField の onSavedを実行
      _formKey.currentState!.save();

      // キーボードを隠す（それぞれのonSavedに書いたほうがいいかも）
      _nameFocusNode.unfocus();
      _descriptionFocusNode.unfocus();
      
      try{
        await _authService.signIn(_data.email, _data.pass);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AppScreen())
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        setState(() {
          signInFailed = true;
        });
      }
      // debugPrint(FirebaseAuth.instance.currentUser?.uid);
      // ignore: use_build_context_synchronously
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
      appBar: AppBar(
      ),
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
                const SizedBox(height: 0,),
                // Container(
                //   height: 5,
                //   width: 200,
                //   decoration: BoxDecoration(
                //     color: const Color.fromARGB(255, 111, 111, 111),
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                // ),
                const SizedBox(height: 20,),
              ],
            ),
            const Text(
              'Signin',
              style: TextStyle(
                fontSize: 24,
                // fontWeight: FontWeight.bold,
                fontFamily: 'Murecho'
              ),
            ),
            Text(
              signInFailed ? 'password or email is wrong' : '',
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 5,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      //eメール入力フォーム(ノーマル)
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'email', border: OutlineInputBorder()),
                        validator: _requiredValidator(context),
                        maxLength: 100,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        focusNode: _nameFocusNode,
                        onSaved: (String? value) => _data.email = value!,
              
                        // focus当てとく
                        autofocus: true,
              
                        // focus移動
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
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
                            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility)
                            )
                        ),
                        validator: _requiredValidator(context),
                        maxLength: 10,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        focusNode: _descriptionFocusNode,
                        onSaved: (String? value) => _data.pass = value!,
                        // 複数行対応
                        // keyboardType: TextInputType.multiline,
                        // maxLines: null,
                      ),
                      const SizedBox(height: 5.0),
                      ElevatedButton(onPressed: _submit, child: const Text('Submit'))
                    ],
                  ),
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}