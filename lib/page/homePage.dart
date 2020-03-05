import 'package:HeatHome/models/Client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/authentification.dart';
import 'formClientPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.userMail, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final String userMail;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final fireStoreReference = Firestore.instance;

  @override
  void initState() {
    super.initState();
    getClients();
  }

  @override
  void dispose() {
    super.dispose();
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  deleteTodo(String todoId) {
    Firestore.instance.collection("clients").document(todoId).delete();
  }

  Future<List<Client>> getClients() async {
      QuerySnapshot qs = await Firestore.instance.collection("clients").getDocuments();

      List<DocumentSnapshot> usersDS = qs.documents;

      List<Client> allClient = [];

      for (num i = 0 ; i < usersDS.length; i ++) {
        Client c = Client.fromSnapshot(usersDS.elementAt(i));
        allClient.add(c);
        print(c);
      }
      return allClient;
  }

  Widget showTodoList(List<Client> clients) {
    print(clients);
    if (clients.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: clients.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = clients[index].key;
            String name = clients[index].name;
              return Dismissible(
                key: Key(todoId),
                background: Container(color: Colors.red),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) async {
                  deleteTodo(todoId);
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Customer dismissed")));
                },
                child: ListTile(
                  title: Text(
                    name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.create),
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                        return FormScreen(
                          customer: clients[index],
                          userMail: widget.userMail
                        );
                      }));
                      this.setState(() { });
                    }),
                ),
              );
          });
    } else {
      return Center(
          child: Text(
            "Welcome " + widget.userMail +". Your list is empty.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30.0),
          )
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Client>>(
      builder: (BuildContext context,AsyncSnapshot<List<Client>> snapshot) {
        List<Widget> children;
        if (snapshot.hasData) {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('HeatHome'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('Logout',
                      style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                    onPressed: signOut)
                ],
            ),
            body: showTodoList(snapshot.data),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return FormScreen(
                    customer: null,
                    userMail: widget.userMail
                  );
                }));
                this.setState(() { });
              },
              child: Icon(Icons.add),
            )
          );
        } else if (snapshot.hasError) {
          children = <Widget>[
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            )
          ];
        } else {
          return new Scaffold(
            appBar: new AppBar(
              title: new Text('HeatHome'),
              actions: <Widget>[
                new FlatButton(
                    child: new Text('Logout',
                      style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                    onPressed: signOut)
                ],
            ),
            body: 
            Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ],
              )
            )
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        );
      },
      future: getClients(),
    );
  }
}