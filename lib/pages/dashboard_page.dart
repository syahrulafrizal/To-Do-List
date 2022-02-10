import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:to_do_list/controllers/list_activity_groups_controller.dart';

import '../componets/custom_dialog_question.dart';
import '../helper/constants.dart';
import '../helper/screen.dart';
import '../models/activity_groups_model.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Screen size = Screen(MediaQuery.of(context).size);
    final getxController = Get.put(ListActivityGroupsController());
    return Scaffold(
      appBar: AppBar(
        key: const ValueKey("app-bar"),
        title: Text(
          "To Do List App",
          style: TextStyle(fontSize: size.getWidthPx(18)),
          key: const ValueKey("header-title"),
        ),
      ),
      body: Obx(
        () {
          return getxController.isLoading.value
              ? const ContentLoading()
              : getxController.isError.value
                  ? const ContentError()
                  : const ContentSuccess();
        },
      ),
    );
  }
}

class ContentLoading extends StatelessWidget {
  const ContentLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: ValueKey("content-loading"),
      child: CircularProgressIndicator(),
    );
  }
}

class ContentError extends StatelessWidget {
  const ContentError({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final getxController = Get.find<ListActivityGroupsController>();
    Screen size = Screen(MediaQuery.of(context).size);

    return Column(
      key: const ValueKey("content-error"),
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Obx(
          () => Image.asset(
            getxController.errorImg.value,
            width: size.getWidthPx(150),
            height: size.getWidthPx(150),
            fit: BoxFit.fill,
            key: const ValueKey("activity-error-state"),
          ),
        ),
        Obx(
          () => Container(
            key: const ValueKey("message-error"),
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Center(
              child: Text(
                getxController.errorMsg.value,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: size.getWidthPx(14),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          key: const ValueKey("activity-refresh-button"),
          onTap: () => getxController.onRefresh(),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(100.0),
            ),
            margin: EdgeInsets.symmetric(horizontal: size.getWidthPx(64)),
            padding: EdgeInsets.symmetric(
              vertical: size.getWidthPx(12),
              horizontal: size.getWidthPx(14),
            ),
            child: Text(
              "Coba Lagi",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: size.getWidthPx(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ButtonAddActivity extends StatelessWidget {
  const ButtonAddActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Screen size = Screen(MediaQuery.of(context).size);
    return Container(
      padding: EdgeInsets.only(
        left: size.getWidthPx(16),
        right: size.getWidthPx(16),
        top: size.getWidthPx(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Activity",
            key: const ValueKey("activity-title"),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: size.getWidthPx(16),
              fontWeight: FontWeight.w900,
              color: const Color(0xFF111111),
            ),
          ),
          ElevatedButton.icon(
            key: const ValueKey("activity-add-button"),
            onPressed: () {},
            label: Text(
              "Tambah",
              style: TextStyle(fontSize: size.getWidthPx(13)),
            ),
            icon: Icon(Icons.add, size: size.getWidthPx(18)),
            style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
          )
        ],
      ),
    );
  }
}

class ContentSuccess extends StatelessWidget {
  const ContentSuccess({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final getxController = Get.find<ListActivityGroupsController>();
    return Obx(
      () => Column(
        key: const ValueKey("content-success"),
        children: [
          const ButtonAddActivity(),
          Expanded(
            child: (getxController.responseList.isNotEmpty)
                ? const ListData()
                : const DataEmpty(),
          ),
        ],
      ),
    );
  }
}

class DataEmpty extends StatelessWidget {
  const DataEmpty({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final getxController = Get.find<ListActivityGroupsController>();
    Screen size = Screen(MediaQuery.of(context).size);
    return SmartRefresher(
      key: const ValueKey("activity-empty-state"),
      controller: RefreshController(),
      onRefresh: () => getxController.onRefresh(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            Constants.NOT_FOUND_IMAGE,
            width: size.getWidthPx(150),
            height: size.getWidthPx(150),
            fit: BoxFit.fill,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Center(
              child: Text(
                "Buat activity pertamamu",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF555555),
                  fontWeight: FontWeight.bold,
                  fontSize: size.getWidthPx(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListData extends StatelessWidget {
  const ListData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final getxController = Get.find<ListActivityGroupsController>();
    Screen size = Screen(MediaQuery.of(context).size);
    return Obx(
      () => SmartRefresher(
        key: const ValueKey("activity-not-empty-state"),
        controller: RefreshController(),
        onRefresh: () => getxController.onRefresh(),
        child: GridView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: size.getWidthPx(8),
            vertical: size.getWidthPx(8),
          ),
          itemBuilder: (BuildContext context, int index) {
            ActivityGroupData item = getxController.responseList[index];
            return ItemData(item: item, index: index);
          },
          itemCount: getxController.responseList.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 1,
            maxCrossAxisExtent: size.wp(50),
          ),
        ),
      ),
    );
  }
}

class ItemData extends StatelessWidget {
  const ItemData({
    Key? key,
    required this.item,
    required this.index,
  }) : super(key: key);

  final dynamic item;
  final dynamic index;

  @override
  Widget build(BuildContext context) {
    final getxController = Get.find<ListActivityGroupsController>();
    Screen size = Screen(MediaQuery.of(context).size);

    removeActivityGroupsConfirmation() {
      Get.generalDialog(
        pageBuilder: (context, animation, secondaryAnimation) {
          return CustomDialogQuestion(
            title: "modal-delete-activity",
            onTapOke: () async {
              Get.back();
              getxController.onRemoveActivityGroups(item.id.toString());
            },
            desc: "Apakah anda yakin menghapus activity ${item.title} ?",
          );
        },
      );
    }

    return InkWell(
      key: const ValueKey("activity-item"),
      onTap: () {
        printInfo(info: "Detail");
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: size.getWidthPx(8),
          vertical: size.getWidthPx(8),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  left: size.getWidthPx(16),
                  top: size.getWidthPx(16),
                  right: size.getWidthPx(16),
                ),
                child: Text(
                  item.title ?? "-",
                  key: const ValueKey("activity-item-title"),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                  style: TextStyle(
                    fontSize: size.getWidthPx(14),
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF111111),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: size.getWidthPx(4),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: size.getWidthPx(16),
                        right: size.getWidthPx(4),
                      ),
                      child: Text(
                        DateFormat('d MMM, yyyy').format(
                          item.createdAt!,
                        ),
                        key: const ValueKey("activity-item-date"),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: size.getWidthPx(12),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF888888),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      removeActivityGroupsConfirmation();
                    },
                    icon: Icon(
                      Icons.delete_forever_outlined,
                      size: size.getWidthPx(18),
                      color: const Color(0xFF888888),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
