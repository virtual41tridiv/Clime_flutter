import 'package:clime/screens/city_screen.dart';
import 'package:flutter/material.dart';
import 'package:clime/utilities/constants.dart';
import 'package:clime/services/weather.dart';
import 'city_screen.dart';
class LocationScreen extends StatefulWidget {

  LocationScreen({this.locationWeather});

  final locationWeather;


  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {

  WeatherModel weather = WeatherModel();

  int mainDescription;
  String sysDescription;
  String weatherIcon;
  double longitude;
  String weatherMessage;

  @override
  void initState() {
    
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {

    setState(() {
        
        if(weatherData == null){
          mainDescription = 0;
          weatherIcon = 'Error';
          weatherMessage = 'Unable to get weather data';
          sysDescription = '';
          longitude = 0;
          return;
        }
        
         longitude = weatherData['coord']['lon'];
         var weatherDescription = weatherData['weather'][0]['id'];
         weatherIcon = weather.getWeatherIcon(weatherDescription);
         double temp = weatherData['main']['temp'];
         mainDescription = temp.toInt();
         weatherMessage = weather.getMessage(mainDescription);
         sysDescription = weatherData['name'];
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                    var typedName = await Navigator.push(
                        context, MaterialPageRoute(builder: (context){
                        return CityScreen();
                      },
                      ),
                      );
                      if (typedName != null) {
                         var weatherData = await weather.getCityWeather(typedName);
                         updateUI(weatherData);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$mainDescription°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherMessage in $sysDescription',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

