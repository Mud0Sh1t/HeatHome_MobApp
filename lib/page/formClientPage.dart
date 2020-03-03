import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FormScreen extends StatelessWidget {

  final FirebaseUser user;

  FormScreen({Key key, @required this.user}) : super(key: key);

   final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('HeatHome form'),
      ),
      body: new Container(
          padding: new EdgeInsets.all(25.0),
          child: Center(
          child: Column(
            children : <Widget>[
              Text(
                "Add a new customer",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.0),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    Text("Last name :"),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter last name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                    ),
                    Text("First name :"),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter first name',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          // Validate will return true if the form is valid, or false if
                          // the form is invalid.
                          if (_formKey.currentState.validate()) {
                            // Process data.
                          }
                        },
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              )
            ]
          )
        )
      )
          
    );
  }
}