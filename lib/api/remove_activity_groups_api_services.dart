import 'dart:collection';
import '../helper/api_service_helper.dart';
import '../helper/constants.dart';
import 'remove_activity_groups_api_listener.dart';

class RemoveActivityGroupsApiServices {
  RemoveActivityGroupsApiListener mApiListener;
  RemoveActivityGroupsApiServices(this.mApiListener);

  void onApiSuccess(responseBody, statusCode) {
    mApiListener.onRemoveActivityGroupsSuccess(
      responseBody,
      statusCode,
    );
  }

  void onApiFailure(responseBody, statusCode) {
    mApiListener.onRemoveActivityGroupsFailure(
      responseBody,
      statusCode,
    );
  }

  void onNoInternetConnection() {
    mApiListener.onNoInternetConnection();
  }

  delRemoveActivityGroups(String id) async {
    HashMap data = HashMap<String, dynamic>();
    data['id'] = id;
    ApiServiceHelper().service(
      data,
      Constants.METHOD_TYPE_DELETE,
      "activity-groups",
      onApiSuccess,
      onApiFailure,
      onNoInternetConnection,
    );
  }
}
