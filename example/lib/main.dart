import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_mp4_duration/get_mp4_duration.dart';

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
  final mp4Tool = GetMp4Duration();
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
        int duration_1 = await mp4Tool.getMp4Duration(file.path);
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
