import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///////////////////////////////

void main() => runApp(MyApp());

///////////////////////////////
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
  @override
  void initState() {
    //Widgetを初期化した時の処理をoverride
    super.initState();
    SharedPreferences.getInstance().then((pref) {
      var todo = pref.getStringList("todo") ?? [];
      for (var v in todo) {
        setState(() {
          widget.cards.add(TodoCardWidget(label: v));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Todo"),
        actions: [
          IconButton(
              onPressed: () {
                SharedPreferences.getInstance().then((pref) async {
                  await pref.setStringList("todo", []);
                  setState(() {
                    widget.cards = [];
                  });
                });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: widget.cards.length,
          itemBuilder: (BuildContext context, int index) {
            return widget.cards[index];
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var label = await _showTextInputDialog(context);

          if (label != null) {
            setState(() {
              widget.cards.add(TodoCardWidget(label: label));
            });

            SharedPreferences pref = await SharedPreferences.getInstance();
            var todo = pref.getStringList("todo") ?? [];
            todo.add(label);
            await pref.setStringList("todo", todo);
            _textFieldController.text = "";
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
              onPressed: () => Navigator.pop(context),
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
      margin: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
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
