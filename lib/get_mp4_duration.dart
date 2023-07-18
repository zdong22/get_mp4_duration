library get_mp4_duration;

import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';

class GetMp4Duration {
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
          // debugPrint('find mvhd box:$resIndex ');
          break;
        }
      }
      if (resIndex > 0) {
        var timescale = str.substring(resIndex + 32, resIndex + 40);
        var duration = str.substring(resIndex + 40, resIndex + 48);
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
}
