import 'package:flutter/material.dart';
import 'package:to_do_list/api/remove_activity_groups_api_listener.dart';
import 'package:to_do_list/api/remove_activity_groups_api_services.dart';
import 'package:to_do_list/models/activity_groups_model.dart';
import '../api/list_activity_groups_api_listener.dart';
import '../api/list_activity_groups_api_services.dart';
import '../componets/custom_dialog_information.dart';
import '../componets/custom_loader.dart';
import '../helper/constants.dart';
import 'package:get/get.dart';

class ListActivityGroupsController extends GetxController
    implements ListActivityGroupsApiListener, RemoveActivityGroupsApiListener {
  RxBool isLoading = true.obs;
  RxBool isError = false.obs;
  RxString errorMsg = Constants.ERROR_SERVER.obs;
  RxString errorImg = Constants.ERROR_IMAGE.obs;
  RxList responseList = [].obs;

  onRefresh() {
    isLoading.value = true;
    responseList.clear();
    isError.value = false;
    ListActivityGroupsApiServices(this).getListActivityGroups();
  }

  onRemoveActivityGroups(String id) {
    Get.generalDialog(
      pageBuilder: (context, animation, secondaryAnimation) {
        return const CustomLoader();
      },
    );

    RemoveActivityGroupsApiServices(this).delRemoveActivityGroups(id);
  }

  @override
  void onInit() {
    ListActivityGroupsApiServices(this).getListActivityGroups();
    super.onInit();
  }

  @override
  onListActivityGroupsFailure(response, statusCode) {
    isLoading.value = false;
    isError.value = true;
    responseList.clear();
    errorMsg.value = Constants.ERROR_SERVER;
    errorImg.value = Constants.ERROR_IMAGE;
    Get.generalDialog(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CustomDialogInformation(
          onTap: () {
            Get.back();
          },
          title: "modal-information",
          desc: Constants.ERROR_SERVER,
          color: Colors.red,
          icon: Icons.error_outline,
        );
      },
    );
  }

  @override
  onListActivityGroupsSuccess(response, statusCode) {
    final activityGroups = ActivityGroupsModel.fromJson(response);
    responseList.addAll(activityGroups.data!);
    isError.value = false;
    isLoading.value = false;
  }

  @override
  onNoInternetConnection() {
    if (isLoading.value) {
      isLoading.value = false;
      isError.value = true;
      responseList.clear();
      errorMsg.value = Constants.NO_CONNECTION;
      errorImg.value = Constants.NOT_CONNECTION_IMAGE;
    } else {
      Get.back();
    }
    Get.generalDialog(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CustomDialogInformation(
          onTap: () {
            Get.back();
          },
          title: "modal-information",
          desc: Constants.NO_CONNECTION,
          color: Colors.orange,
          icon: Icons.error_outline,
        );
      },
    );
  }

  @override
  onRemoveActivityGroupsFailure(response, statusCode) {
    Get.back();
    Get.generalDialog(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CustomDialogInformation(
          onTap: () {
            Get.back();
          },
          title: "modal-information",
          desc: "Activity gagal dihapus",
          color: Colors.red,
          icon: Icons.error_outline,
        );
      },
    );
  }

  @override
  onRemoveActivityGroupsSuccess(response, statusCode) {
    Get.back();
    onRefresh();
    Get.generalDialog(
      pageBuilder: (context, animation, secondaryAnimation) {
        return CustomDialogInformation(
          onTap: () {
            Get.back();
          },
          title: "modal-information",
          desc: "Activity berhasil dihapus",
          color: Colors.green,
          icon: Icons.check_circle_outline,
        );
      },
    );
  }
}
