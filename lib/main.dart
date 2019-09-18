import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/sqlite/crudhome.dart';
import 'package:myapp/sqlite/testpage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'app_screens/firstscreen.dart';
import 'cloudfirestore/firestorehome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'kanyi app',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: MyHomePage(title: 'kanyi chat Home Page'),
      routes: <String,WidgetBuilder>{
        "/secondscreen":(BuildContext context)=>new FirstScreen()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String directory;
  int currentPage = 0;
  PageController pagecntl= PageController(viewportFraction: 0.8);

  void _incrementCounter() {
    //setState(() {
      _counter++;
    //});
  }
  @override
  void initState() {
    //directory = getApplicationDocumentsDirectory().path;
    super.initState();
    //createDir();
    pagecntl.addListener((){
      int next = pagecntl.page.round();
      if (currentPage != next) {
        setState(() {
         currentPage= next; 
        });
      }
    });
  }
//   createDir() async {
//   io.Directory baseDir = await getExternalStorageDirectory(); //only for Android
//   // Directory baseDir = await getApplicationDocumentsDirectory(); //works for both iOS and Android
//   String dirToBeCreated = "kanyiappfolder";
//   String finalDir = join(baseDir.path, dirToBeCreated);
//   var dir = io.Directory(finalDir);
//   bool dirExists = await dir.exists();
//   if(!dirExists){
//      dir.createSync(recursive:true); //pass recursive as true if directory is recursive
//      print(dir);
//   }else{
//     print("folder exists or not created");
//   }
//   //Now you can use this directory for saving file, etc.
//   //In case you are using external storage, make sure you have storage permissions.
// }
slideview(context){
  return PageView(
    scrollDirection: Axis.horizontal,
    controller: pagecntl,
    children: <Widget>[
      AnimatedContainer(
        duration: Duration(microseconds: 300 ),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: 100,bottom: 150,right: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/employees.jpg")
          ),
          boxShadow: [BoxShadow(color: Colors.lightGreen,blurRadius: 20,offset: Offset(20, 20))]
        ),
        child:FlatButton(
              onPressed: (){
                      Navigator.push(context,new MaterialPageRoute(builder: (context) => secScreen()));
                    },
                    child: Text("Employee list",style: Theme.of(context).textTheme.display2,),
            ),
        
      ),
      AnimatedContainer(
        duration: Duration(microseconds: 300 ),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: 100,bottom: 150,right: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/users.png")
          ),
          boxShadow: [BoxShadow(color: Colors.pinkAccent,blurRadius: 20,offset: Offset(20, 20))]
        ),
        child: FlatButton(
              color: Colors.indigo,
              onPressed: (){
                      Navigator.push(context,new MaterialPageRoute(builder: (context) => Firestoreclass()));
                    },
                    child: Container(child: Text("Users",style: Theme.of(context).textTheme.display2),)
            ),
        
      ),
      AnimatedContainer(
        duration: Duration(microseconds: 300 ),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: 100,bottom: 150,right: 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/bird.jpg")
          ),
          boxShadow: [BoxShadow(color: Colors.orange,blurRadius: 20,offset: Offset(20, 20))]
        ),
        child:FlatButton(
              color: Colors.indigo,
              onPressed: (){
                      Navigator.push(context,new MaterialPageRoute(builder: (context) => Dogcreen()));
                    },
                    child: Container(child: Text("list of dogs",style: Theme.of(context).textTheme.display2),)
            ),
        
      ),
            new RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: ()=>Navigator.of(context).pushNamed("/secondscreen"),
                      child: new Text("New Chat",style: Theme.of(context).textTheme.display2),
                    ),
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: slideview(context)
        // Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //     Text("the first time",style: Theme.of(context).textTheme.display2,),
        //     FlatButton(
        //       color: Colors.blueGrey,
        //       onPressed: (){
        //               Navigator.push(context,new MaterialPageRoute(builder: (context) => secScreen()));
        //             },
        //             child: Text("Employee list"),
        //     ),
        //     FlatButton(
        //       color: Colors.indigo,
        //       onPressed: (){
        //               Navigator.push(context,new MaterialPageRoute(builder: (context) => Dogcreen()));
        //             },
        //             child: Container(child: Text("list of dogs"),)
        //     ),
        //     FlatButton(
        //       color: Colors.indigo,
        //       onPressed: (){
        //               Navigator.push(context,new MaterialPageRoute(builder: (context) => Firestoreclass()));
        //             },
        //             child: Container(child: Text("Users"),)
        //     ),
        //     new RaisedButton(
        //               padding: const EdgeInsets.all(8.0),
        //               textColor: Colors.white,
        //               color: Colors.blue,
        //               onPressed: ()=>Navigator.of(context).pushNamed("/secondscreen"),
        //               child: new Text("New Chat"),
        //             ),],
        //   ),
        // ),
      
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
