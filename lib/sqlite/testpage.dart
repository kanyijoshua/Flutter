import 'dart:io' as io;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myapp/sqlite/employee.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import '../main.dart';

import 'package:camera/camera.dart';

import 'db_helper.dart';



class secScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "kanyi second screen",
      color: Colors.red,
      home: MyHomePagetwo(title: "Employee List",),
    );
  }

}

class MyHomePagetwo extends StatefulWidget {
  MyHomePagetwo({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomeeState createState() => _MyHomeeState();
}

class _MyHomeeState extends State<MyHomePagetwo> {
  Future<List<Employee>> empls;
  TextEditingController controll = TextEditingController();
  String name;
  int curUserid;
  final fomrkey = new GlobalKey<FormState>();
  var dbhelper;
  bool isupdating;

  @override
  void initState() {
    dbhelper = Dbhelper();
    isupdating=false;
    refreshlist();
    super.initState();
    createdb();
  }

  void createdb() async {
  final database = openDatabase(
    join(await getDatabasesPath(), 'doggie_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
      );
    },
    version: 1,
  );
  print(database);
  }

  refreshlist(){
    setState(() {
     empls = dbhelper.getEmployees(); 
    });
  }

  clearname(){
    controll.text='';
  }

  validate(){
    if (fomrkey.currentState.validate()) {
      fomrkey.currentState.save();
      if (isupdating) {
        Employee e = Employee(curUserid, name);
        dbhelper.update(e);
        setState(() {
         isupdating=false;
         refreshlist();
         print("updated record");
        });
      }else{
        Employee emp = Employee(null, name);
        dbhelper.save(emp);
        print("new record");
        refreshlist();
      }
      clearname();
      refreshlist();
      print("alter record");
    }
  }

  

  list(){
   return Expanded(
      child: FutureBuilder(
        future: empls,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          // if(snapshot.hasError){
          //   return Text("error found");
          // }
          
          if (snapshot.hasData) {
            return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Name")
          ),
          DataColumn(
            label: Text("Delete")
          )
        ],
        rows: snapshot.data.map<DataRow>((employz)=>
          DataRow(
            cells:[DataCell(
              Text(employz.name),
              onTap: (){
                setState(() {
                 isupdating = true;
                 curUserid = employz.id;
                });
                controll.text=employz.name;
              }
            ),
            DataCell(IconButton(
              icon: Icon(Icons.delete),
              onPressed: (){
                dbhelper.delete(employz.id);
                refreshlist();
                },)) ]
          )
        ).toList(),
      ),
    );
            //return Text("has record");
          }
          if (snapshot.hasData ==false) {
            return Text("has not record");
          }
          if ( snapshot.hasData == null /*|| snapshot.data.length == 0*/) {
            return Text("NO records found");
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  form(){
    return Form(
      key: fomrkey,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: controll,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Employee Name'),
              validator: (val)=>val.length == 0 ? 'please enter employee name':null,
              onSaved: (val)=>name = val,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: validate,
                  child: Text(isupdating?'UPDATE':'ADD'),
                ),
                FlatButton(
                  onPressed: (){
                    setState(() {
                     isupdating=false; 
                    });
                    clearname();
                  },
                  child: Text("Cancel"),
                )
              ],
            )
          ],
        ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
          children: <Widget>[
          //Text("fddg"),
          //Text("fd"),
          form(),
          list()
        ]),
        
      ),
      
    );
  }
}
