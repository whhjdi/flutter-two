import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import './data.dart';
import './Indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  int _currentPage = 0;
  bool _lastPage = false;
  PageController _pageController;
  AnimationController _pageAnimationController;
  Animation<double> _scaleAnimation;
  @override
  void initState() {
    _pageController = PageController(initialPage: _currentPage);
    _pageAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_pageAnimationController);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.clamp,
            stops: [0.0, 1.0],
            colors: [Color(0xff4855563), Color(0xff29323c)],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              PageView.builder(
                controller: _pageController,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                    if (_currentPage == pageList.length - 1) {
                      _lastPage = true;
                      _pageAnimationController.forward();
                    } else {
                      _lastPage = false;
                      _pageAnimationController.reset();
                    }
                  });
                },
                itemCount: pageList.length,
                itemBuilder: (BuildContext context, int index) {
                  var page = pageList[index];

                  return AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, child) {
                        var delta;
                        var y = 1.0;
                        if (_pageController.position.haveDimensions) {
                          delta = _pageController.page - index;
                          y = 1 - delta.abs().clamp(0.0, 1.0);
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Image.asset(page.imageUrl),
                            Container(
                              height: 100.0,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40.0),
                                    child: Opacity(
                                      opacity: 0.1,
                                      child: ShaderMask(
                                        shaderCallback: (bounds) {
                                          return LinearGradient(
                                                  colors: page.titleGradient)
                                              .createShader(
                                                  Offset.zero & bounds.size);
                                        },
                                        child: Text(
                                          page.title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            letterSpacing: 1.0,
                                            fontFamily: "Montserrat-Black",
                                            fontSize: 70.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: ShaderMask(
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                                colors: page.titleGradient)
                                            .createShader(
                                                Offset.zero & bounds.size);
                                      },
                                      child: Text(
                                        page.title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          letterSpacing: 1.0,
                                          fontFamily: "Montserrat-Black",
                                          fontSize: 70.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Transform(
                                transform: Matrix4.translationValues(
                                    0, 100 * (1 - y), 0),
                                child: Text(
                                  page.body,
                                  style: TextStyle(
                                      color: Colors.white30,
                                      fontSize: 20.0,
                                      fontFamily: "Montserrat-Medium"),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                },
              ),
              Positioned(
                left: 30.0,
                bottom: 60.0,
                child: Container(
                  width: 100.0,
                  height: 10.0,
                  child: Indicator(_currentPage, pageList.length),
                ),
              ),
              Positioned(
                right: 30.0,
                bottom: 40.0,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _lastPage
                      ? FloatingActionButton(
                          onPressed: () {},
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
