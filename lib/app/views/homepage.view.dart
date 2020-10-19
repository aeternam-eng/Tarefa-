import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_persistence/app/controllers/item.controller.dart';
import 'package:mvc_persistence/app/models/item.model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  var _itemController = TextEditingController();
  var _list = List<Item>();
  var _controller = ItemController();
  var selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) {
      final _firstTime = value.getBool('firstTime') ?? true;
      if (_firstTime) {
        _displayFirstDialog(context);
        value.setBool('firstTime', false);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.getAll().then((data) {
        setState(() {
          _list = _controller.list;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Tarefas'), centerTitle: true),
      body: Scrollbar(
        child: ListView(
          children: [
            for (int i = 0; i < _list.length; i++)
              ListTile(
                title: CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _list[i].concluido
                          ? Text(
                              _list[i].nome,
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough),
                            )
                          : Text(_list[i].nome),
                      Text(
                        "${_list[i].dueDate.hour}:${_list[i].dueDate.minute} - ${_list[i].dueDate.day}/${_list[i].dueDate.month}/${_list[i].dueDate.year}",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  value: _list[i].concluido,
                  secondary: IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 20.0,
                      color: Colors.red[900],
                    ),
                    onPressed: () {
                      _controller.delete(i).then((data) {
                        setState(() {
                          _list = _controller.list;
                        });
                      });
                    },
                  ),
                  onChanged: (c) {
                    _list[i].concluido = c;
                    _controller.updateList(_list).then((data) {
                      setState(() {
                        _list = _controller.list;
                      });
                    });
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _displayDialog(context),
      ),
    );
  }

  _displayDialog(context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _itemController,
                  validator: (s) {
                    if (s.isEmpty)
                      return "Digite o item.";
                    else
                      return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Tarefa"),
                ),
                Container(
                  height: 200,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.dateAndTime,
                    initialDateTime: DateTime.now().add(Duration(hours: 1)),
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        selectedDate = newDateTime;
                      });
                    },
                    use24hFormat: false,
                    minuteInterval: 1,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: new Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: new Text('SALVAR'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _controller
                      .create(Item(
                          nome: _itemController.text,
                          concluido: false,
                          dueDate: selectedDate))
                      .then((data) {
                    setState(() {
                      _list = _controller.list;
                      _itemController.text = "";
                    });
                  });
                  Navigator.of(context).pop();
                }
              },
            )
          ],
        );
      },
    );
  }

  _displayFirstDialog(context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
              "Seja bem vindo! Parece que esta é a primeira vez que você abre este aplicativo! Através dele, você pode facilmente criar listas de tarefas, tocando no botão no canto inferior da tela!"),
          actions: <Widget>[
            FlatButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
