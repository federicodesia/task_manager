class MyBottomNavigationBarItem{
  final String icon;
  final String selectedIcon;

  MyBottomNavigationBarItem({this.icon, this.selectedIcon});
}

List<MyBottomNavigationBarItem> bottomNavigationBarItems = [
  MyBottomNavigationBarItem(
    icon: "home_outlined",
    selectedIcon: "home_filled",
  ),
  MyBottomNavigationBarItem(
    icon: "calendar_outlined",
    selectedIcon: "calendar_filled",
  ),
  MyBottomNavigationBarItem(
    icon: "notification_outlined",
    selectedIcon: "notification_filled",
  ),
  MyBottomNavigationBarItem(
    icon: "settings_outlined",
    selectedIcon: "settings_filled",
  )
];