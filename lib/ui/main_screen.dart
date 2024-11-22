import 'package:bookmyevent/bloc/navbar_cubit.dart';
import 'package:bookmyevent/core/app_color.dart';
import 'package:bookmyevent/core/app_images.dart';
import 'package:bookmyevent/core/app_strings.dart';
import 'package:fade_indexed_stack/fade_indexed_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime? lastPressed;


  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),  // Stay in the app
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),  // Exit the app
            child: const Text('Exit'),
          ),
        ],
      ),
    ) ?? false;  // Return false if the dialog is dismissed without choice
  }

  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () async {
          // Handle back button or gesture.
          // Return false to prevent app from being killed.
          return true;
        },/*PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        showExitConfirmationDialog(context);

      },*/
      child: BlocBuilder<NavbarCubit, NavbarState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              alignment: Alignment.center,
              children: [
                FadeIndexedStack(
                  duration: const Duration(milliseconds: 500),
                  index: context.read<NavbarCubit>().getCurrentTabIndex(),
                  children: const [
                    /*TabHomeScreen(),
                    TabBookmarksScreen(),
                    TabNotificationScreen(),
                    TabNotesScreen(),*/
                  ],
                ),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                color: AppColors.primaryColor,
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: false,
                elevation: 0,
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.white,
                currentIndex: context.read<NavbarCubit>().getCurrentTabIndex(),
                onTap: (index) {
                  changeTabIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppImages.icTabHome,
                    ),
                    label: AppStrings.tabHome,
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppImages.icTabBookmark,
                    ),
                    label: AppStrings.tabBookmark,
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppImages.icTabNotification,
                    ),
                    label: AppStrings.tabNotification,
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      AppImages.icTabNotes,
                    ),
                    label: AppStrings.tabNotes,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget tabItem(int tabIndex, String tabName, String tabIcon) {
    return Expanded(
      child: InkWell(
        onTap: () {
          changeTabIndex(tabIndex);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              tabIcon,
              height: 30,
              width: 30,
            ),
            Visibility(
              visible:
                  context.read<NavbarCubit>().getCurrentTabIndex() == tabIndex,
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    tabName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    /* style: Constants.textStyle(
                        size: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white),*/
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// when tab index is change update state of bottom sheet
  void changeTabIndex(int index) async {
    if (index == 0) {
      context.read<NavbarCubit>().setHomeTab();
    } else if (index == 1) {
      context.read<NavbarCubit>().setNotificationTab();
    } else if (index == 2) {
      context.read<NavbarCubit>().setBookmarkTab();
    } else if (index == 3) {
      context.read<NavbarCubit>().setNotesTab();
    }
  }
}
