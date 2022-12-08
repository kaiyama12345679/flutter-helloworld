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
class MyHomePage extends StatefulWidget {
  List<Widget> cards = [];
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var cnt = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu Bar")),
      body: Center(
          child: ListView.builder(
        itemCount: widget.cards.length,
        itemBuilder: (BuildContext context, int index) {
          return widget.cards[index];
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            widget.cards.add(TodoCardWidget(label: "${cnt}"));
            if (cnt == 10) {
              cnt = 0;
              widget.cards = [];
            }
            cnt += 1;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoCardWidget extends StatefulWidget {
  final String label;
  var state = false;

  TodoCardWidget({Key? key, required this.label}) : super(key: key);

  @override
  _TodoCardWidgetState createState() => _TodoCardWidgetState();
}

class _TodoCardWidgetState extends State<TodoCardWidget> {
  void _changeState(value) {
    setState(() {
      widget.state = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Checkbox(onChanged: _changeState, value: widget.state),
            Text(widget.label),
          ],
        ),
      ),
    );
  }
}
