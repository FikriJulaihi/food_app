import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:ibina_Demo_App/repository/repository.dart';

class SliderService {
  Repository _repository;
  SliderService() {
    _repository = Repository();
  }

  getSliders() async {
    return await _repository.httpGet('displayFood.php');
  }

  Widget carouselSlider(items) => SizedBox(
        height: 100,
        child: Carousel(
          boxFit: BoxFit.cover,
          images: items,
          autoplay: true,
        ),
      );
}
