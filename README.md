<h2 align="center">Easily get the duration of mp4 file</h2>
This package use for get the duration of mp4 video

## Features

It's very simle to use, just choose a file of mp4 video ,and return the duration info (seconds) of the video. 
- 🚀 Cross platform: mobile, desktop, browser
- ❤️ Simple, powerful, & intuitive API
- 🎈 **NO** native dependencies

## Getting started
add to project 
```
dependencies:
  get_mp4_duration: ^0.0.1

```

use in project


## Usage

you can use in async function like this :

```dart
const file = File('/xxx/xx.mp4');
const mp4Tool = GetMp4Duration();
int duration = await mp4Tool.getMp4Duration(file.path);
print(duration);
```

