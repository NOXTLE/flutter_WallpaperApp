import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

// ignore: must_be_immutable
class FullPage extends StatefulWidget {
  FullPage({super.key, required this.URL});
  // ignore: non_constant_identifier_names
  String URL;

  @override
  State<FullPage> createState() => _FullPageState();
}

class _FullPageState extends State<FullPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.network(
            widget.URL,
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                //download Algo below
                String url = widget.URL.trim();
                var tempDir = await getTemporaryDirectory();

                await Dio().download(url, '${tempDir.path}/myfile.jpeg');

                await GallerySaver.saveImage('${tempDir.path}/myfile.jpeg')
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Download Completed"),
                    action: SnackBarAction(
                      label: "OK",
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ));
                  //full downloading
                });
              },
              child: const Text("DOWNLOAD"))
        ]),
      ),
    );
  }
}
