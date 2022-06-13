library frame_animate_widget;

import 'package:flutter/material.dart';

class FrameAnimationImage extends StatefulWidget {
  FrameAnimationImage(
    Key key,
    this._assetList, {
    this.width,
    this.height,
    this.interval = 200,
    this.start = true,
    this.loop = false,
  }) : super(key: key);

  final List<String> _assetList;
  final double width;
  final double height;
  final bool start;
  final int interval;
  final bool loop;

  @override
  State<StatefulWidget> createState() {
    return FrameAnimationImageState();
  }
}

class FrameAnimationImageState extends State<FrameAnimationImage> with SingleTickerProviderStateMixin {
  // 动画控制
  Animation<double> _animation;
  AnimationController _controller;
  int interval = 200;

  AnimationStatus _status;

  @override
  void initState() {
    super.initState();

    if (widget.interval != null) {
      interval = widget.interval;
    }
    final int imageCount = widget._assetList.length;
    final int maxTime = interval * imageCount;

    // 启动动画controller
    _controller = new AnimationController(duration: Duration(milliseconds: maxTime), vsync: this);
    _controller.addStatusListener((AnimationStatus status) {
      if (widget.loop && status == AnimationStatus.completed) {
        _controller.forward(from: 0.0); // 完成后重新开始
      }

      setState(() {
        _status = status;
      });
    });

    _animation = new Tween<double>(begin: 0, end: imageCount.toDouble()).animate(_controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    if (widget.start) {
      _controller.forward();
    }
  }

  void start() => _controller.forward();
  void stop() => _controller.stop();
  void reset() => _controller.reset();
  void reStart() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void didUpdateWidget(FrameAnimationImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget called");
    if (widget.start) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int ix = _animation.value.floor() % widget._assetList.length;

    List<Widget> images = [];

    if (_status == AnimationStatus.completed) {
      images.add(
        Image.asset(
          widget._assetList.last,
          width: widget.width,
          height: widget.height,
        ),
      );
    } else {
      // 把所有图片都加载进内容，否则每一帧加载时会卡顿
      for (int i = 0; i < widget._assetList.length; ++i) {
        if (i != ix) {
          images.add(
            Image.asset(
              widget._assetList[i],
              width: 0,
              height: 0,
            ),
          );
        }
      }

      images.add(
        Image.asset(
          widget._assetList[ix],
          width: widget.width,
          height: widget.height,
        ),
      );
    }

    return Stack(alignment: AlignmentDirectional.center, children: images);
  }
}
