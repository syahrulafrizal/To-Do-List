import 'dart:collection';
import '../api/list_activity_groups_api_listener.dart';
import '../helper/api_service_helper.dart';
import '../helper/constants.dart';

class ListActivityGroupsApiServices {
  ListActivityGroupsApiListener mApiListener;
  ListActivityGroupsApiServices(this.mApiListener);

  void onApiSuccess(responseBody, statusCode) {
    mApiListener.onListActivityGroupsSuccess(
      responseBody,
      statusCode,
    );
  }

  void onApiFailure(responseBody, statusCode) {
    mApiListener.onListActivityGroupsFailure(
      responseBody,
      statusCode,
    );
  }

  void onNoInternetConnection() {
    mApiListener.onNoInternetConnection();
  }

  getListActivityGroups() async {
    HashMap data = HashMap<String, dynamic>();
    data['email'] = Constants.MY_EMAIL;
    ApiServiceHelper().service(
      data,
      Constants.METHOD_TYPE_GET,
      "activity-groups",
      onApiSuccess,
      onApiFailure,
      onNoInternetConnection,
    );
  }
}
