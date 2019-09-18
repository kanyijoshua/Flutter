import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Firestoreclass extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'kanyi app',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: FirestorePage(title: 'firestore Home Page'),
    );
  }
}

class FirestorePage extends StatefulWidget {
  FirestorePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _FirestoreState createState() => _FirestoreState();
}

class _FirestoreState extends State<FirestorePage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeySignup = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController username = TextEditingController();
  TextEditingController useremail = TextEditingController();
  TextEditingController comment = TextEditingController();
  String id;
  final db = Firestore.instance;
  bool isupdating;
  String curcommentid;

  @override
  void initState() {
    isupdating=false;
    super.initState();
  }

  submit(String commentid)async{
    if (_formKey.currentState.validate()) {
      if (!isupdating) {
        var ref = await db.collection("user").add({'username':username.text,'comment':comment.text,'email':useremail.text}).whenComplete(
          ()=>
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: Text('commented added successfully'),
              duration: Duration(seconds:3),
            ))
        );
        setState(() {
          isupdating=false;
        });
      } else {
        var refd = await db.collection("user").document("$commentid").updateData({"username":username.text,"email":useremail.text,"comment":comment.text}).catchError(
          (err)=>print(err)).whenComplete(
            ()=>
        _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text('commented adited successfully'),
        duration: Duration(seconds:3),
      )));
      }
  }
  }

  void deletedata(String commentid)async{
    await db.collection("user").document(commentid).delete().whenComplete(
       (){
      //   setState(() {
      //     curcommentid =null;
      //   });
        _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('commented deleted successfully'),
          duration: Duration(seconds:3),
        ));
      }
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: username,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'username', 
                hintText: "username",
                helperText:"type a short username",
                border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.teal)),
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.green,
                ),),
              validator: (val)=>val.length == 0 ? 'please enter username':null,
              onSaved: (val){},
            ),
            TextFormField(
              controller: useremail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'useremail', 
                hintText: "useremail",
                helperText:"type a valid email",
                border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.teal)),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.green,
                ),),
              validator: (val){
                if(!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
                  return 'please enter valid email';
                }
                if(val.length == 0){
                  return 'please enter useremail';
                }
                return null;
                },
              onSaved: (val){},
            ),
            TextFormField(
              controller: comment,
              keyboardType: TextInputType.text,
              maxLength: 200,
              decoration: InputDecoration(
                labelText: 'comment', 
                hintText: "comment",
                helperText:"type a short comment",
                border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.teal)),
                prefixIcon: const Icon(
                  Icons.insert_comment,
                  color: Colors.green,
                ),),
              validator: (val){
                if (val.length == 0) {
                  return 'please enter comment';
                }
                if (val.length >=200) {
                  return 'comment too long';
                }
                return null;
                },
              onSaved: (val){},
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  color: Colors.cyan,
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(9.0)),
                  onPressed: ()=>submit(curcommentid),
                  child: Text(isupdating?'UPDATE comment':'ADD comment'),
                ),
                FlatButton(
                  color: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(9.0)),
                  onPressed: (){
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        title: new Text("Sign up Form"),
                        content: 
                          Form(
                              key: _formKeySignup,
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                controller: username,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  labelText: 'username', 
                                  hintText: "username",
                                  helperText:"type a short username",
                                  border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.cyan)),
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.blueAccent,
                                  ),),
                                validator: (val)=>val.length == 0 ? 'please enter username':null,
                                onSaved: (val){},
                              ),
                              TextFormField(
                                controller: useremail,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'useremail', 
                                  hintText: "user email",
                                  helperText:"type a valid email",
                                  border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.greenAccent)),
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Colors.green,
                                  ),),
                                validator: (val){
                                  if(!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)){
                                    return 'please enter valid email';
                                  }
                                  if(val.length == 0){
                                    return 'please enter useremail';
                                  }
                                  return null;
                                  },
                                onSaved: (val){useremail.text=val;},
                              ),
                            ],
                          ),
                            ),
                        actions: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FlatButton(
                                    color: Colors.blueGrey,
                                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0)),
                                    onPressed: ()async{
                                      if (_formKey.currentState.validate()) {
                                        var ref = await db.collection("user").add({'username':username.text,'comment':comment.text,'email':useremail.text});
                                        setState(() {
                                        isupdating=false;
                                        });
                                        _scaffoldKey.currentState.showSnackBar(
                                        SnackBar(
                                          content: Text('submitted'),
                                          duration: Duration(seconds:3),
                                        ));
                                      }
                                    },
                                    child: Text("sign up"),
                                  ),
                                  FlatButton(
                                    color: Colors.green,
                                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(7.0)),
                                    onPressed: (){
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("cancel"),
                                  )
                                ],
                              ),
                        ],
                      );
                    },
                  );
                  },
                  child: Text("log in"),
                )
              ],
            ),
          ],
        ),
          ),
            Container(
              child:Column(mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                StreamBuilder<QuerySnapshot>(
                stream: db.collection('user').snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  if (snapshot.connectionState ==ConnectionState.waiting) {
                    return new Text('Loading...');                    
                  }
                  if(snapshot.hasData){
                    return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      child: DataTable(
                      columns: [
                        DataColumn(
                          label: Text("Username")
                        ),
                        DataColumn(
                          label: Text("Email")
                        ),
                        DataColumn(
                          label: Text("Comment")
                        ),
                        DataColumn(
                          label: Text("Delete")
                        )
                      ],
                      rows: snapshot.data.documents.map<DataRow>((doc)=>
                        DataRow(
                          cells:[
                            DataCell(
                            Text(doc.data["username"]),
                            onTap: (){
                              setState(() {
                              isupdating = true;
                              curcommentid = doc.documentID;
                              });
                              print(curcommentid);
                              username.text=doc.data["username"];
                              useremail.text=doc.data["email"];
                              comment.text=doc.data["comment"];
                            }
                          ),
                          DataCell(
                            Text(doc.data["email"]),
                            onTap: (){
                              setState(() {
                              isupdating = true;
                              curcommentid = doc.documentID;
                              });
                              username.text=doc.data["username"];
                              useremail.text=doc.data["email"];
                              comment.text=doc.data["comment"];
                            }
                          ),
                          DataCell(
                            Text(doc.data["comment"]),
                            onTap: (){
                              setState(() {
                              isupdating = true;
                              curcommentid = doc.documentID;
                              });
                              username.text=doc.data["username"];
                              useremail.text=doc.data["email"];
                              comment.text=doc.data["comment"];
                            }
                          ),
                          DataCell(IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: (){deletedata(doc.documentID);},)) ]
                        )
                      ).toList(),
                    ),
                    ) ,
                  );
                    }
                  else{
                    return SizedBox();
                  }
                },
              )
              ],
          )
          )
          ],
        ),
      ),
      )
    );
  }
}
