import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ibina_Demo_App/screens/dishes.dart';
import 'package:ibina_Demo_App/widgets/grid_product.dart';
import 'package:ibina_Demo_App/widgets/home_category.dart';
import 'package:ibina_Demo_App/widgets/slider_item.dart';
import 'package:ibina_Demo_App/util/foods.dart';
import 'package:ibina_Demo_App/util/const.dart';
import 'package:ibina_Demo_App/util/categories.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_pro/carousel_pro.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  List<FoodDisplay> slider = [];

  var url_food = BASE_API + "displayFood.php";

  // @override
  Future<List<FoodDisplay>> _getFood() async {
    var data = await http.get(url_food);
    var displayFood = json.decode(data.body)['data'];

    List<FoodDisplay> foodie = [];

    for (var u in displayFood) {
      FoodDisplay food = FoodDisplay(
          u['id'], u['name'], u['description'], u['image'], u['price']);
      foodie.add(food);
    }

    return foodie;
  }

  Future<List> _getSlider() async {
    var data1 = await http.get(url_food);
    var displayFood = json.decode(data1.body)['data'];

    List<dynamic> slider = [];

    for (var u in displayFood) {
      // FoodDisplay food = FoodDisplay(
      //     u['id'], u['name'], u['description'], u['image'], u['price']);
      slider.add(NetworkImage(u["image"]));
    }

    return (slider);
  }

  int _current = 0;

  List<dynamic> featured = [
    NetworkImage('http://demo.ibinatech.com/dist/img/nasitomato.jpg',
        scale: 1.0),
    NetworkImage('http://demo.ibinatech.com/dist/img/nasiayam.jpg', scale: 1.0),
    NetworkImage('http://demo.ibinatech.com/dist/img/cm4.jpg', scale: 1.0),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Center(
                  child: Text(
                    "Featured Menu",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.0),

            //Slider Here
            FutureBuilder(
                future: _getSlider(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return SizedBox(
                      height: 200.0,
                      width: 350.0,
                      child: Carousel(
                        images: slider,
                        dotSize: 4.0,
                        dotSpacing: 15.0,
                        dotColor: Colors.red[400],
                        indicatorBgPadding: 5.0,
                        dotBgColor: Colors.white.withOpacity(0.5),
                        borderRadius: true,
                      ));
                }
                // SizedBox(height: 5.0),
                ),
            // SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Popular Items",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FlatButton(
                  child: Text(
                    "View More",
                    style: TextStyle(
//                      fontSize: 22,
//                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10.0),
            FutureBuilder(
              future: _getFood(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: 30,
                          width: 30,
                          margin: EdgeInsets.all(5),
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.25),
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GridProduct(
                        image: snapshot.data[index].image,
                        isFav: false,
                        name: snapshot.data[index].name,
                        rating: 5.0,
                        raters: 23,
                      );
                    },
                  );
                }
              },
            ),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FoodDisplay {
  final String id;
  final String name;
  final String description;
  final String image;
  final String price;

  FoodDisplay(this.id, this.name, this.description, this.image, this.price);
}
