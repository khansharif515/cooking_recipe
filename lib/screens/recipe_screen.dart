import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../screens/recipe_detail_screen.dart';



class RecipeScreen extends StatefulWidget {
  final String token;
  RecipeScreen({this.token});
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool isLoading = true;
  dynamic recipeData;
  @override
  initState() {
    super.initState();
    getRecipe();
  }

  getRecipe() async {
    var rUrl = 'https://rcapp.utech.dev/api/recipes';
    await http.get(rUrl,
        headers: {"Authorization": "Bearer ${widget.token}"}).then((value) {
      if (value.statusCode == 200) {
        setState(() {
          isLoading = false;
        });
        var data = json.decode(value.body);
        recipeData = data;
      } else {
        setState(() {
          isLoading = false;
        });
      
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Recipe List"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: ListView.builder(
                itemCount: recipeData["data"].length,
                itemBuilder: (BuildContext ctx, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(
                            title: '${recipeData["data"][index]["title"]}',
                            imageUrl:
                                '${recipeData["data"][index]["image_url"]}',
                            ingredients: [
                              '${recipeData["data"][index]["ingredients"][0]["display_quantity"]} ${recipeData["data"][index]["ingredients"][0]["unit"]["name_plural"]} ${recipeData["data"][index]["ingredients"][0]["preparation"]} ${recipeData["data"][index]["ingredients"][0]["name"]}',
                              '${recipeData["data"][index]["ingredients"][1]["display_quantity"]} tablespoons ${recipeData["data"][index]["ingredients"][1]["name"]}',
                            ],
                            sourceName:
                                '${recipeData["data"][index]["source"]["name"]}',
                            sourceUrl:
                                '${recipeData["data"][index]["source_url"]}',
                            siteUrl:
                                '${recipeData["data"][index]["source"]["site_url"]}',
                            prepTime:
                                '${recipeData["data"][index]["prep_time"]}',
                            cookTime:
                                '${recipeData["data"][index]["cook_time"]}',
                            totalTime:
                                '${recipeData["data"][index]["total_time"]}',
                            servings:
                                '${recipeData["data"][index]["servings"]}',
                            notes: '${recipeData["data"][index]["notes"]}',
                            name:
                                '${recipeData["data"][index]["source"]["name"]}',
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      margin: EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            InkWell(
                              splashColor: Colors.red,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                child: Image.network(
                                  recipeData["data"][index]["image_url"],
                                  // width: double.infinity,
                                  // height: 250,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 40),
                              child: Text(
                                recipeData["data"][index]["title"],
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  //color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.access_time,
                                      size: 20,
                                      color: Colors.grey.withOpacity(0.9),
                                    ),
                                    SizedBox(width: 5),
                                    FittedBox(
                                      child: Text(
                                        '${recipeData["data"][index]["total_time"]} Mins',
                                        style: TextStyle(
                                          fontSize: 14,
                                          // fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 10),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.room_service,
                                      size: 20,
                                      color: Colors.grey.withOpacity(0.9),
                                    ),
                                    SizedBox(width: 5),
                                    FittedBox(
                                      child: Text(
                                        '${recipeData["data"][index]["servings"]} Serves',
                                        style: TextStyle(
                                          fontSize: 14,
                                          //fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
