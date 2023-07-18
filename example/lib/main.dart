import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  int duration = 0;
  XFile? _file;
  _setFile(XFile? value) {
    _file = value;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          ElevatedButton(
              onPressed: chooseMp4,
              child: const Text('选择一个视频(choose Mp4 video)')),
          if (_file == null)
            const Text('空')
          else
            Text('时长(duration)：$duration s')
        ])));
  }

  Future<void> chooseMp4() async {
    try {
      final XFile? file = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
      );

      setState(() {
        _setFile(file);
      });
      if (file != null) {
        int duration_1 = await getMp4Duration(file.path);
        if (duration_1 > 0) {
          setState(() {
            duration = duration_1;
          });
        }
        // 这里就进行操作
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

Future getMvhdIndex(File file, int start, int end) async {
  var buffer = file.openRead(start, end);
  var xx = await buffer.toList();
  String ss = xx[0].map((el) {
    var s = el.toRadixString(16);
    return el < 16 ? '0$s' : s;
  }).join("");
  return [ss.indexOf("6d766864"), ss]; //find mvhd box
}

Future<int> getMp4Duration(String path) async {
  try {
    var file = File(path);
    var size = await file.length();
    var index = 0;
    // var count = 0;
    String str = '';
    int resIndex = -1;
    while (index < size) {
      var start = index;
      var end = min(index + 10000, size);
      var res = await getMvhdIndex(file, start, end);
      resIndex = res[0];
      str = res[1];
      if (resIndex < 0) {
        index = index + 9900;
        // count = count + 1;
      } else {
        // logger.d('find mvhd box:$resIndex ');
        break;
      }
    }
    if (resIndex > 0) {
      var timescale = str.substring(resIndex + 32, resIndex + 40);
      var duration = str.substring(resIndex + 40, resIndex + 48);
      debugPrint('duration:$duration timescale:$timescale');
      return (int.parse((duration), radix: 16) /
              int.parse((timescale), radix: 16))
          .round();
    }
    return resIndex;
  } catch (e) {
    //e
    debugPrint(e.toString());
    return -2;
  }
}
