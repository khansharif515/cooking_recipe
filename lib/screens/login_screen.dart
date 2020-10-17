import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../screens/recipe_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordNode = FocusNode();
  bool _validate = false;
  bool _isLoading = false;
  bool _showPassword = false;

  Widget buildLogo() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(8, 8, 0, 8),
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
            child: Text(
              'cooking',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
          SizedBox(width: 5),
          Text(
            'recipe',
            style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
        ],
      ),
    );
  }

  Widget buildEmailField() {
    return TextField(
      controller: emailController,
      focusNode: emailNode,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(passwordNode);
      },
      keyboardType: TextInputType.emailAddress,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        letterSpacing: 2,
      ),
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(
          fontSize: 20,
          letterSpacing: 2,
        ),
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField() {
    return TextField(
      controller: passwordController,
      focusNode: passwordNode,
      obscureText: !_showPassword,
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      keyboardType: TextInputType.visiblePassword,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 20,
        letterSpacing: 2,
      ),
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(
          fontSize: 20,
          letterSpacing: 2,
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.remove_red_eye),
          color: this._showPassword ? Colors.redAccent : Colors.grey,
          onPressed: () {
            setState(() => _showPassword = !_showPassword);
          },
        ),
        errorText: _validate ? 'Value Can\'t Be Empty' : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return ButtonTheme(
      height: 65,
      minWidth: double.infinity,
      child: RaisedButton(
        child: Text(
          'SIGN IN',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        onPressed: _isLoading
            ? null
            : () async {
                FocusScope.of(context).unfocus();
                try {
                  final result = await InternetAddress.lookup('google.com');
                  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                    print('connected');
                    if (emailController.text.toString() == 'test@test.test' &&
                        passwordController.text.toString() == '123456') {
                      performLogin();
                      setState(() {
                        _isLoading = true;
                      });
                    } else {
                      showErrToast('Email or Password is incorrect');
                    }
                  }
                } on SocketException catch (_) {
                  print('not connected');
                  showErrToast('Check Your Connection');
                }
              },
      ),
    );
  }

  showErrToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      textColor: Colors.white,
      fontSize: 18,
      backgroundColor: Colors.redAccent,
    );
  }

  performLogin() async {
    var params = {
      "email": emailController.text.toString(),
      "password": passwordController.text.toString(),
    };
    print(params);
    try {
      await http.post("https://rcapp.utech.dev/api/auth/login",
          body: json.encode(params),
          headers: {"Content-Type": "application/json"}).then(
        (value) {
          print("status code Token: ${value.statusCode}");
          print(value.body);
          // final data = json.encode(value.body);
          if (value.statusCode == 200) {
            setState(() {
              _isLoading = false;
            });
            var data = json.decode(value.body);
            String token = data["result"]["token"].toString();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeScreen(
                  token: token,
                ),
              ),
            );
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      showErrToast('msg');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Center(
          child: Stack(
            children: <Widget>[
              Image.asset(
                "assets/2.jpg",
                height: height,
                width: width,
                fit: BoxFit.cover,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    buildLogo(),
                    SizedBox(height: 40),
                    buildEmailField(),
                    SizedBox(height: 20),
                    buildPasswordField(),
                    SizedBox(height: 20),
                    buildLoginButton(),
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
