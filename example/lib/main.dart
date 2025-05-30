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
      title: 'Flutter UniversalImage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Demo UniversalImage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> _loadBase64Image() async {
    var bytes =
        (await rootBundle.load('assets/sample.png')).buffer.asUint8List();
    return bytes.base64Image;
  }

  Future<Uint8List> _loadBytesImage() async {
    var bytes =
        (await rootBundle.load('assets/sample.png')).buffer.asUint8List();
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    const space = 10.0;
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
                Icons.schedule,
                color: Colors.red,
              ),
              SizedBox(height: space),
              // svg provider
              UniversalImage(
                'assets/sample.svg',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
              ),
              SizedBox(height: space),
              // normal provider
              UniversalImage(
                'assets/sample.png',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: Container(),
              ),
              SizedBox(height: space),
              // base64 provider
              FutureBuilder<String>(
                future: _loadBase64Image(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return UniversalImage(
                      snapshot.data!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  }

                  return Container();
                },
              ),
              SizedBox(height: space),
              // memory bytes provider
              FutureBuilder<Uint8List>(
                future: _loadBytesImage(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return UniversalImage(
                      snapshot.data!,
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
