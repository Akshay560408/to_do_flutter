import 'package:flutter/material.dart';
import 'package:todo/dbhelper.dart';

class todoui extends StatefulWidget {
  @override
  _todouiState createState() => _todouiState();
}

class _todouiState extends State<todoui> {
  final dbhelper = Databasehelper.instance;
  final texteditingcontroller = TextEditingController();
  bool validated = true;
  String errtext = "";
  String todoedited = "";
  var myitems = List();
  List<Widget> children = new List<Widget>();

  void addtodo() async {
    Map<String, dynamic> row = {
      Databasehelper.columnName: todoedited,
    };
    final id = await dbhelper.insert(row);
    print(id);
    Navigator.pop(context);
    todoedited="";
    setState(() {
      validated = true;
      errtext = "";
    });
  }
  Future<bool> query() async {
    myitems = [];
    children = [];
    var allrows = await dbhelper.queryall();
    allrows.forEach((row) {
      myitems.add(row.toString());
      children.add(Card(
        elevation: 5.0,
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 5.0,
        ),
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: ListTile(
            title: Text(
              row['todo'],
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: "Raleway",
              ),
            ),
            onLongPress: () {
              dbhelper.deletedata(row['id']);
              setState(() {});
            },
          ),
        ),
      ));
    });
    return Future.value(true);
  }

  void showalertdialog() {
    texteditingcontroller.text="";
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              title: Text(
                "Add Task",
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: texteditingcontroller,
                    autofocus: true,
                    onChanged: (_val) {
                      todoedited = _val;
                    },
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "Raleway",
                    ),
                    decoration: InputDecoration(
                      errorText: validated ? null : errtext,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.purple,
                        child: Text(
                          "ADD",
                          style:
                              TextStyle(fontSize: 20.0, fontFamily: "Raleway"),
                        ),
                        onPressed: () {
                          if (texteditingcontroller.text.isEmpty) {
                            setState(() {
                              errtext = "Can't Be Empty";
                              validated = false;
                            });
                          } else if (texteditingcontroller.text.length > 512) {
                            setState(() {
                              errtext = "Too many characters";
                              validated = false;
                            });
                          } else {
                            addtodo();
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

//  Widget mycard(String task) {
//    return Card(
//      elevation: 5.0,
//      margin: EdgeInsets.symmetric(
//        horizontal: 10.0,
//        vertical: 5.0,
//      ),
//      child: Container(
//        padding: EdgeInsets.all(5.0),
//        child: ListTile(
//          title: Text(
//            "$task",
//            style: TextStyle(
//              fontSize: 18.0,
//              fontFamily: "Raleway",
//            ),
//          ),
//          onLongPress: () {
//            print("Should geet Deleted");
//          },
//        ),
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snap) {
        if (snap.hasData == null) {
          return Center(
            child: Text(
              "No Data",
            ),
          );
        } else {
          if (myitems.length == 0) {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showalertdialog();
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.purple,
              ),
              appBar: AppBar(
                title: Text(
                  "My Tasks",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              body: Center(
                child: Text(
                  "No Task Available",
                  style: TextStyle(fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                  fontSize: 20.0),
                ),
              ),
            );
          }else{
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showalertdialog();
                },
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.purple,
              ),
              appBar: AppBar(
                title: Text(
                  "My Tasks",
                  style: TextStyle(
                    fontFamily: "Raleway",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.black,
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: children,
                ),
              ),
            );
          }
        }
      },
      future: query(),
    );
  }
}

