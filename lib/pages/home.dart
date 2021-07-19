import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Java', votes: 5),
    Band(id: '2', name: 'Python', votes: 1),
    Band(id: '3', name: 'Dart', votes: 2),
    Band(id: '4', name: 'C#', votes: 3)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text('BandNames', style: TextStyle(color: Colors.black87)),
          backgroundColor: Colors.white,
          //elevation es el tamaño de la sombra
          elevation: 0),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, index) => _bandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), elevation: 1, onPressed: addNewBand),
    );
  }

  Widget _bandTile(Band band) {
    //Dismissible para borrar el tile
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print('Direction: $direction');
        print('id: ${band.id}');
        //TODO: llamar el borrado en el server
      },
      background: Container(
          padding: EdgeInsets.only(left: 20.0),
          color: Color(0x7CFF0000),
          child: Align(
              alignment: Alignment.centerLeft,
              child:
                  Text("Delete Band", style: TextStyle(color: Colors.white)))),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Color(0xFFADF7E7),
        ),
        title: Text(band.name.toString()),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
        onTap: () {
          print(band.name);
        },
      ),
    );
  }

  addNewBand() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      //ANDROID
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('New band name:'),
              content: TextField(
                controller: textController,
              ),
              actions: [
                MaterialButton(
                    child: Text('Add'),
                    elevation: 5,
                    onPressed: () => addBandtoList(textController.text)),
                MaterialButton(
                    child: Text('Dismiss'),
                    elevation: 5,
                    onPressed: () => Navigator.pop(context))
              ],
            );
          });
    }

    if (Platform.isIOS) {
      //IOS
      showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text('New band name:'),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: [
                //botón de añadir
                CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text('add'),
                    onPressed: () => addBandtoList(textController.text)),
                //botón de salir
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text('Dismiss'),
                    onPressed: () => Navigator.pop(context))
              ],
            );
          });
    }
  }

  void addBandtoList(String name) {
    if (name.length > 1) {
      this
          .bands
          .add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    //salir del dialogo
    Navigator.pop(context);
  }
}
