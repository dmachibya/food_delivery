// import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/components/app_drawer.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import '../utils/cart.dart';

class FoodDetails extends StatefulWidget {
  dynamic item;
  FoodDetails({Key? key, required this.item}) : super(key: key);

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails>
    with TickerProviderStateMixin {
  var size, height, width;
  var paddingRatio = 0.068;

  //picking center
  String? pickingCenter = "Mianzini Center";
  bool isPickingFromCenter = false;

  bool addedToCart = false;

  var images = [
    'https://unsplash.com/photos/0tgMnMIYQ9Y/download?ixid=MnwxMjA3fDB8MXxzZWFyY2h8OHx8aW1hZ2UlMjBwbGFpbiUyMHdoaXRlfGVufDB8fHx8MTY1NDE1OTgyOQ&force=true&w=640'
  ];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController quantityController;

  late AnimationController playController;

  bool isPlaying = false;
  //firestore instance
  final player = AudioPlayer();

  int currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    quantityController = TextEditingController(text: "1");
    playController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  }

  final db = FirebaseFirestore.instance;

  var dropDownValue = '1. Pick from the merchant';
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    var checkedValue = "";
    PageController _pageController = PageController(viewportFraction: 0.8);

    final player = AudioPlayer();

    GlobalKey formKey = GlobalKey();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item.get('name'),
        ),
      ),
      body: Container(
          padding: EdgeInsets.only(
            bottom: 8,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              widget.item.data().toString().contains('cover')
                  ? Image.network(widget.item.get('cover'),
                      height: 200, width: double.infinity, fit: BoxFit.cover)
                  : Container(),
              const SizedBox(
                height: 8,
              ),
              Text(
                "${widget.item['name']}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                "Genres: ${widget.item['genres']}",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                "Author: ${widget.item['author']}",
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 12,
              ),
              // Text("playing status: $isPlaying"),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.item.get("chapters").length,
                  itemBuilder: (context, index) {
                    return Card(
                        color: isPlaying && (currentIndex == index)
                            ? Colors.amber
                            : Colors.grey.shade200,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              isPlaying && (currentIndex == index)
                                  ? InkWell(
                                      onTap: () {
                                        pauseCall();
                                      },
                                      child: Icon(
                                        Icons.pause,
                                        size: 50,
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        playCall(
                                          index,
                                        );
                                      },
                                      child: Icon(
                                        Icons.play_arrow,
                                        size: 50,
                                      ),
                                    ),
                              SizedBox(width: 8),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Chapter ${index + 1}"),
                                    Text(
                                        "${widget.item.get("chapters")[index]['name']}"),
                                  ])
                            ],
                          ),
                        ));
                  },
                ),
              ),
              Container(
                width: double.infinity,
                height: 60,
                color: Colors.grey.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.skip_previous_outlined, size: 32),
                      onPressed: () {
                        playCall(currentIndex - 1);
                        setState(() {
                          currentIndex -= 1;
                        });
                      },
                    ),
                    !isPlaying
                        ? IconButton(
                            icon: Icon(Icons.play_arrow, size: 32),
                            onPressed: () {
                              if (!isPlaying) {
                                playCall(currentIndex);
                              }
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.pause, size: 32),
                            onPressed: () {
                              pauseCall();
                            }),
                    IconButton(
                      icon: Icon(Icons.stop, size: 32),
                      onPressed: () async {
                        stopCall();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.skip_next_outlined, size: 32),
                      onPressed: () {
                        playCall(currentIndex + 1);
                        setState(() {
                          currentIndex += 1;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void playCall(int index) async {
    playController.reverse();
    await player.play(UrlSource(widget.item.get('chapters')[index]['file']));
    setState(() {
      currentIndex = index;
      isPlaying = true;
    });
    // equivalent to setSource(UrlSource(url));
  }

  void pauseCall() async {
    await player.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void stopCall() async {
    // await player.pause();
    // await player.seek(Duration(milliseconds: 0));
    await player.stop();
    setState(() {
      currentIndex = 0;
      isPlaying = false;
    });
  }
}
