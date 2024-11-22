import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavbarCubit extends Cubit<NavbarState> {
  NavbarCubit() : super(TabHomeState());

  void setHomeTab() {
    emit(TabHomeState());
  }

  void setBookmarkTab() {
    emit(TabBookmarkState());
  }

  void setNotificationTab() {
    emit(TabNotificationState());
  }

  void setNotesTab() {
    emit(TabNotesState());
  }


  int getCurrentTabIndex() {
    if (state is TabHomeState) {
      return 0;
    } else if (state is TabNotificationState) {
      return 1;
    } else if (state is TabBookmarkState) {
      return 2;
    } else if (state is TabNotesState) {
      return 3;
    }
    return 0;
  }
}



abstract class NavbarState extends Equatable {
  const NavbarState();
}

class TabHomeState extends NavbarState {
  final index = 0;

  @override
  List<Object> get props => [index];
}

class TabBookmarkState extends NavbarState {
  final index = 1;

  @override
  List<Object> get props => [index];
}

class TabNotificationState extends NavbarState {
  final index = 2;

  @override
  List<Object> get props => [index];
}

class TabNotesState extends NavbarState {
  final index = 3;

  @override
  List<Object> get props => [index];
}


