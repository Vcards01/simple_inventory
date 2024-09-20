import 'package:flutter/material.dart';
import '../model/item.dart';
import '../repository/dbhelper.dart';

class EditItem extends StatefulWidget {
  final Item item;

  EditItem({required this.item});

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  DbHelper helper = DbHelper();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedCondition = 'Bom';

  @override
  void initState() {
    super.initState();

    _nameController.text = widget.item.name;
    _descriptionController.text = widget.item.description!;
    _locationController.text = widget.item.location;
    _selectedCondition = widget.item.condition;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Item"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _confirmDelete();
            },
          ),
        ],
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
      ),
    );
  }

  void _saveItem() async {
    String name = _nameController.text;
    String condition = _selectedCondition;
    String description = _descriptionController.text;
    String location = _locationController.text;

    if (name.isNotEmpty && condition.isNotEmpty && description.isNotEmpty && location.isNotEmpty) {
      widget.item.name = name;
      widget.item.condition = condition;
      widget.item.description = description;
      widget.item.location = location;

      await helper.updateItem(widget.item);

      Navigator.pop(context, true);
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Excluir Item"),
          content: Text("Tem certeza que deseja excluir este item?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Excluir"),
              onPressed: () {
                _deleteItem();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteItem() async {
    if (widget.item.id != null) {
      await helper.deleteItem(widget.item.id!);
    }

    Navigator.of(context).pop();
    Navigator.of(context).pop(true);
  }
}