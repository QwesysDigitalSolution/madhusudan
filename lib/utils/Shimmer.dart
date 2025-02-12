//library pk_skeleton;

import 'package:flutter/material.dart';

Decoration myBoxDec(animation, {isCircle = false}) {
  return BoxDecoration(
    shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xfff6f7f9),
        Color(0xffe9ebee),
        Color(0xfff6f7f9),
        // Color(0xfff6f7f9),
      ],
      stops: [
        // animation.value * 0.1,
        animation.value - 1,
        animation.value,
        animation.value + 1,
        // animation.value + 5,
        // 1.0,
      ],
    ),
  );
}

class ShimmerCardSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isImage;
  final bool isBottomLinesActive;

  ShimmerCardSkeleton(
      {this.isCircularImage = true,this.isImage = true, this.isBottomLinesActive = true});

  @override
  _ShimmerCardSkeletonState createState() => _ShimmerCardSkeletonState();
}

class _ShimmerCardSkeletonState extends State<ShimmerCardSkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    widget.isImage ?
                    Container(
                      height: width * 0.13,
                      width: width * 0.13,
                      decoration:
                          myBoxDec(animation, isCircle: widget.isCircularImage),
                    ) : Container(),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: width * 0.13,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: height * 0.008,
                            width: width * 0.3,
                            decoration: myBoxDec(animation),
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.2,
                            decoration: myBoxDec(animation),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.7,
                            decoration: myBoxDec(animation),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.8,
                            decoration: myBoxDec(animation),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.5,
                            decoration: myBoxDec(animation),
                          ),
                        ],
                      )
                    : Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

Decoration myDarkBoxDec(animation, {isCircle = false}) {
  return BoxDecoration(
    shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.grey[700],
        Colors.grey[600],
        Colors.grey[700],
        // Color(0xfff6f7f9),
      ],
      stops: [
        // animation.value * 0.1,
        animation.value - 1,
        animation.value,
        animation.value + 1,
        // animation.value + 5,
        // 1.0,
      ],
    ),
  );
}

class ShimmerDarkCardSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;

  ShimmerDarkCardSkeleton(
      {this.isCircularImage = true, this.isBottomLinesActive = true});

  @override
  _ShimmerDarkCardSkeletonState createState() =>
      _ShimmerDarkCardSkeletonState();
}

class _ShimmerDarkCardSkeletonState extends State<ShimmerDarkCardSkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.grey[800],
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: width * 0.13,
                      width: width * 0.13,
                      decoration: myDarkBoxDec(animation,
                          isCircle: widget.isCircularImage),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      height: width * 0.13,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: height * 0.008,
                            width: width * 0.3,
                            decoration: myDarkBoxDec(animation),
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.2,
                            decoration: myDarkBoxDec(animation),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.7,
                            decoration: myDarkBoxDec(animation),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.8,
                            decoration: myDarkBoxDec(animation),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.5,
                            decoration: myDarkBoxDec(animation),
                          ),
                        ],
                      )
                    : Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShimmerCardListSkeleton extends StatelessWidget {
  final bool isCircularImage;
  final bool isImage;
  final bool isBottomLinesActive;
  final int length;

  ShimmerCardListSkeleton({
    this.isCircularImage = true,
    this.isImage = true,
    this.length = 10,
    this.isBottomLinesActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int index) {
        return ShimmerCardSkeleton(
          isCircularImage: isCircularImage,
          isImage : isImage,
          isBottomLinesActive: isBottomLinesActive,
        );
      },
    );
  }
}

class ShimmerDarkCardListSkeleton extends StatelessWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  final int length;

  ShimmerDarkCardListSkeleton({
    this.isCircularImage = true,
    this.length = 10,
    this.isBottomLinesActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: length,
      itemBuilder: (BuildContext context, int index) {
        return ShimmerDarkCardSkeleton(
          isCircularImage: isCircularImage,
          isBottomLinesActive: isBottomLinesActive,
        );
      },
    );
  }
}

class ShimmerCardProfileSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;

  ShimmerCardProfileSkeleton(
      {this.isCircularImage = true, this.isBottomLinesActive = true});

  @override
  _ShimmerCardProfileSkeletonState createState() =>
      _ShimmerCardProfileSkeletonState();
}

class _ShimmerCardProfileSkeletonState extends State<ShimmerCardProfileSkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: width * 0.25,
                  width: width * 0.25,
                  decoration:
                      myBoxDec(animation, isCircle: widget.isCircularImage),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (i) => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: width * 0.13,
                            width: width * 0.13,
                            decoration: myBoxDec(animation,
                                isCircle: widget.isCircularImage),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: width * 0.13,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: height * 0.008,
                                  width: width * 0.3,
                                  decoration: myBoxDec(animation),
                                ),
                                Container(
                                  height: height * 0.007,
                                  width: width * 0.2,
                                  decoration: myBoxDec(animation),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ).toList(),
                  ),
                ),
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.7,
                            decoration: myBoxDec(animation),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.8,
                            decoration: myBoxDec(animation),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.5,
                            decoration: myBoxDec(animation),
                          ),
                        ],
                      )
                    : Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShimmerDarkCardProfileSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;

  ShimmerDarkCardProfileSkeleton(
      {this.isCircularImage = true, this.isBottomLinesActive = true});

  @override
  _ShimmerDarkCardProfileSkeletonState createState() =>
      _ShimmerDarkCardProfileSkeletonState();
}

