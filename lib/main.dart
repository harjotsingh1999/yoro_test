import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:yoro_test/utils.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  late AnimationController _controller;

  void _onRefresh() async {
    print("on refresh");
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
    _controller.forward(from: 0);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _controller.forward();
    // _controller.addListener(() {
    //   // print(_controller.value);
    // });
    // _controller.addStatusListener((status) {
    //   // print("controller status= $status");
    // });
  }

  @override
  Widget build(BuildContext context) {
    print("build home page");
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello Yoro"),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        header: WaterDropHeader(),
        onLoading: () {
          print("on loading");
        },
        footer: Container(
          height: 0,
        ),
        onRefresh: _onRefresh,
        enablePullDown: true,
        enablePullUp: false,
        physics: BouncingScrollPhysics(),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            int r = Random().nextInt(10);
            if (index % 2 == 0)
              return SlideTransition(
                position: Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
                    .animate(_controller),
                child:
                    LeftTile(data[r]["imagePath"] ?? "", data[r]["text"] ?? ""),
              );
            return SlideTransition(
              position: Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                  .animate(_controller),
              child:
                  RightTile(data[r]["imagePath"] ?? "", data[r]["text"] ?? ""),
            );
          },
        ),
      ),
    );
  }
}

class LeftTile extends StatefulWidget {
  final String imagePath, text;

  LeftTile(this.imagePath, this.text);

  @override
  _LeftTileState createState() => _LeftTileState();
}

class _LeftTileState extends State<LeftTile> {
  double startPos = 1.0;
  double endPos = 0.0;
  Curve curve = Curves.elasticOut;

  @override
  Widget build(BuildContext context) {
    int r = Random().nextInt(10);
    print("build left tile $r");
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              widget.imagePath,
            ),
          ),
        ),
        child: Center(
          child: Text(
            "${widget.text}?",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class RightTile extends StatefulWidget {
  final String imagePath, text;

  RightTile(this.imagePath, this.text);

  @override
  _RightTileState createState() => _RightTileState();
}

class _RightTileState extends State<RightTile> {
  double startPos = -1.0;
  double endPos = 0.0;
  Curve curve = Curves.elasticOut;

  @override
  Widget build(BuildContext context) {
    int r = Random().nextInt(10);
    print("build right tile $r");
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              widget.imagePath,
            ),
          ),
        ),
        child: Center(
          child: Text(
            "${widget.text}?",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
