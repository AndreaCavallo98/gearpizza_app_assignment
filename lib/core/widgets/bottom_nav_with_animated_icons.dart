import 'package:flutter/material.dart';
import 'package:gearpizza/core/models/nav_item_model.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';

const Color bottomNavBgColor = Color(0xff17203A);

class BottomNavWithAnimatedIcons extends StatefulWidget {
  final Widget child;
  const BottomNavWithAnimatedIcons({super.key, required this.child});

  @override
  State<BottomNavWithAnimatedIcons> createState() =>
      _BottomNavWithAnimatedIconsState();
}

class _BottomNavWithAnimatedIconsState
    extends State<BottomNavWithAnimatedIcons> {
  List<SMIBool> riveIconinputs = [];
  List<StateMachineController?> controllers = [];
  int selectedNavIndex = 0;

  final List<String> routes = ['/restaurants', '/orders'];

  void animateTheIcon(int index) {
    riveIconinputs[index].change(true);
    Future.delayed(Duration(seconds: 1), () {
      riveIconinputs[index].change(false);
    });
  }

  void riveIconInit(Artboard artboard, {required String stateMachineName}) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      stateMachineName,
    );

    if (controller == null) {
      debugPrint('❌ StateMachineController not found: $stateMachineName');
      return;
    }

    artboard.addController(controller);
    controllers.add(controller);

    final input = controller.findInput<bool>('active');
    if (input == null) {
      debugPrint(
        '❌ Input "active" not found in state machine: $stateMachineName',
      );
      return;
    }

    riveIconinputs.add(input as SMIBool);
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bottomNavBgColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: bottomNavBgColor.withOpacity(0.3),
                offset: const Offset(0, 20),
                blurRadius: 20,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(bottomNavItems.length, (index) {
              final riveIcon = bottomNavItems[index].rive;
              return GestureDetector(
                onTap: () {
                  context.go(routes[index]);
                  animateTheIcon(index);
                  setState(() => selectedNavIndex = index);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBar(isActive: index == selectedNavIndex),
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: Opacity(
                        opacity: index == selectedNavIndex ? 1 : 0.5,
                        child: RiveAnimation.asset(
                          riveIcon.src,
                          artboard: riveIcon.artboard,
                          onInit: (artboard) {
                            riveIconInit(
                              artboard,
                              stateMachineName: riveIcon.stateMachineName,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 2),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
        color: Color(0xfff95f60),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
