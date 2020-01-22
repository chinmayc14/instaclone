import 'package:flutter/material.dart';
import 'package:instagram/screens/login.dart';
import 'package:instagram/services/auth_serv.dart';

class SignupScreen extends StatefulWidget {
  static final String id = 'SignupScreen';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _email, _password, _name;
  final _formKey = GlobalKey<FormState>();
  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      authServ.SignupUser(context, _name, _email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Instagram',
                style: TextStyle(
                  fontFamily: 'Billabong',
                  fontSize: 50.0,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        validator: (input) =>
                            input.trim().isEmpty ? 'Enter name' : null,
                        onSaved: (input) => _name = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                        cursorColor: Colors.white,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (input) => !input.contains('@')
                            ? 'Please Enter Correct Email id'
                            : null,
                        onSaved: (input) => _email = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (input) =>
                            input.length < 8 ? 'Enter atleast 8 letters' : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 200.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.lightBlueAccent, Colors.black],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                      ),
                      child: FlatButton(
                        onPressed: _submit,
                        child: Text('Sign Up'),
                      ),
                    ),
                    Container(
                      width: 200.0,
                      child: FlatButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, LoginScreen.id),
                        child: Text('Already have an acoount?',
                            style: TextStyle(
                                fontSize: 14.0, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
