import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:vital_bloom/screens/home/home_screen.dart';
import 'package:vital_bloom/screens/profile/profile_screen.dart';

import '../../models/user.dart';
import '../../utils/colors.dart';

class HomeNavigationWrapper extends StatefulWidget {
  final User user;
  const HomeNavigationWrapper({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeNavigationWrapper> createState() => HomeNavigationWrapperState();
}

class HomeNavigationWrapperState extends State<HomeNavigationWrapper> {
  late final List<Widget> _stacks;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  // void openDrawer() {
  //   _key.currentState?.openDrawer();
  // }

  @override
  void initState() {
    _stacks = [
      HomeScreen(),
      HomeScreen(),
      ProfileScreen(user: widget.user),
    ];
    super.initState();
  }

  int currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: LazyLoadIndexedStack(
        children: _stacks,
        index: currentIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // unselectedLabelStyle: TextStyle(color: AppColors.dark, fontSize: 12),
        onTap: (int index) {
          setCurrentIndex(index);
        },
        items: [
          _buildNavigationBarItem(index: 0, name: "home"),
          _buildNavigationBarItem(index: 1, name: "dashboard"),
          _buildNavigationBarItem(index: 2, name: "profile"),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        backgroundColor: AppColors.white,
        elevation: 10,
        showSelectedLabels: false,
        showUnselectedLabels: true,
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem({
    required int index,
    required String name,
  }) {
    return BottomNavigationBarItem(
        icon: SvgPicture.asset(
          'assets/navigation/$name.svg',
          height: 20,
        ),
        label: name,
        activeIcon: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.dark,
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 0,
                    color: AppColors.black.withOpacity(0.25)),
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 4,
                    spreadRadius: 4,
                    color: AppColors.black.withOpacity(0.05))
              ]),
          child: SvgPicture.asset(
            'assets/navigation/$name.svg',
            height: 20,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ));
  }
}
