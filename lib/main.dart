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
  String? label = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Todo")),
      body: Center(child: Text(label ?? "")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var resultLabel = await _showTextInputDialog(context);
          if (resultLabel != null) {
            setState(() {
              label = resultLabel;
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

final _textFieldController = TextEditingController();

Future<String?> _showTextInputDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Todo"),
        content: TextField(
          controller: _textFieldController,
          decoration:
              const InputDecoration(hintText: "Please input your task name"),
        ),
        actions: <Widget>[
          ElevatedButton(
              onPressed: (() => Navigator.pop(context)),
              child: const Text("cancel")),
          ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context, _textFieldController.text),
              child: const Text("OK"))
        ],
      );
    },
  );
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
