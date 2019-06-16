import 'package:flutter/material.dart';
import 'package:share_pool/driver-settings/editTourPage.dart';
import 'package:share_pool/driver-settings/tourListWidget.dart';
import 'package:share_pool/driver/driverpage.dart';
import 'package:share_pool/model/dto/tour/TourDto.dart';
import 'package:share_pool/util/rest/TourRestClient.dart';

import '../mydrawer.dart';

class DriverSettingsPage extends StatefulWidget {
  final String title = "Your Tours";
  MyDrawer myDrawer;

  DriverSettingsPage(this.myDrawer);

  @override
  _DriverSettingsPageState createState() => _DriverSettingsPageState();
}

class _DriverSettingsPageState extends State<DriverSettingsPage> {
  List<TourDto> tours;

  Future<void> loadTours() async {
    List<TourDto> tours = await TourRestClient.getToursForUser();

    setState(() {
      this.tours = tours;
    });
  }

  @override
  void initState() {
    super.initState();

    loadTours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.directions_car, color: Colors.white),
                onPressed: () =>
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DriverPage(widget.myDrawer))))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TourEditPage(widget.myDrawer)));
          },
        ),
        drawer: widget.myDrawer,
        // todo make it so empty list is also refreshable
        body: RefreshIndicator(
            child: Center(
              child: tours == null || tours.isEmpty
                  ? Text("No tours defined yet.")
                  : TourListWidget(
                      myDrawer: widget.myDrawer,
                      tours: tours,
                    ),
            ),
            onRefresh: loadTours));
  }
}