class _ShimmerDarkCardProfileSkeletonState
    extends State<ShimmerDarkCardProfileSkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.grey[800],
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: width * 0.25,
                  width: width * 0.25,
                  decoration:
                      myDarkBoxDec(animation, isCircle: widget.isCircularImage),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (i) => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: width * 0.13,
                            width: width * 0.13,
                            decoration: myDarkBoxDec(animation,
                                isCircle: widget.isCircularImage),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: width * 0.13,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: height * 0.008,
                                  width: width * 0.3,
                                  decoration: myDarkBoxDec(animation),
                                ),
                                Container(
                                  height: height * 0.007,
                                  width: width * 0.2,
                                  decoration: myDarkBoxDec(animation),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ).toList(),
                  ),
                ),
                widget.isBottomLinesActive
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.7,
                            decoration: myDarkBoxDec(animation),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.8,
                            decoration: myDarkBoxDec(animation),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.007,
                            width: width * 0.5,
                            decoration: myDarkBoxDec(animation),
                          ),
                        ],
                      )
                    : Offstage()
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShimmerCardPageSkeleton extends StatefulWidget {
  final int totalLines;

  ShimmerCardPageSkeleton({this.totalLines = 5});

  @override
  _ShimmerCardPageSkeletonState createState() =>
      _ShimmerCardPageSkeletonState();
}

class _ShimmerCardPageSkeletonState extends State<ShimmerCardPageSkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                    widget.totalLines,
                    (i) => Column(
                          children: <Widget>[
                            Container(
                              height: height * 0.007,
                              width: width * 0.7,
                              decoration: myBoxDec(animation),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * 0.007,
                              width: width * 0.8,
                              decoration: myBoxDec(animation),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * 0.007,
                              width: width * 0.5,
                              decoration: myBoxDec(animation),
                            ),
                          ],
                        )).toList(),
              )),
        );
      },
    );
  }
}

class ShimmerDarkCardPageSkeleton extends StatefulWidget {
  final int totalLines;

  ShimmerDarkCardPageSkeleton({this.totalLines = 5});

  @override
  _ShimmerDarkCardPageSkeletonState createState() =>
      _ShimmerDarkCardPageSkeletonState();
}

class _ShimmerDarkCardPageSkeletonState
    extends State<ShimmerDarkCardPageSkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              color: Colors.grey[800],
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                    widget.totalLines,
                    (i) => Column(
                          children: <Widget>[
                            Container(
                              height: height * 0.007,
                              width: width * 0.7,
                              decoration: myDarkBoxDec(animation),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * 0.007,
                              width: width * 0.8,
                              decoration: myDarkBoxDec(animation),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: height * 0.007,
                              width: width * 0.5,
                              decoration: myDarkBoxDec(animation),
                            ),
                          ],
                        )).toList(),
              )),
        );
      },
    );
  }
}

// Grid View Card
class ShimmerGridCardSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;

  ShimmerGridCardSkeleton(
      {this.isCircularImage = true, this.isBottomLinesActive = true});

  @override
  _ShimmerGridCardSkeletonState createState() =>
      _ShimmerGridCardSkeletonState();
}

class _ShimmerGridCardSkeletonState extends State<ShimmerGridCardSkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: width * 0.30,
                  width: width * 0.30,
                  decoration:
                      myBoxDec(animation, isCircle: widget.isCircularImage),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: height * 0.007,
                      width: width * 0.30,
                      decoration: myBoxDec(animation),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: height * 0.007,
                      width: width * 0.33,
                      decoration: myBoxDec(animation),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: height * 0.007,
                      width: width * 0.35,
                      decoration: myBoxDec(animation),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ShimmerGridListSkeleton extends StatelessWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;
  final int length;

  ShimmerGridListSkeleton({
    this.isCircularImage = true,
    this.length = 10,
    this.isBottomLinesActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio:
        MediaQuery.of(context).size.width /
            (500),
      ),
      itemBuilder: (BuildContext context, int index) {
        return ShimmerGridCardSkeleton(
          isCircularImage: isCircularImage,
          isBottomLinesActive: isBottomLinesActive,
        );
      },
    );
  }
}


// Product Detail
class ShimmerProductDetailCardSkeleton extends StatefulWidget {
  final bool isCircularImage;
  final bool isBottomLinesActive;

  ShimmerProductDetailCardSkeleton(
      {this.isCircularImage = true, this.isBottomLinesActive = true});

  @override
  _ShimmerProductDetailCardSkeletonState createState() =>
      _ShimmerProductDetailCardSkeletonState();
}

class _ShimmerProductDetailCardSkeletonState extends State<ShimmerProductDetailCardSkeleton>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    animation = Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(curve: Curves.easeInOutSine, parent: _controller));

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _controller.repeat();
      } else if (status == AnimationStatus.dismissed) {
        _controller.forward();
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: width * 0.8,
                  width: width * 0.8,
                  decoration:
                  myBoxDec(animation, isCircle: widget.isCircularImage),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: height * 0.007,
                      width: width * 0.80,
                      decoration: myBoxDec(animation),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: height * 0.007,
                      width: width * 0.85,
                      decoration: myBoxDec(animation),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: height * 0.007,
                      width: width * 0.90,
                      decoration: myBoxDec(animation),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: height * 0.007,
                      width: width * 0.85,
                      decoration: myBoxDec(animation),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: height * 0.007,
                      width: width * 0.90,
                      decoration: myBoxDec(animation),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: height * 0.007,
                      width: width * 0.90,
                      decoration: myBoxDec(animation),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: height * 0.007,
                      width: width * 0.90,
                      decoration: myBoxDec(animation),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}