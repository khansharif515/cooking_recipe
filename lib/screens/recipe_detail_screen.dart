import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeDetailScreen extends StatefulWidget {
  RecipeDetailScreen({
    this.title,
    this.imageUrl,
    this.ingredients,
    this.sourceName,
    this.sourceUrl,
    this.siteUrl,
    this.prepTime,
    this.cookTime,
    this.totalTime,
    this.servings,
    this.notes,
    this.name,
  });
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final String sourceName;
  final String sourceUrl;
  final String siteUrl;
  final String prepTime;
  final String cookTime;
  final String totalTime;
  final String servings;
  final String notes;
  final String name;

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Future<void> _launched;
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      launch(
        url,
        forceSafariVC: true,
        enableJavaScript: true,
      );
    } else {
      showErrToast('Check Your Internet Connection');
      throw 'Could not launch $url';
    }
  }

  showErrToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      textColor: Colors.white,
      fontSize: 18,
      backgroundColor: Colors.redAccent,
    );
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
              tabs: [
                Tab(text: "Overview"),
                Tab(text: "Ingredients"),
                Tab(text: "Source"),
              ],
              labelStyle: TextStyle(
                fontSize: 16,
              ),
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.red,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          //Overview
          Container(
            height: MediaQuery.of(context).size.height * .8,
            child: TabBarView(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      '${widget.notes}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    buildOverViewItem(
                      Icons.room_service,
                      'Servings',
                      '${widget.servings} Serves',
                    ),
                    buildOverViewItem(
                      Icons.timer,
                      'Preparation Time',
                      '${widget.prepTime}',
                    ),
                    buildOverViewItem(
                      Icons.av_timer,
                      'Cook Time',
                      '${widget.cookTime}',
                    ),
                    buildOverViewItem(
                      Icons.access_time,
                      'Total Time',
                      '${widget.totalTime} Mins',
                    ),
                  ],
                ),
              ),
              //Ingredients
              Container(
                  child: Column(
                children: <Widget>[
                  ...widget.ingredients
                      .map((e) => Padding(
                            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                            child: Row(
                              children: <Widget>[
                                Icon(Icons.check_box),
                                SizedBox(width: 10),
                                Text(
                                  e,
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              )),
              //Source
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Text(
                      '${widget.name}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 10),
                    ButtonTheme(
                      height: 50,
                      minWidth: double.infinity,
                      child: RaisedButton(
                        textColor: Colors.white,
                        onPressed: () {
                          _launched = _launchInBrowser(widget.sourceUrl);
                        },
                        child: Text('Source of the Recipe'),
                      ),
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      textColor: Colors.redAccent,
                      onPressed: () {
                        _launched = _launchInBrowser('https://${widget.siteUrl}');
                      },
                      child: Text('More Recipe'),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildOverViewItem(IconData icon, String titleTxt, String valTex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Icon(icon),
          SizedBox(width: 8),
          Text(titleTxt),
          Spacer(),
          Text(
            valTex,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.sourceUrl);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              child: Image.network(widget.imageUrl),
            ),
            SizedBox(height: 20),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 30),
            _tabSection(context),
          ],
        ),
      ),
    );
  }
}
