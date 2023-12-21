import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/Searchpage.dart';

import 'dart:math';

import 'package:wallpaper_app/fullpage.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var dataJson;
  var val;
  int index = Random().nextInt(10);

  Future getData() async {
    dataJson = await http.get(Uri.parse(
        'https://api.unsplash.com/photos/?page=$index&client_id=hh-8IXO-B8qlJLe_pamapFj67oWwtqIsArT8zGu1OX4'));

    val = jsonDecode(dataJson.body);
    return val;
  }

  @override
  Widget build(context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(246, 231, 226, 226),
        appBar: AppBar(
            backgroundColor: Color.fromARGB(190, 150, 203, 247),
            centerTitle: true,
            actions: [
              GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SearchPage()));
                  },
                  child: Icon(Icons.search)),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = Random().nextInt(10);
                  });
                },
                child: Icon(Icons.replay),
              ),
              SizedBox(
                width: 20,
              )
            ],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Icon(Icons.wallpaper), Text("Wall-E")],
            )),
        body: Center(
          child: FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                var value = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.builder(
                    itemCount: 10,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 2),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FullPage(
                                      URL: value[index]['urls']['small_s3'])));
                        },
                        child: Image.network(
                          value[index]['urls']['small_s3'],
                          height: 100,
                          width: 100,
                        ),
                      );
                    });
              }),
        ));
  }
}
