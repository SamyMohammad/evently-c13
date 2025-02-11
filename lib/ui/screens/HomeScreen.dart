import 'package:evently_c13/core/app_colors.dart';
import 'package:evently_c13/core/dialog_utils.dart';
import 'package:evently_c13/db/dao/events_dao.dart';
import 'package:evently_c13/db/model/AppUser.dart';
import 'package:evently_c13/db/model/event_model.dart';
import 'package:evently_c13/db/model/event_type_model.dart';
import 'package:evently_c13/providers/AuthProvider.dart';
import 'package:evently_c13/ui/screens/add_event_screen.dart';
import 'package:evently_c13/ui/screens/login_screen.dart';
import 'package:evently_c13/ui/screens/tabs/favorite/favorite_tab.dart';
import 'package:evently_c13/ui/screens/tabs/home/home_tab.dart';
import 'package:evently_c13/ui/screens/tabs/map/map_tab.dart';
import 'package:evently_c13/ui/screens/tabs/profile/profile_tab.dart';
import 'package:evently_c13/ui/widgets/events_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0;
  int _selectedEventTypeIndex = 0;

  void _onTopBarTabClick(int index) {
    setState(() {
      _selectedEventTypeIndex = index;
    });
  }

  void _onBottomNavBarTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }


  @override
  initState() {
    super.initState();
  }
  var eventTypes = EventType.getEventTypes();

  List<Widget?> bottomNavTabs = [
    null,
    MapTab(),
    FavoriteTab(),
    ProfileTab(),
  ];
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    var authProvider = Provider.of<AuthProvider>(context);
    print(authProvider.appUser);
    return SafeArea(
      child: DefaultTabController(
        length: eventTypes.length,
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(
              side: BorderSide(color: AppColors.white, width: 5),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AddEventScreen.routeName);
            },
            backgroundColor: AppColors.purple,
            child: const Icon(
              Icons.add,
              color: AppColors.white,
              size: 30,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.purple,
            selectedItemColor: AppColors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: AppColors.purple,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                label: 'Map',
                backgroundColor: AppColors.purple,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border),
                label: 'Love',
                backgroundColor: AppColors.purple,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: AppColors.purple,
              ),
            ],
              currentIndex: _selectedTabIndex,
              onTap: _onBottomNavBarTapped,
            ),
          appBar: AppBar(
            toolbarHeight: height * 0.15,
            backgroundColor: AppColors.purple,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            centerTitle: false,
              bottom: _selectedTabIndex == 0
                  ? TabBar(
                      unselectedLabelColor: AppColors.white,
              labelColor: AppColors.purple,
              indicatorSize: TabBarIndicatorSize.label,
              dividerHeight: 0,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.white),
                      onTap: _onTopBarTabClick,
                      isScrollable: true,
              tabs: [
                ...eventTypes.map((eventType) => Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        spacing: 8,
                        children: [eventType.icon, Text(eventType.name)],
                      ),
                    ))
              ],
                    )
                  : null,
              title: buildAppBarTitle(authProvider.appUser),
              actions: buildAppBarActions,
          ),
            body: _selectedTabIndex == 0
                ? HomeTab(eventTypes[_selectedEventTypeIndex])
                : bottomNavTabs[_selectedTabIndex]),
      ),
    );
  }


  List<Widget> get buildAppBarActions {
    return [
      IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.wb_sunny_outlined,
            color: AppColors.white,
            size: 30,
          )),
      IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: AppColors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          icon: const Text("EN",
              style: TextStyle(
                  color: AppColors.purple,
                  fontSize: 20,
                  fontWeight: FontWeight.w400))),
    ];
  }

  Column buildAppBarTitle(AppUser? appUser) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome Back ✨",
          style: TextStyle(
              fontSize: 16,
              color: AppColors.white,
              fontWeight: FontWeight.w400),
        ),
        Text(
          appUser?.name ?? "",
          style: TextStyle(
              fontSize: 25,
              color: AppColors.white,
              fontWeight: FontWeight.w700),
        ),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: AppColors.white,
            ),
            Text(
              "Cairo, Egypt",
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white,
                  fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }

  void logout() {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    showMessageDialog("Please Confirm logout", posActionTitle: "logout",
        posAction: () {
      authProvider.logout();
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }, negActionTitle: "cancel");
  }
}
