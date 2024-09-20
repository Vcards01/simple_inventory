import 'package:flutter/material.dart';
import '../model/item.dart';
import '../repository/dbhelper.dart';

class AddItem extends StatefulWidget {
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  DbHelper helper = DbHelper();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedCondition = 'Bom';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Adicionar Item"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Nome do item"),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  decoration: InputDecoration(labelText: "Condição"),
                  items: ['Ruim', 'Razoável', 'Bom', 'Muito Bom'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCondition = newValue!;
                    });
                  },
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: "Descrição"),
                ),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(labelText: "Localização"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text("Salvar"),
                  onPressed: () {
                    _saveItem();
                  },
                ),
              ],
            ),
          ),
        ));
  }

  void _saveItem() async {
    String name = _nameController.text;
    String condition = _selectedCondition;
    String description = _descriptionController.text;
    String location = _locationController.text;

    if (name.isNotEmpty && condition.isNotEmpty && description.isNotEmpty && location.isNotEmpty) {
      Item newItem = Item(
        name,
        location,
        condition,
        description
      );
      await helper.createItem(newItem);


      Navigator.pop(context, true);
    }
  }
}
