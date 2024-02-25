import 'package:firebase_auth/firebase_auth.dart';

/// 通信の流れをまとめておくサービスクラス
class AuthService {
  /// サインイン
  Future<void> signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: 'ここにメールアドレス',
      password: 'ここにパスワード',
    );
  }

  /// サインアウト
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}