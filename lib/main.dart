import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  List items = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _reloadJson();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(alignment: Alignment.centerLeft,child: const Text('台北捷運列車到站站名',style: TextStyle(fontWeight: FontWeight.bold),),),
        //elevation: 5,
        //shadowColor: Colors.grey[200],
        //分隔線
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(3),
            child: Container(
              color: Colors.grey[300],
              height: 3,
            ),
        ),

        actions: [
          PopupMenuButton(
              itemBuilder: (context) {
                return <PopupMenuEntry>[
                  PopupMenuItem(
                    value: 1,
                    child: Text('item1'),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text('item2'),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Text('item3'),
                  ),
                ];
              },

            offset: Offset(100, 30),
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
        
          children: [
            Container(
              margin: EdgeInsets.only(top: 10,),
              child: Text(isLoading ? '解析中, 請稍候' : '解析成功',style: TextStyle(fontSize: 24,),),
            ),
        
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
        
              children: [
                Container(
                  margin: EdgeInsets.only(left: 7),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        items.clear();
                        isLoading = true;
                      });
                    },
                    child: const Text('重設'),
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(170, 30),
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      elevation: 0,
        
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      )
                    ),
                  ),
                ),
        
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _reloadJson();
                        isLoading = false;
                      });
                    },
                    child: const Text('解析'),
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(170, 30),
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                        elevation: 0,
        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        )
                    ),
                  ),
                ),
              ],
            ),
        
            SizedBox(height: 10),
        
            Expanded(
              child: items.isNotEmpty
                  ? ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(items[index]["name"],style: TextStyle(fontSize: 16),),
                              dense: true,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('你選擇的是: ${items[index]["name"]}',style: TextStyle(color: Colors.black),),
                                    backgroundColor: Colors.grey[300],
                                    duration: const Duration(seconds: 2),
                                  )
                                );
                              },
                            ),
                            Divider(color: Colors.grey[200],thickness: 1,)
                          ],
                        );
                      },
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }

  void _reloadJson() {
    rootBundle.loadString("assets/test.json").then((value) {
      Map<String,dynamic> map = json.decode(value);

      setState(() {
        items = map["items"];
      });
    });
  }
}


