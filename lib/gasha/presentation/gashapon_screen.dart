import 'dart:math';

import 'package:flutter/material.dart';
import 'package:number_gashapon/core/design_system/styles/app_color.dart';
import 'package:number_gashapon/core/design_system/styles/app_text_theme.dart';
import 'package:number_gashapon/gasha/data/gasha_setting.dart';
import 'package:number_gashapon/gasha/presentation/gasha_setting_screen.dart';
import 'package:number_gashapon/gen_assets/assets.gen.dart';

class GaShaPonScreen extends StatefulWidget {
  final GaShaSetting gaShaSetting;
  const GaShaPonScreen({super.key, required this.gaShaSetting});

  final String title = "Boknam's 랜덤 숫자 뽑기";

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
  bool _isProcessing = false;

  Color? _switchColor;
  final Random _random = Random();

  List<int> gaShaNumberList = [];
  int _randomNumber = 0;

  late List<int> availableNumbers;

  void _onTap() {
    if (_isProcessing) return;
    _isProcessing = true;

    if (availableNumbers.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("뽑을 숫자가 없습니다!")));
      _isProcessing = false;
      return;
    }

    setState(() {
      _showRandomNumber = false;
    });

    int pickedNumber = _pickRandomNumber(widget.gaShaSetting.isDuplicate);

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
      })
      .then((_) {
        setState(() {
          gaShaNumberList.add(pickedNumber);
        });
      })
      .then((_) => _isProcessing = false);
    });
  }

  int _pickRandomNumber(bool isDuplicationAllow) {
    int randomIndex = _random.nextInt(availableNumbers.length);
    int pickedNumber = availableNumbers[randomIndex];

    // 중복 허용일 경우 제거하지 않음.
    if (isDuplicationAllow) {
      setState(() {
        _randomNumber = pickedNumber;
      });
    } else {
      // 허용하지 않으면 뽑은 숫자는 다시 나오지 않게 리스트에서 제거
      setState(() {
        _randomNumber = pickedNumber;
        availableNumbers.removeAt(randomIndex);
      });
    }
    return pickedNumber;
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
      backgroundColor: AppColors.white,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Row(
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "뽑은 숫자",
                                style: AppTextTheme.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 20),
                              Flexible(
                                child: GridView.builder(
                                  scrollDirection: Axis.vertical,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 8,
                                      ),
                                  itemCount: gaShaNumberList.length,
                                  itemBuilder: (context, index) {
                                    final pickedNumber = gaShaNumberList[index];
                                    return Container(
                                      width: 100,
                                      height: 100,
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
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Flexible(
                        flex: 2,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final boxMaxWidth = constraints.maxWidth;
                            final boxMaxHeight = constraints.maxHeight;

                            final gaShaPonSize =
                                boxMaxWidth < boxMaxHeight
                                    ? boxMaxWidth * 0.9
                                    : boxMaxHeight * 0.7;

                            final shakeOffset =
                                _gaShaPonShakeAnimation.value * gaShaPonSize;

                            return Center(
                              child: AnimatedBuilder(
                                animation: _gaShaPonShakeController,
                                builder: (context, child) {
                                  return Transform.rotate(
                                    angle: _gaShaPonShakeAnimation.value,
                                    alignment: Alignment.bottomCenter,
                                    child: SizedBox(
                                      width: gaShaPonSize,
                                      height: gaShaPonSize * 1.5,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        clipBehavior: Clip.none,
                                        children: [
                                          // 뽑기 본체
                                          Positioned(
                                            bottom: 0,
                                            child: Assets.icons.gashapon.image(
                                              width: gaShaPonSize,
                                              height: gaShaPonSize * 1.2,
                                              fit: BoxFit.contain,
                                            ),
                                          ),

                                          // 뽑기 손잡이
                                          Positioned(
                                            left: gaShaPonSize * 0.43,
                                            bottom: gaShaPonSize * 0.27,
                                            child: GestureDetector(
                                              onTap: _onTap,
                                              child: AnimatedBuilder(
                                                animation: _switchController,
                                                builder: (context, child) {
                                                  final switchSize =
                                                      gaShaPonSize * 0.15;
                                                  return Transform.rotate(
                                                    angle:
                                                        _switchController
                                                            .value *
                                                        2 *
                                                        pi,
                                                    child: Assets
                                                        .icons
                                                        .gaShaPonSwitch
                                                        .image(
                                                          width: switchSize,
                                                          height: switchSize,
                                                          fit: BoxFit.contain,
                                                        ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),

                                          // 뽑기 본체 하단 캡슐
                                          Positioned(
                                            left: gaShaPonSize * 0.23,
                                            bottom: -20,
                                            child: Assets.icons.capsule.image(
                                              width: gaShaPonSize * 0.15,
                                              height: gaShaPonSize * 0.15,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          // 캡슐 나오는 이미지
                                          if (_showCapsule)
                                            Positioned(
                                              top: gaShaPonSize * 0.9,
                                              child: ScaleTransition(
                                                scale: _capsuleScale,
                                                child: Assets.icons.capsule
                                                    .image(
                                                      width:
                                                          gaShaPonSize * 0.15,
                                                      height:
                                                          gaShaPonSize * 0.13,
                                                      fit: BoxFit.contain,
                                                    ),
                                              ),
                                            ),

                                          // 뽑은 랜덤 숫자 표시
                                          if (_showRandomNumber)
                                            Positioned(
                                              left: gaShaPonSize * 0.45,
                                              bottom: gaShaPonSize * 0.55,
                                              child: Center(
                                                child: SizedBox(
                                                  width: gaShaPonSize * 0.4,
                                                  height: gaShaPonSize * 0.4,
                                                  child: Text(
                                                    "$_randomNumber",
                                                    style:
                                                        AppTextTheme.headline2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
