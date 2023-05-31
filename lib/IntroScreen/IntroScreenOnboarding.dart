import 'package:adpluginx/IntroScreen/CircleProgressBar.dart';
import 'package:adpluginx/IntroScreen/Introduction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A IntroScreen Class.

class IntroScreenOnboarding extends StatefulWidget {
  final List<Introduction>? introductionList;
  final Color? backgroudColor;
  final Color? foregroundColor;
  final TextStyle? skipTextStyle;
  final Function()? onPlanOpen;

  /// Callback on Skip Button Pressed
  final Function()? onTapSkipButton;

  const IntroScreenOnboarding({
    Key? key,
    this.introductionList,
    this.onTapSkipButton,
    this.onPlanOpen,
    this.backgroudColor,
    this.foregroundColor,
    this.skipTextStyle = const TextStyle(fontSize: 20),
  }) : super(key: key);

  @override
  _IntroScreenOnboardingState createState() => _IntroScreenOnboardingState();
}

class _IntroScreenOnboardingState extends State<IntroScreenOnboarding> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  double progressPercent = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          color: widget.backgroudColor ?? Theme.of(context).backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: widget.onTapSkipButton,
                        child: Text('Skip', style: widget.skipTextStyle),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    height: 550.0,
                    child: PageView(
                      physics: const ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                        if (_currentPage ==
                            ((widget.introductionList ?? []).length - 1)) {
                          if (widget.onPlanOpen != null) {
                            widget.onPlanOpen!();
                          }
                        }
                      },
                      children: widget.introductionList!,
                    ),
                  ),
                ),
                _currentPage == ((widget.introductionList ?? []).length - 1)
                    ? _customAppButton()
                    : _customProgress(),
                //_buildNextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customAppButton() {
    return Column(
      children: [
        MaterialButton(
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
          minWidth: 0.5.sw,
          color: Colors.redAccent,
          onPressed: widget.onPlanOpen,
          child: const Text(
            "See Plans",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _customProgress() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CircleProgressBar(
            backgroundColor: Colors.white,
            foregroundColor:
                widget.foregroundColor ?? Theme.of(context).primaryColor,
            value: ((_currentPage + 1) * 1.0 / widget.introductionList!.length),
          ),
        ),
        Container(
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (widget.foregroundColor ?? Theme.of(context).primaryColor)
                .withOpacity(0.5),
          ),
          child: IconButton(
            onPressed: () {
              _currentPage != widget.introductionList!.length - 1
                  ? _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    )
                  : widget.onTapSkipButton!();
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
            iconSize: 15,
          ),
        )
      ],
    );
  }
}
