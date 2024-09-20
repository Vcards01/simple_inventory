import 'package:flutter/material.dart';
import '../model/item.dart';
import '../repository/dbhelper.dart';
import 'additem.dart';
import 'deleteorupdateitem.dart';

class ItemList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ItemListState();
}

class ItemListState extends State<ItemList> {

  DbHelper helper = DbHelper();
  List<Item>? items;
  int count = 0;

  void getData() {

    var dbFuture = helper.initializeDb();

    dbFuture.then( (result) {

      var itemsFuture = helper.getItems();

      itemsFuture.then( (result) {

        List<Item> itemList = [];

        count = result.length;

        for (int i=0; i<count; i++) {
          itemList.add(Item.fromMap(result[i]));
        }

        setState(() {
          items = itemList;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (items == null) {

      items = [];

      getData();
    }

    return Scaffold(

      appBar: AppBar(
        title: Text("Simple Inventory"),
      ),

      body: listItems(),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItem()),
          );

          if (result != null && result) {
            getData();
          }
        },
        tooltip: "Adicionar novo Item",
        child: Icon(Icons.add),
      ),
    );
  }

  ListView listItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getColor(this.items![position].condition),
            ),
            title: Text(this.items![position].name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Condição: ${this.items![position].condition}'),
                Text('Descrição: ${this.items![position].description}'),
                Text('Localização: ${this.items![position].location}'),
              ],
            ),
            onTap: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditItem(item: this.items![position]),
                ),
              ).then((value) {
                getData();
              });
            },
          ),
        );
      },
    );
  }

  Color getColor(String condition) {

    switch (condition) {
      case 'Ruim':
        return Colors.red;
        break;
      case 'Razoável':
        return Colors.orange;
        break;
      case 'Bom':
        return Colors.yellow;
        break;
      case 'Muito Bom':
        return Colors.green;
        break;

      default:
        return Colors.green;
    }

  }

}