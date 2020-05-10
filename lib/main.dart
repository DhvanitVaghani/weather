import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weathermodel.dart';
import 'weatherbloc.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Weather'),
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
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  int color1 = _getColorFromHex("#192A56");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(color1),
        body: BlocProvider(
            create: (context) => WeatherBloc(WeatherModel()),
            child: SearchPage()));
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();
  bool validate = false;

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  int color1 = _getColorFromHex("#192A56");

  String cityname;
  @override
  Widget build(BuildContext context) {
    final weatherbloc = BlocProvider.of<WeatherBloc>(context);
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
      // Not Loading State
      if (state is NotloadingWeather) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Image.asset(
            'images/pngbarn.png',
            height: 150.0,
            width: 150.0,
          ),
          Text(
            'Weather..',
            style: TextStyle(
                color: Colors.black,
                fontSize: 40.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              autofocus: false,
              onChanged: (value) {},
              controller: editingController,
              decoration: InputDecoration(
                  errorText: validate ? 'Please Enter Location' : null,
                  filled: true,
                  fillColor: Color(color1),
                  labelText: "Enter location",
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 3.0),
                      borderRadius: BorderRadius.all(Radius.circular(30.0)))),
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            width: 250.0,
            height: 50.0,
            child: FlatButton(
              color: Color(color1),
              shape: new RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              onPressed: () {
                setState(() {
                  if (editingController.text.isEmpty) {
                    validate = true;
                  } else {
                    weatherbloc.add(FetchWeather(editingController.text));
                    validate = false;
                  }
                  cityname = editingController.text;
                });
                editingController.clear();
              },
              child: Text(
                'Search Location',
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              ),
            ),
          )
        ]);
      }
      //Loading State
      else if (state is LoadingWeather) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      // Loaded State
      // After Getting Data
      else if (state is LoadedWeather) {
        // data is not null
        if (state.weather.temp != null) {
          String getimage() {
            if (state.weather.mainweather == 'Haze') {
              return 'images/haze.jpg';
            } else if (state.weather.mainweather == 'Clouds') {
              return 'images/cloudy.jpg';
            } else if (state.weather.mainweather == 'Clear') {
              return 'images/clearsky.jpg';
            } else {
              return 'images/default.jpg';
            }
          }

          return WillPopScope(
            onWillPop: movetolastState,
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: AssetImage(getimage()))),
                padding: EdgeInsets.only(right: 32, left: 32, top: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Text(
                      cityname,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Text(
                      state.weather.temp.round().toString() + "°C",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                      ),
                    ),
                    Text(
                      "Temprature",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              state.weather.tempmin.round().toString() + "°C",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            Text(
                              "Min Temprature",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              state.weather.tempmax.round().toString() + "°C",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 30),
                            ),
                            Text(
                              "Max Temprature",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Column(
                      children: <Widget>[
                        Text(
                          state.weather.windspeed.toString() + " " + "Km/h",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                        Text(
                          "Wind Speed",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: <Widget>[
                        Text(
                          state.weather.mainweather,
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        ),
                        Text(
                          "Weather Status",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 250.0,
                      height: 50,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 2.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                        onPressed: () {
                          BlocProvider.of<WeatherBloc>(context)
                              .add(ResetWeather());
                        },
                        color: Colors.transparent,
                        child: Text(
                          "Search Another..",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                )),
          );
        }

        // data is null mean no record found
        else {
          return WillPopScope(onWillPop: movetolastState,
                      child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('images/default.jpg'))),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('No Data Found',
                        style: TextStyle(color: Colors.white, fontSize: 30.0)),
                    SizedBox(height: 30),
                    Container(
                      width: 250.0,
                      height: 50,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white, width: 2.0),
                            borderRadius: BorderRadius.all(Radius.circular(25))),
                        onPressed: () {
                          BlocProvider.of<WeatherBloc>(context)
                              .add(ResetWeather());
                        },
                        color: Colors.transparent,
                        child: Text(
                          "Search Another..",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        }
      }
      // if not any State
      else {
        return Text(
          'Error',
        );
      }
    });
  }

  Future<bool> movetolastState() {
    _snackbarshow(context, 'Please, Click on Search Another..');
    return new Future.value(false);
  }

  void _snackbarshow(BuildContext context, String str) {
    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.transparent,
      duration: Duration(seconds: 2),
      content: Text(
        str,
        style: TextStyle(fontSize: 18),
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
