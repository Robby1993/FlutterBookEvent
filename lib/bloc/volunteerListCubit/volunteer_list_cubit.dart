/*
import 'package:churchapp/bloc/volunteerListCubit/volunteer_list_state.dart';
import 'package:churchapp/common_methods.dart';
import 'package:churchapp/core/app_strings.dart';
import 'package:churchapp/data/common_response_model.dart';
import 'package:churchapp/data/volunteer_response_model.dart';
import 'package:churchapp/provider/internet_provider.dart';
import 'package:churchapp/repo/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class VolunteerListCubit extends Cubit<VolunteerListState> {
  final ProfileRepository repository;

  VolunteerListCubit(this.repository) : super(InitialVolunteerListState());

  int currentPage = 1;
  int pageSize = 10;
  bool hasMoreData = true;
  bool isLoadingMore = false;

  List<VolunteerResponseModel> finalListData = [];

// Update the method to accept pagination parameters
  void volunteerListApi({
    required BuildContext context,
    bool isLoader = true,
    bool isPagination = false, // New parameter to handle pagination
    String search = "",
  }) async {
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    */
/* if (ip.hasInternet == false) {
      emit(NoInternetState());
      return;
    }*//*


    /// show loader only first page
    if (isLoader && !isPagination) {
      finalListData.clear();
      emit(LoadingVolunteerListState());
    }
    Map<String, dynamic> queryParams = {
      'page': isPagination ? currentPage : 1, // Use current page for pagination
      'perPage': pageSize,
      if (search.isNotEmpty) 'search': search,
    };
    try {
      debugPrint(
          "api calling-----------queryParams-------------------$queryParams");

      repository.volunteerList(context, queryParams).then((result) {
        if (result.isError == false) {
          List<dynamic> dynamicList = List<dynamic>.from(result.data["items"]);
          try {
            List<VolunteerResponseModel> newList = dynamicList.map((data) {
              return VolunteerResponseModel.fromJson(
                  Map<String, dynamic>.from(data));
            }).toList();

            // Append new data to existing data if paginating
            if (isPagination) {
              finalListData.addAll(newList);
            } else {
              finalListData = newList;
            }

            // Update pagination state
            if (dynamicList.length < pageSize) {
              // Assuming 50 is the perPage limit
              hasMoreData = false;
            }
            // hasMoreData = result.length >= pageSize; // Update hasMoreData based on result length

            if (!isPagination) {
              currentPage = 2; // Reset page number on new query
            } else {
              currentPage++; // Increment page number on pagination
            }
            emit(SuccessVolunteerListState(finalListData));
          } catch (e) {
            hasMoreData = false;
            emit(ErrorVolunteerListState(
              CommonResponseModel(
                message: e.toString(),
                code: 500,
                isError: true,
              ),
            ));
          }
        } else {
          hasMoreData = false;
          emit(ErrorVolunteerListState(result));
        }
      });
    } catch (e) {
      hasMoreData = false;
      emit(ErrorVolunteerListState(
        CommonResponseModel(
          message: e.toString(),
          code: 500,
          isError: true,
        ),
      ));
    }
    //  }
  }

  void removeUserItem(String churchId) {
    final currentState = state;
    List<VolunteerResponseModel> valueList = [];
    if (currentState is SuccessVolunteerListState) {
      valueList = currentState.resultList;
      valueList.removeWhere((element) => element.churchId == churchId);
      emit(SuccessVolunteerListState(valueList));
    }
  }

  Future<void> addVolunteer(BuildContext context, Object postObj,
      {String id = ""}) async {
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      CommonMethods.showSnackBar(context, AppStrings.toastInternetConnection);
      return;
    }
    try {
      if (id.isEmpty) {
        await repository.addNotes(context, postObj).then((result) {
          if (result.isError == false) {
            CommonMethods.showSnackBar(context, "Notes added successfully");
          } else {
            CommonMethods.showSnackBar(context, result.message ?? "");
          }
        });
      } else {
        await repository.updateNotes(context, postObj, id).then((result) {
          if (result.isError == false) {
            CommonMethods.showSnackBar(context, "Notes updated successfully");
          } else {
            CommonMethods.showSnackBar(context, result.message ?? "");
          }
        });
      }
    } catch (e) {
      debugPrint("joinChurch-----------${e.toString()}");
    }
  }

  Future<void> deleteNotes(BuildContext context, List<String> listIds) async {
    final ip = context.read<InternetProvider>();
    await ip.checkInternetConnection();
    if (ip.hasInternet == false) {
      CommonMethods.showSnackBar(context, AppStrings.toastInternetConnection);
      return;
    }
    listIds.removeWhere((element) => element == "-1");
    try {
      await repository.deleteNotes(context, listIds).then((result) {
        if (result.isError == false) {
        } else {}
      });
      */
/*  await Future.wait<void>(
        listIds.map((id) async {
          await repository.deleteNotes(context, id).then((result) {
            if (result.isError == false) {
            } else {}
          });
        }),
      );*//*

     */
/* context.read<VolunteerListCubit>().notesListApi(
        context: context,
        isPagination: false,
      );*//*

    } catch (e) {
      debugPrint("joinChurch-----------${e.toString()}");
    }
  }
}
*/
