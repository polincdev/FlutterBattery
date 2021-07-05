import 'dart:async';

import 'package:flutter/material.dart';
import 'package:battery/battery.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery and connectivity status',
      theme: ThemeData(

        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Dashboard'),
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
  String _connectionStatus = 'Unknown';
  late IconData _connectionIcon;
  String _batteryStatus = 'Unknown';
  late IconData _batteryIcon;
  Color _connectionColor = Colors.deepOrange;
  Color _batteryColor = Colors.deepOrange;

  late StreamSubscription<ConnectivityResult> _connSub;
  late StreamSubscription<BatteryState> _battSub;

@override
void initState()
  {
  super.initState();
  _connSub=Connectivity()
      .onConnectivityChanged
      .listen((ConnectivityResult res) async {
        setState((){
          switch(res) {
            case ConnectivityResult.mobile:
              _connectionStatus = 'Mobile Data'; _connectionIcon = Icons.sim_card; _connectionColor = Colors.red; break;
            case ConnectivityResult.wifi: _connectionStatus = 'Wi-Fi'; _connectionIcon = Icons.wifi; _connectionColor = Colors.blue; break;
            case ConnectivityResult.none: _connectionStatus = "No Connection"; _connectionIcon = Icons.not_interested; _connectionColor = Colors.black;
          }
        });

  });

_battSub= Battery().onBatteryStateChanged.listen((BatteryState res) async {

  setState((){

    switch(res) {
      case BatteryState.charging:
        _batteryStatus = 'Charging';
        _batteryIcon = Icons.battery_charging_full; _batteryColor = Colors.blueAccent;
        break;
      case BatteryState.full: _batteryStatus = 'Full'; _batteryIcon = Icons.battery_full; _batteryColor = Colors.green; break;
      case BatteryState.discharging: _batteryStatus = 'In Use';
      _batteryIcon = Icons.battery_alert;
      _batteryColor = Colors.redAccent; }
  });
});

}

@override
void dispose()
{
super.dispose();
_connSub.cancel();
_battSub.cancel();
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Column(

          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children:<Widget> [
Icon(_connectionIcon,color: _connectionColor,size: 50.0,),
                Text("Connection:\n$_connectionStatus",
                style: TextStyle(color: _connectionColor, fontSize:40.0)
                ),

              ],
            ),

            Row(
                children: <Widget>[
                  Icon(_batteryIcon, color: _batteryColor, size: 50.0), Text(
                    "Battery:\n$_batteryStatus", style: TextStyle(
                    color: _batteryColor,
                    fontSize: 40.0, ),
                  ), ]
            ),

          ],
        ),

     );
  }


}
