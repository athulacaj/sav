import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

List adsFromSplashScreen = [];

class ComplicatedImageDemo extends StatelessWidget {
  final List ad;
  ComplicatedImageDemo(this.ad);
  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = ad
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(4),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    child: Container(
                      child: CachedNetworkImage(
                        imageUrl: item,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => SpinKitRipple(
                          color: Colors.grey,
                          size: 30.0,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
//                      FadeInImage.memoryNetwork(
//                          placeholder: kTransparentImage, image: item),
                    )),
              ),
            ))
        .toList();

    return Container(
        child: Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
              autoPlay: false,
              aspectRatio: 2,
              enlargeCenterPage: false,
              enableInfiniteScroll: false),
          items: imageSliders,
        ),
      ],
    ));
  }
}

List getImageSliders(List adsList) {
  final List<Widget> imageSliders = adsList
      .map((item) => Container(
            margin: EdgeInsets.all(6),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: item,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => SpinKitRipple(
                      color: Colors.grey,
                      size: 30.0,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
//                      FadeInImage.memoryNetwork(
//                          placeholder: kTransparentImage, image: item),
                )),
          ))
      .toList();
  return imageSliders;
}

makeCarouousel(List imageSliders, var size) {
  print(imageSliders);
  return SizedBox(
    height: 170,
    child: Stack(
      children: <Widget>[
        Positioned(
          left: -23,
          top: 0,
          width: size.width + 23,
          child: Container(
              alignment: Alignment.topLeft,
              width: size.width,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: false,
                  enlargeCenterPage: false,
                  aspectRatio: 2.2,
                  enableInfiniteScroll: false,
                ),
                items: imageSliders,
              )),
        ),
      ],
    ),
  );
}
