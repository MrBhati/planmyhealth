import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plan_my_health/model/Diagnostics.dart';
import 'package:plan_my_health/model/SelectTestList.dart';
import 'package:plan_my_health/model/SelectedDisease.dart';
import 'package:plan_my_health/Helpers/ApiHelper.dart';
import 'package:plan_my_health/model/Diagnosis.dart';
import 'package:plan_my_health/model/Wellness.dart';

class SelectWallness extends StatefulWidget {
  SelectWallness({Key key}) : super(key: key);

  @override
  _SelectWallnessState createState() => _SelectWallnessState();
}

class _SelectWallnessState extends State<SelectWallness> {
  ApiHelper apiHelper = ApiHelper();

  Color mycolor = Colors.white;
  List<Wellnesslist> selectwellnesslist = [];
  var wellnessStatus = List<bool>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context, selectwellnesslist);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: Column(children: [
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "   Select Wellness Tips",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context, selectwellnesslist);
                },
                child: Text("close    "),
              )
            ],
          ),
          SizedBox(height: 10),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: SingleChildScrollView(
                child: Column(
              children: [
                FutureBuilder<List<Wellnesslist>>(
                  future: apiHelper.getWellnesslist(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Wellnesslist> data = snapshot.data;
                      return wellnessList(data);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                      child: Container(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator()),
                    );
                  },
                ),
              ],
            )),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pop(context, selectwellnesslist);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Save Wellness",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ])),
      ),
    );
  }

  ListView wellnessList(data) {
    print("---------------------");
    print(data.length);
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        controller: ScrollController(),
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        itemBuilder: (context, index) {
          wellnessStatus.add(false);
          return wellnessTile(data, index);
        });
  }

  Card wellnessTile(dynamic wellnesslist, int index) => Card(
        color: mycolor,
        child: new Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new ListTile(
              selected: wellnessStatus[index],
              leading: const Icon(Icons.info),
              title: new Text(wellnesslist[index].wellnessname),
              //ssubtitle: new Text(wellnesslist[index].bloodQuantityRequired),
              trailing: Checkbox(
                  checkColor: Colors.white, // color of tick Mark

                  value: wellnessStatus[index],
                  onChanged: (bool val) {
                    //   wellnessStatus[index] = !wellnessStatus[index];
                  }),
              onTap: () {
                print(wellnessStatus[index].toString());
                // setState(() {
                //   wellnessStatus[index] = !wellnessStatus[index];
                // });

                setState(() {
                  if (!wellnessStatus[index]) {
                    setState(() {
                      print("change color");

                      wellnessStatus[index] = !wellnessStatus[index];

                      Wellnesslist selectwellness = new Wellnesslist();

                      selectwellness.sId = wellnesslist[index].sId.toString();
                      selectwellness.wellnessname =
                          wellnesslist[index].wellnessname.toString();
                      selectwellnesslist.add(selectwellness);
                      print("change" + selectwellnesslist.length.toString());
                      setState(() {});
                    });
                  } else {
                    setState(() {
                      //  mycolor = Colors.red;
                      wellnessStatus[index] = !wellnessStatus[index];
                    });
                  }
                });
              } // what should I put here,
              )
        ]),
      );
}
