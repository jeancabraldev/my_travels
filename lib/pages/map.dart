import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widget/dialogAction.dart';

class Mapa extends StatefulWidget {

  String idTravel;

  Mapa({this.idTravel});

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {

  Completer<GoogleMapController> _controllerMap = Completer();
  Set<Marker> _markers = {};

  //Instanciando Firestore
  Firestore _db = Firestore.instance;
  
  //Definnindo a posição do usuário através da posição da camera do google maps
  CameraPosition _cameraPosition = CameraPosition(
    target: LatLng(-23.562436, -46.655005),
    zoom: 18
  );


  //Criando mapa
  _onMapCreated(GoogleMapController controller) {
    _controllerMap.complete(controller);
  }

  //Exibindo marcadores
  _addMarker(LatLng latLng) async {

    List<Placemark> listAldress = await Geolocator()
      .placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    //Verificando se a lista de endereções possui informações
    if(listAldress != null && listAldress.length > 0){
      Placemark aldress = listAldress[0]; //Pegando o primeiro item da lista
      String street = aldress.thoroughfare; //Exibindo a rua da localização do usuário
      
      Marker marker = Marker(
        markerId: MarkerId('marcador-${latLng.latitude}-${latLng.longitude}'),
        position: latLng,
        infoWindow: InfoWindow(
          title: street
        )
      );

    setState(() {
      _markers.add(marker);

      //Salvando local no Firebase
      Map<String, dynamic> travels = Map();
      travels['title'] = street;
      travels['latitude'] = latLng.latitude;
      travels['longitude'] = latLng.longitude;

      _db.collection('travel').add(travels);
    });
    }
  }

  //Movimentando a vamera de acordo com a posição do usuário
  _moveCamera() async {
    GoogleMapController googleMapController = await _controllerMap.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(_cameraPosition)
    );
  }

    //Monitorando o local do usuário
      _addListenerLocation() {
        var geolocator = Geolocator();
        var locationOptions = LocationOptions(accuracy: LocationAccuracy.high);

        geolocator.getPositionStream(locationOptions).listen((Position position) {
          //Se a localização do usuário mudar o position reveberá a nova posição
          setState(() {
            _cameraPosition = CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18  
            );
              //Movimentando a vamera de acordo com a posição do usuário
              _moveCamera();
          });
        });      
    }

    //Recuperando o id da viagem
    _recoverTravelId(String idTravel) async {
      //verificando se id da viagem é nulo
      if(idTravel != null) {
        //Exibi marcador da viagem salvo
        DocumentSnapshot documentSnapshot = await _db.collection('travel')
          .document(idTravel).get();

          //Recuperando os dados
          var dados = documentSnapshot.data;

          String title = dados['title'];
          LatLng latLng = LatLng(dados['latitude'], dados['longitude']);

          setState(() {

            Marker marker = Marker(
              markerId: MarkerId('marcador-${latLng.latitude}-${latLng.longitude}'),
              position: latLng,
              infoWindow: InfoWindow(
                title: title
              )
            );

            _markers.add(marker);
            _cameraPosition = CameraPosition(
              target: latLng,
              zoom: 18
            );
            _moveCamera();
          });

      } else {
        _addListenerLocation();

      }
    }


  @override
  void initState() {
    super.initState();

    //Recuperando o id da viagem
    _recoverTravelId(widget.idTravel);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        backgroundColor: Colors.teal,
        child: Icon(Icons.info),
        onPressed: (){
        DialogAlert.yesNoDialog(context, 'Minhas Viagens', 'Mantenha o toque pressionado para marcar um lugar.');
      }),
      appBar: AppBar(
        title: Text(
          'Mapa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _cameraPosition,
          markers: _markers,
          onMapCreated: _onMapCreated,
          onLongPress: _addMarker,
        ),
      ),
    );
  }
}