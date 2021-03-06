import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_pool/model/dto/user/UserDto.dart';
import 'package:share_pool/mydrawer.dart';
import 'package:share_pool/settingspage.dart';
import 'package:share_pool/statistics/statistics_page.dart';
import 'package:share_pool/user_management/loginPage.dart';
import 'package:share_pool/util/PreferencesService.dart';
import 'package:share_pool/util/rest/UserRestClient.dart';

import 'driver/driverpage.dart';

bool _isAuthenticated = false;
UserDto currentUser;

void main() async {
  _isAuthenticated = await _checkUserLoggedIn() != null;

  if (_isAuthenticated) {
    try {
      currentUser = await UserRestClient.getUser();

      PreferencesService.saveLoggedInUser(currentUser);
    } on SocketException catch (e) {
      print("Error fetching user from server");
    }
  }

  runApp(App());
}

class App extends StatefulWidget {
  MyApp() {}

  @override
  Widget build(BuildContext context) {}

  @override
  _AppState createState() => new _AppState();
}

class _AppState extends State<App> {
  Widget startScreen;

  DriverPage driverPage;
  SettingsPage settingsPage;
  StatisticsPage statisticsPage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SharePool',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        debugShowCheckedModeBanner: false,
        home:
        _isAuthenticated ? driverPage : LoginPage(driverPage));
  }

  @override
  initState() {
    super.initState();

    if (currentUser == null) {
      // TODO: show error message "server not reachable"
    }

    MyDrawer myDrawer = new MyDrawer();

    driverPage = new DriverPage(myDrawer);
    settingsPage = new SettingsPage(myDrawer);
    statisticsPage = new StatisticsPage(myDrawer);

    myDrawer.driverPage = driverPage;
    myDrawer.settingsPage = settingsPage;
    myDrawer.statisticsPage = statisticsPage;
  }
}

Future<String> _checkUserLoggedIn() async {
  return await PreferencesService.getUserToken();
}
