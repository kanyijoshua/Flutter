import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';

import 'package:camera/camera.dart';

import 'cameracontroller.dart';


class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "kanyi second screen $gennumber",
      color: Colors.red,
      home: mycreen(),
    );
  }

  int gennumber() {
    Random randm = Random();
    return randm.nextInt(10);
  }
}
class mycreen extends StatelessWidget{
  
  Future<void> gencamera()async {
    final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    runApp(
    MaterialApp(
      theme: ThemeData.light(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        cameraaval: firstCamera,
      ),
    ),
  );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("bluetooth chat"),
      ),
      drawer: Drawer(
        elevation: 13.0,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("kanyi"),
              accountEmail: Text("west@yahoo.com"),
              currentAccountPicture: CircleAvatar(backgroundColor: Colors.yellowAccent,child: Text("K"),),
              otherAccountsPictures: <Widget>[CircleAvatar(backgroundColor: Colors.purple,child: Text("J"))],),
            ListTile(title:new Text("close"),trailing: Icon(Icons.cancel),onTap: ()=>Navigator.of(context).pop(),),
            ListTile(title:new Text("group"),trailing: Icon(Icons.group),onTap: ()=>Navigator.of(context).pop(),),
            Divider(),
            ListTile(title:new Text("Home"),trailing: Icon(Icons.home),
                      onTap: ()=>Navigator.push(context,new MaterialPageRoute(builder: (context) => new MyApp())))
          ],
        ),
      ),
      body: Container(child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Text("the first time",style: Theme.of(context).textTheme.display2,),
          new IconButton(
            icon: new Icon(Icons.bluetooth_searching),
            iconSize: 70.0,
            onPressed: gencamera,
          ),
          CircularProgressIndicator(),
          Text("searching..",style: Theme.of(context).textTheme.display2,)],
        ),
      ),)
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera ,maxHeight: 700,maxWidth: 800);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}
