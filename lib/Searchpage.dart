import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/fullpage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

var val;
String q = 'cat';
int page = 1;

var scon = TextEditingController();
Future imageLoader() async {
  var value = await http.get(Uri.parse(
      'https://api.unsplash.com/search/collections?page=$page&query=$q&client_id=hh-8IXO-B8qlJLe_pamapFj67oWwtqIsArT8zGu1OX4'));
  val = jsonDecode(value.body);
  return val;
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(190, 150, 203, 247),
        centerTitle: true,
        toolbarHeight: 100,
        title: Expanded(
          child: TextField(
            onSubmitted: (String) {
              setState(() {
                q = scon.text;
              });
            },
            controller: scon,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white),
          ),
        ),
      ),
      body: FutureBuilder(
          future: imageLoader(),
          builder: (context, snapshot) {
            var value = snapshot.data;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return GridView.builder(
                itemCount: 10,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisSpacing: 4, crossAxisSpacing: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FullPage(
                                    URL: value['results'][index]['cover_photo']
                                        ['urls']['full'],
                                  )));
                    },
                    child: Image.network(
                      value['results'][index]['cover_photo']['urls']['small'],
                      height: 100,
                      width: 100,
                    ),
                  );
                });
          }),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          page > 1
              ? FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      page = page == 1 ? 1 : page - 1;
                    });
                  },
                  child: Icon(Icons.skip_previous_outlined))
              : SizedBox(),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
              onPressed: () {
                setState(() {
                  page = page + 1;
                });
              },
              child: Icon(Icons.skip_next_outlined))
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
