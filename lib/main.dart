import 'package:flutter/material.dart';

///////////////////////////////
// ① Main：Flutterアプリもmain()からコードが実行されます。
// `void main() => runApp(MyApp());` でも意味は同じです。
void main() {
  return runApp(MyApp());
}

///////////////////////////////
// ② アプリの基盤：アプリのテーマやスタイルを設定する。その上のページを追加していく。
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // MaterialAppという形式のアプリを作成
    return MaterialApp(
      theme: ThemeData(), // アプリのテーマカラーなど詳細を入力
      home: MyHomePage(), // メインページを作成
    );
  }
}

///////////////////////////////
// ③ アプリのメインページ（固定）
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Menu Bar"),
        ),
        body: Center(
          child: ListView(
            children: [
              TodoCardWidget(label: "option1"),
              TodoCardWidget(label: "option2"),
              TodoCardWidget(label: "option3"),
              TodoCardWidget(label: "option4")
            ],
          ),
        ));
  }
}

class TodoCardWidget extends StatelessWidget {
  final String label;

  TodoCardWidget({Key? key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Checkbox(value: false, onChanged: null),
              Text(this.label),
            ],
          ),
        ));
  }
}