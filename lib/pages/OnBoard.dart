import 'package:animations/animations.dart';
import 'package:to_do_list/services/database/AppData.dart';
import 'package:to_do_list/services/database/maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  final _controller = PageController();

  bool lastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: EdgeInsets.fromLTRB(
            0, 0, 0, (Device.screenHeight / 17).round() * 1),
        child: lastPage
            ? getStarted()
            : Row(
                children: [
                  const Spacer(),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    onDotClicked: (index) => _controller.animateToPage(
                      index,
                      duration: const Duration(
                        milliseconds: 600,
                      ),
                      curve: Curves.easeIn,
                    ),
                    effect: WormEffect(
                      activeDotColor:
                          Theme.of(context).colorScheme.secondaryFixed,
                      dotHeight: (Device.screenWidth * 0.03).round() * 1,
                      dotWidth: (Device.screenWidth * 0.03).round() * 1,
                      dotColor: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        SizedBox(
                          width: (Device.screenWidth * 0.25).round() * 1,
                        ),
                        IconButton(
                          onPressed: () => _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          ),
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: Device.pixelRatio * 10,
                            color: Theme.of(context).colorScheme.secondaryFixed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: (Device.screenHeight * 0.0127).round() * 1,
            ),
            child: PageView.builder(
              onPageChanged: (index) => setState(
                () {
                  lastPage = (index == displayPage.length - 1);
                },
              ),
              itemCount: displayPage.length,
              controller: _controller,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget? child) =>
                      PageTransitionSwitcher(
                    transitionBuilder:
                        (child, primaryAnimation, secondaryAnimation) =>
                            SharedAxisTransition(
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      animation: primaryAnimation,
                      child: child,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: (Device.screenHeight * 0.127).round() * 1,
                        ),
                        SizedBox(
                          width: Device.screenWidth,
                          height: (Device.screenWidth * 0.9).round() * 1,
                          child: SvgPicture.asset(
                            "assets/images/onBoard/${displayPage[index].background}",
                          ),
                        ),
                        Container(
                          alignment: const Alignment(0, 0.7),
                          child: Text(
                            displayPage[index].title,
                            style: const TextStyle(
                              fontFamily: 'LexendDeca',
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: (Device.screenHeight * 0.0205).round() * 1,
                        ),
                        Text(
                          displayPage[index].description,
                          style: const TextStyle(
                              fontFamily: 'LexendDeca',
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Color.fromARGB(255, 110, 106, 124)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 46,
            right: (Device.screenWidth / 50).round() * 1,
            child: lastPage
                ? const SizedBox()
                : SizedBox(
                    height: (Device.screenHeight / 21).round() * 1,
                    width: (Device.screenWidth / 6).round() * 1,
                    child: TextButton(
                      onPressed: () => _controller.animateToPage(
                        displayPage.length - 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn,
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: TextStyle(
                            fontFamily: 'LexendDeca',
                            fontSize: 18,
                            fontWeight: Device.menuFont),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget getStarted() {
    return SizedBox(
      width: (Device.screenWidth * 0.85).round() * 1,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(),
          backgroundColor: Theme.of(context).colorScheme.secondaryFixed,
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        onPressed: () async => {
          MainData.isAllarmOn = await isAlarmAllowed(),
          await sqlDB.update('MainData',
              {'isAllarmOn': toInt(MainData.isAllarmOn)}, 'id=?', [1]),
          setState(
            () {
              MainData.startOnBoard = false;
            },
          ),
          await sqlDB.update('MainData', mainMap(), 'id=?', [1]),
          if (mounted)
            {
              if (Device.desktopPlatform)
                context.replaceNamed('NavigationMenu')
              else
                context.replaceNamed('HomeMenu'),
            }
        },
        child: Text(
          'Get Started!',
          style: TextStyle(
              fontFamily: 'LexendDeca',
              fontSize: 19,
              fontWeight: Device.menuFont),
        ),
      ),
    );
  }
}
