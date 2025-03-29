import 'dart:math';

import 'package:flutter/material.dart';
import 'package:number_gashapon/core/design_system/styles/app_text_theme.dart';
import 'package:number_gashapon/gasha/data/gasha_setting.dart';
import 'package:number_gashapon/gasha/presentation/gasha_setting_screen.dart';
import 'package:number_gashapon/gen_assets/assets.gen.dart';

class GaShaPonScreen extends StatefulWidget {
  final GaShaSetting gaShaSetting;
  const GaShaPonScreen({super.key, required this.gaShaSetting});

  final String title = "랜덤 숫자 뽑기";

  @override
  State<GaShaPonScreen> createState() => _GaShaPonScreenState();
}

class _GaShaPonScreenState extends State<GaShaPonScreen>
    with TickerProviderStateMixin {
  late AnimationController _switchController;

  late AnimationController _gaShaPonShakeController;
  late Animation<double> _gaShaPonShakeAnimation;

  late AnimationController _capsuleScaleController;
  late Animation<double> _capsuleScale;

  bool _showCapsule = false;
  bool _showRandomNumber = false;

  Color? _switchColor;
  final Random _random = Random();

  List<int> gaShaNumberList = [];
  int _randomNumber = 0;

  late List<int> availableNumbers;

  void _onTap() {
    if (availableNumbers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("뽑을 숫자가 없습니다!")));
      return;
    }

    _pickRandomNumber();

    _gaShaPonShakeController.forward().then((_) {
      setState(() {
        _showCapsule = true;
      });
      _gaShaPonShakeController.reverse();

      _capsuleScaleController
          .forward()
          .then((_) => _capsuleScaleController.reverse())
          .then((_) {
            setState(() {
              _showCapsule = false;
            });
          })
          .then((_) {
            setState(() {
              _showRandomNumber = true;
            });
          });
    });
  }

  void _pickRandomNumber() {
    int randomIndex = _random.nextInt(availableNumbers.length);
    int pickedNumber = availableNumbers[randomIndex];

    // 뽑은 숫자는 다시 나오지 않게 리스트에서 제거
    setState(() {
      _randomNumber = pickedNumber;
      availableNumbers.removeAt(randomIndex);
      gaShaNumberList.add(pickedNumber);
    });
  }

  @override
  void initState() {
    super.initState();

    final gaShaSetting = widget.gaShaSetting;

    availableNumbers = List.generate(
      gaShaSetting.endNumber - gaShaSetting.startNumber + 1,
      (index) => gaShaSetting.startNumber + index,
    );

    // 스위치 돌아가는 애니메이션 컨트롤러
    _switchController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    // 뽑기 흔들림 컨트롤러
    _gaShaPonShakeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // 캡슐 크기 컨트롤러
    _capsuleScaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // 캡슐 크기 애니메이션
    _capsuleScale = Tween<double>(begin: 0.3, end: 3.5).animate(
      CurvedAnimation(
        parent: _capsuleScaleController,
        curve: Curves.easeOutBack,
      ),
    );

    _gaShaPonShakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.03), weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: 0.03, end: -0.03), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.03, end: 0.0), weight: 0.5),
    ]).animate(_gaShaPonShakeController);
  }

  @override
  void dispose() {
    _switchController.dispose();
    _gaShaPonShakeController.dispose();
    _capsuleScaleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title, style: AppTextTheme.headline3),
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => GaShaSettingScreen()),
                );
              },
            ),
            Flexible(
              child: Text(
                '홈',
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.caption,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Text("초기화"),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 40),
                        color: Colors.redAccent.withOpacity(0.2),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "뽑은 숫자",
                              style: AppTextTheme.bodyLarge.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              runSpacing: 8, // 세로 간격
                              children:
                                  gaShaNumberList.map((pickedNumber) {
                                    return Container(
                                      width: 40, // 숫자 칸 크기
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 3,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        "$pickedNumber",
                                        style: AppTextTheme.bodyMedium,
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 2,
                      child: LayoutBuilder(
                        builder: (context, boxConstraints) {
                          double maxWidth = min(boxConstraints.maxWidth, 400);
                          double maxHeight =
                              min(boxConstraints.maxHeight, 400) * 1.2;

                          double switchSize = maxWidth * 0.15;

                          return SizedBox(
                            width: maxWidth,
                            height: maxHeight,
                            child: AnimatedBuilder(
                              animation: _gaShaPonShakeAnimation,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle: _gaShaPonShakeAnimation.value,
                                  origin: Offset(0, maxWidth / 2),
                                  child: child,
                                );
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Assets.icons.gashapon.image(
                                    width: maxWidth,
                                    height: maxWidth,
                                    fit: BoxFit.contain,
                                  ),
                                  Positioned(
                                    top: maxHeight * 0.61,
                                    left: maxWidth * 0.43,
                                    child: MouseRegion(
                                      onEnter: (event) {
                                        setState(() {
                                          _switchColor = Colors.amber
                                              .withOpacity(0.05);
                                        });
                                      },
                                      onExit: (event) {
                                        setState(() {
                                          _switchColor = null;
                                        });
                                      },
                                      child: GestureDetector(
                                        onTap: _onTap,
                                        child: RotationTransition(
                                          turns: _switchController,
                                          child: Assets.icons.gaShaPonSwitch
                                              .image(
                                                width: switchSize,
                                                height: switchSize,
                                                fit: BoxFit.contain,
                                                color: _switchColor
                                                    ?.withOpacity(0.2),
                                                colorBlendMode:
                                                    BlendMode.srcATop,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: maxWidth * 1.05,
                                    left: maxWidth * 0.3,
                                    child: Assets.icons.capsule.image(
                                      width: maxWidth * 0.15,
                                      height: maxWidth * 0.13,
                                      fit: BoxFit.contain,
                                    ),
                                  ),

                                  if (_showCapsule)
                                    Positioned(
                                      top: maxWidth * 0.9,
                                      child: ScaleTransition(
                                        scale: _capsuleScale,
                                        child: Assets.icons.capsule.image(
                                          width: switchSize,
                                          height: maxWidth * 0.13,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  if (_showRandomNumber)
                                    Positioned(
                                      top: maxWidth * 0.5,
                                      child: Text(
                                        '$_randomNumber',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
