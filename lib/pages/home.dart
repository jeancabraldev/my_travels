import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import './map.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final _controller = StreamController<QuerySnapshot>.broadcast();

  //Instanciando banco firebase
  Firestore _db = Firestore.instance;

  //Abrindo mapa no local que o usuário marcou
  _openMap(String idTravel) {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => Mapa(idTravel: idTravel,)),
    );
  }

  //Adicionando local
  _addLocal() {
    
    //Abrindo o mapa
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => Mapa()),
    );
  }

  //Deletando viagens
  _deleteTravels(String idTravel) {
    _db.collection('travel').document(idTravel).delete();
  }

  //Recuperando o local salvo do usuário
  _addListenerTravels() async {
    final stream = _db.collection('travel').snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _addListenerTravels();
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapShot) {
          switch(snapShot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
            case ConnectionState.done:

            //Recuperando os dados
            QuerySnapshot querySnapshot = snapShot.data;
            List<DocumentSnapshot> travels = querySnapshot.documents.toList();

            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: travels.length,
                    itemBuilder: (context, index) {
                      
                      DocumentSnapshot item = travels[index];
                      String title = item['title'];
                      String idTravel = item.documentID;

                      return GestureDetector(
                        onTap: () => _openMap(idTravel),
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
                                  onTap: () => _deleteTravels(idTravel),
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
            );
            break;
          }
        }
      )
    );
  }
}