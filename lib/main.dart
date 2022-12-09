import 'dart:convert';

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
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<dynamic>> getCards() async {
    var prefs = await SharedPreferences.getInstance();
    List<Widget> cards = [];
    var todo = prefs.getStringList("todo") ?? [];
    for (var jsonStr in todo) {
      var mapObj = jsonDecode(jsonStr);
      var title = mapObj["title"];
      var state = mapObj["state"];
      cards.add(TodoCardWidget(label: title, state: state));
    }
    return cards;
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
                  setState(() {});
                });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Center(
          child: FutureBuilder<List>(
        future: getCards(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text("Waiting to start");
            case ConnectionState.waiting:
              return const Text("Loading...");
            default:
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return snapshot.data![index];
                  },
                );
              }
          }
        },
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var label = await _showTextInputDialog(context);

          if (label != null) {
            SharedPreferences pref = await SharedPreferences.getInstance();
            var todo = pref.getStringList("todo") ?? [];

            var mapObj = {"title": label, "state": false};
            var jsonStr = jsonEncode(mapObj);
            todo.add(jsonStr);
            await pref.setStringList("todo", todo);

            setState(() {});
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

  TodoCardWidget({Key? key, required this.label, required this.state})
      : super(key: key);

  @override
  _TodoCardWidgetState createState() => _TodoCardWidgetState();
}

class _TodoCardWidgetState extends State<TodoCardWidget> {
  void _changeState(value) async {
    setState(() {
      widget.state = value ?? false;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var todo = prefs.getStringList("todo") ?? [];

    for (int i = 0; i < todo.length; i++) {
      var mapObj = jsonDecode(todo[i]);
      if (mapObj["title"] == widget.label) {
        mapObj["state"] = widget.state;
        todo[i] = jsonEncode(mapObj);
      }
    }

    prefs.setStringList("todo", todo);
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
