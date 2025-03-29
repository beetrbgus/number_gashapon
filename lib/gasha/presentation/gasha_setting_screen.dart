import 'package:flutter/material.dart';
import 'package:number_gashapon/core/design_system/styles/app_text_theme.dart';
import 'package:number_gashapon/gasha/data/gasha_setting.dart';
import 'package:number_gashapon/gasha/presentation/gashapon_screen.dart';
import 'package:number_gashapon/gen_assets/assets.gen.dart';

class GaShaSettingScreen extends StatefulWidget {
  final TextEditingController? startNumberTextController;
  final TextEditingController? endNumberTextController;
  const GaShaSettingScreen({
    super.key,
    this.startNumberTextController,
    this.endNumberTextController,
  });

  @override
  State<GaShaSettingScreen> createState() => _GaShaSettingScreenState();
}

class _GaShaSettingScreenState extends State<GaShaSettingScreen> {
  late final TextEditingController _startNumberTextController;
  late final TextEditingController _endNumberTextController;

  late final FocusNode _startNumberFocusNode;
  late final FocusNode _endNumberFocusNode;

  bool _isDuplicateAllow = false;

  @override
  void initState() {
    super.initState();
    _startNumberTextController =
        widget.startNumberTextController ?? TextEditingController();
    _startNumberTextController.text = "1";
    _startNumberFocusNode = FocusNode();

    _endNumberTextController =
        widget.endNumberTextController ?? TextEditingController();
    _endNumberTextController.text = "20";
    _endNumberFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    _startNumberTextController.dispose();
    _endNumberTextController.dispose();

    _startNumberFocusNode.dispose();
    _endNumberFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            width: 600,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "설정",
                  style: AppTextTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 50),
                // 시작 번호
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "시작 번호",
                        style: AppTextTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Flexible(
                      child: TextField(
                        controller: _startNumberTextController,
                        focusNode: _startNumberFocusNode,
                        style: AppTextTheme.bodyMedium,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ), // 검은색 테두리
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // 끝 번호
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "마지막 번호",
                        style: AppTextTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    Flexible(
                      child: TextField(
                        controller: _endNumberTextController,
                        focusNode: _endNumberFocusNode,
                        style: AppTextTheme.bodyMedium,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ), // 검은색 테두리
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // 중복 여부
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "중복 허용",
                        style: AppTextTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: _isDuplicateAllow,
                      onChanged: (check) {
                        setState(() {
                          _isDuplicateAllow = check ?? false;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 50),

                ElevatedButton(
                  onPressed: () {
                    final gaShaSetting = GaShaSetting(
                      startNumber: int.parse(_startNumberTextController.text),
                      endNumber: int.parse(_endNumberTextController.text),
                      isDuplicate: _isDuplicateAllow,
                    );

                    // GaShaPonScreen으로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                GaShaPonScreen(gaShaSetting: gaShaSetting),
                      ),
                    );
                  },
                  child: const Text('시작하기'),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Assets.icons.settingBackground.image(height: 200)],
                ),
                Text(
                  "copyright : devbeetrb0214@gmail.com",
                  style: AppTextTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
