import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_image/universal_image.dart';

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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> _loadImage() async {
    var bytes =
        (await rootBundle.load('assets/sample.png')).buffer.asUint8List();
    return bytes.uri;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // icon provider
              UniversalImage(
                Icons.access_alarm.uri,
                color: Colors.yellow,
              ),
              // svg provider
              UniversalImage(
                'assets/sample.svg',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
              // normal provider
              UniversalImage(
                'assets/sample.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: Container(),
              ),

              FutureBuilder<String>(
                future: _loadImage(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // memory provider
                    return UniversalImage(
                      snapshot.data,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  }

                  return Container();
                },
              )
            ],
          ),
        ));
  }
}
