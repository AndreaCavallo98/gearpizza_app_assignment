import 'package:gearpizza/core/models/rive_model.dart';

class NavItemModel {
  final String title;
  final RiveModel rive;

  NavItemModel({required this.title, required this.rive});
}

List<NavItemModel> bottomNavItems = [
  NavItemModel(
    title: "Home",
    rive: RiveModel(
      src: "assets/animated_icons.riv",
      artboard: "HOME",
      stateMachineName: "HOME_interactivity",
    ),
  ),
  NavItemModel(
    title: "Timer",
    rive: RiveModel(
      src: "assets/animated_icons.riv",
      artboard: "TIMER",
      stateMachineName: "TIMER_Interactivity",
    ),
  ),
];
