import 'package:flutter/material.dart';
import 'package:number_gashapon/core/design_system/styles/app_text_theme.dart';
import 'package:number_gashapon/gen_assets/assets.gen.dart';

class GaShaPon extends StatefulWidget {
  const GaShaPon({super.key});

  final String title = "랜덤 숫자 뽑기";

  @override
  State<GaShaPon> createState() => _GaShaPonState();
}

class _GaShaPonState extends State<GaShaPon> with TickerProviderStateMixin {
  late AnimationController _switchController;
  late AnimationController _gaShaPonShakeController;
  late Animation<double> _gaShaPonShakeAnimation;

  late AnimationController _capsuleScaleController;
  late Animation<double> _capsuleScale;

  bool _showCapsule = false;

  Color? _switchColor;

  void _onTap() {
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
          });
    });
  }

  @override
  void initState() {
    super.initState();
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
      ),
      body: SingleChildScrollView(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth =
                  constraints.maxWidth > 400 ? 400 : constraints.maxWidth;

              return SizedBox(
                width: maxWidth,
                height: maxWidth * 1.2,
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
                        top: maxWidth * 0.735,
                        child: MouseRegion(
                          onEnter: (event) {
                            setState(() {
                              _switchColor = Colors.amber.withOpacity(0.05);
                            });
                          },
                          onExit: (event) {
                            setState(() {
                              _switchColor = null;
                            });
                          },
                          child: GestureDetector(
                            onTap: _onTap,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(35),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: RotationTransition(
                                turns: _switchController,
                                child: SizedBox(
                                  width: maxWidth * 0.15,
                                  height: maxWidth * 0.15,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Assets.icons.gaShaPonSwitch.image(
                                          fit: BoxFit.contain,
                                          color: _switchColor?.withOpacity(0.3),
                                          colorBlendMode: BlendMode.srcATop,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
                              width: maxWidth * 0.15,
                              height: maxWidth * 0.13,
                              fit: BoxFit.contain,
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
      ),
    );
  }
}
