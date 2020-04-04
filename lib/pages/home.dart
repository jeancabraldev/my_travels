import 'package:flutter/material.dart';
import './map.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //Lista de viagens
  List _listTravels = [
    'São Paulo',
    'Curitiba',
    'México',
  ];

  //Abrindo mapa
  _openMap() {
    print('Abindo o mapa');
  }

  //Adicionando local
  _addLocal() {
    
    //Abrindo o mapa
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => Map()),
    );
  }

  //Deletando viagens
  _deleteTravels() {
    print('Excluiido um local');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Minhas Viagens',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add, color: Colors.white,),
        onPressed: () => _addLocal(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _listTravels.length,
              itemBuilder: (context, index) {
                
                String title = _listTravels[index];
                
                return GestureDetector(
                  onTap: () => _openMap(),
                  child: Card(
                    child: ListTile(
                        title: Text(title, 
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => _deleteTravels(),
                            child: Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(Icons.delete),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }
}