import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../widget/dialogAction.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {

  Completer<GoogleMapController> _controllerMap = Completer();
  Set<Marker> _markers = {};

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
  _displayMarker(LatLng latLng) async {

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

  @override
  void initState() {
    super.initState();

    _addListenerLocation();

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
          onLongPress: _displayMarker,
        ),
      ),
    );
  }
}