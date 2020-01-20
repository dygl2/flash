import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isFwdDir = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop(_isFwdDir);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Setting'),
        ),
        body: Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            children: <Widget>[
              SwitchListTile(
                value: _isFwdDir,
                activeColor: Colors.orange,
                inactiveTrackColor: Colors.grey,
                title: Text('Play forward directibn'),
                onChanged: (bool sw) {
                  _isFwdDir = sw;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
