import 'package:flutter/material.dart';
import 'package:myapp/sqlite/db_helper.dart';
import 'package:myapp/sqlite/employee.dart';
import 'package:myapp/sqlite/sqlitedb_creator.dart';


class Dogcreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Employee CRUD list",
      color: Colors.red,
      home: DogTestPage(title:"List of dogs"),
    );
  }

}

class DogTestPage extends StatefulWidget {
  final String title;
  DogTestPage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DbTestPageState();
  } 
}

class _DbTestPageState extends State<DogTestPage> {

  Future<List<DogClass>> dog;
  TextEditingController controll = TextEditingController();
  TextEditingController controll2 = TextEditingController();
  String name;
  int curUserid;
  int age;
  final fomrkey = new GlobalKey<FormState>();
  var dbhelper;
  bool isupdating;
  var fido = DogClass(
    id: 23,
    name: "dsdsd",
    age: 7,
  );

  @override
  void initState() {
    dbhelper = DogDbhelper();
    isupdating=false;
    refreshlist();
    super.initState();

  }

  refreshlist(){
    setState(() {
     dog = dbhelper.dogs(); 
     print(dog);
     print(123455677);
    });
  }

  clearname(){
    controll.text='';
    controll2.text='';
  }



  list(){
   return Expanded(
      child: FutureBuilder(
        future: dog,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.hasData) {
            print(snapshot.data);
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text("Name")
                  ),
                  DataColumn(
                    label: Text("Age")
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
                            controll2.text=employz.age.toString();
                          }
                        ),
                        DataCell(
                          Text(employz.age.toString()),
                          onTap: (){
                            setState(() {
                            isupdating = true;
                            curUserid = employz.id;
                            });
                            controll.text=employz.name;
                            controll2.text=employz.age.toString();
                          }
                        ),
                        DataCell(IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: (){
                            dbhelper.deleteDog(employz.id);
                            refreshlist();
                            },)) ]
                      )
                    ).toList(),
              ),
            );
            //return Text("has record");
          }
          if ( snapshot.hasData == null /*|| snapshot.data.length == 0*/) {
            return Text("NO records found");
          }
          return Container(
            child: CircularProgressIndicator(),
          ) ;
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
              decoration: InputDecoration(labelText: 'dog Name',hintText: "name"),
              validator: (val)=>val.length == 0 ? 'please enter dog name':null,
              onSaved: (val)=>name = val,
            ),
            TextFormField(
              controller: controll2,
              
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'dog age',hintText: 'age',),
              validator: (val){
                if (val.length == 0) {
                  return 'please enter dog age';
                }
                 return null;
                },
              onSaved: (val)=>age = int.parse(val),
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

  validate(){
    if (fomrkey.currentState.validate()) {
      fomrkey.currentState.save();
      if (isupdating) {
        DogClass e = DogClass(id:curUserid, name:name,age:age);
        dbhelper.updateDog(e);
        setState(() {
         isupdating=false;
         refreshlist();
         print("updated record $e" );
         Text("update");
        });
      }else{
        DogClass dox = DogClass(id:null, name:name,age:age);
        dbhelper.insertDog(dox);
        print("added record");
        Text("added");
        refreshlist();
      }
      refreshlist();
    }
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
          form(),
          list()
        ],),
      )
    );
  }
}