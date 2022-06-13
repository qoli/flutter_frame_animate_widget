# frame_animation_widget

flutter 实现帧动画

## 效果預覽

https://youtu.be/MQ-OY2gOvAI

## 如何使用

##### 添加依赖

在 pubspec.yaml 中添加:

```
  frame_animate_widget:
  git:
    url: https://github.com/qoli/flutter_frame_animate_widget.git
```



##### 這是一個 Tab icon 的例子

點擊 Tab icon 後，將播放一次動畫。

```dart
import 'package:fbinance/extensions/hex_color.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:frame_animate_widget/frame_animate_widget.dart';
import 'package:intl/intl.dart';
import 'package:quiver/iterables.dart';

class HomeTabButton extends StatelessWidget {
  HomeTabButton({
    Key? key,
    required this.title,
    required this.imageName,
    required this.number,
    required this.activate,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String imageName;
  final String number;
  final bool activate;
  final Function()? onTap;

  final GlobalKey<FrameAnimationImageState> _key = GlobalKey<FrameAnimationImageState>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (activate) {
            return;
          }

          onTap?.call();
        },
        child: SizedBox(
          height: 80,
          child: Column(
            children: [
              const SizedBox(
                height: 6,
              ),
              SizedBox(
                width: 24,
                height: 24,
                child: _button(),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: activate ? HexColor("D79C00") : HexColor("818C9C"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button() {
    int toNumber = int.tryParse(number) ?? 0;

    // activate ||
    if (toNumber == 0 || !activate) {
      return Image.asset(
        "assets/binance/${imageName}_anim_show_0000028x28@3x.png",
        fit: BoxFit.cover,
      );
    }

    var numberList = range(toNumber + 1);
    List<String> assetList = [];
    NumberFormat formatter = NumberFormat("00000");

    // wallet_anim_show_0000028x28@3x
    // wallet_anim_show_0000128x28@3x

    for (var element in numberList) {
      var thisNumber = formatter.format(element);
      assetList.add("assets/binance/${imageName}_anim_show_${thisNumber}28x28@3x.png");
    }

    return FrameAnimationImage(
      _key,
      assetList,
      width: 24,
      height: 24,
      interval: 15,
      start: true,
    );
  }
}

```

```dart
return FrameAnimationImage(
      _key,
      assetList,
      width: 24,
      height: 24,
      interval: 15, //播放間隔
      start: true, //顯示時候開始
      loop: false, //允許循環顯示
    );
```

