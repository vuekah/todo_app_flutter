import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:todo_app_flutter/common/widgets/button_widget.dart';
import 'package:todo_app_flutter/pages/home/home_viewmodel.dart';
import 'package:todo_app_flutter/utils/dimens_util.dart';
import 'package:todo_app_flutter/gen/assets.gen.dart';
import 'package:todo_app_flutter/model/task_model.dart';
import 'package:todo_app_flutter/pages/add_task/add_task.page.dart';
import 'package:todo_app_flutter/pages/home/items/task_item.dart';
import 'package:todo_app_flutter/pages/auth/login/login_page.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:todo_app_flutter/theme/text_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context1) {
    Dimens.init(context1);
    return ChangeNotifierProvider(
        create: (context) => HomeViewModel(),
        child: Builder(
            builder: (context) => Scaffold(
                  backgroundColor: MyAppColors.greyColor,
                  body: SingleChildScrollView(
                    child: Stack(
                      children: [
                        _buildBackground(),

                        // Main content
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Dimens.screenHeight < Dimens.screenWidth
                                ? Dimens.padding.left
                                : 16,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AppBar(
                                backgroundColor: MyAppColors.transparentColor,
                                centerTitle: true,
                                title: Text(
                                  context.read<HomeViewModel>().date,
                                  textAlign: TextAlign.center,
                                  style: MyAppStyles.formattedDateTextStyle,
                                ),
                                actions: [
                                  GestureDetector(
                                    onTap: () async {
                                      await context
                                          .read<HomeViewModel>()
                                          .logout();
                                      if (!context.mounted) return;
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const LoginPage()),
                                        (route) => false,
                                      );
                                    },
                                    child: const Icon(
                                      Icons.logout,
                                      color: MyAppColors.whiteColor,
                                      size: 28,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 15),
                              // Todo list title
                              const Text(
                                "My Todo List",
                                textAlign: TextAlign.center,
                                style: MyAppStyles.todoListTitleTextStyle,
                              ),
                              const SizedBox(height: 15),
                              // First Todo List Item
                              todoListContainer(context),
                              const SizedBox(height: 10),
                              const Text(
                                "Completed",
                                textAlign: TextAlign.start,
                                style: MyAppStyles.completedTextStyle,
                              ),
                              const SizedBox(height: 10),
                              // Second Todo List Item
                              completedListContainer(context),
                              const SizedBox(height: 60),
                              // Add Task button for landscape layout
                              if (Dimens.screenHeight < Dimens.screenWidth)
                                addNewTaskButton(context),
                            ],
                          ),
                        ),
                        // Add Task button for portrait layout (positioned at the bottom)
                        if (Dimens.screenHeight > Dimens.screenWidth)
                          Positioned(
                            bottom: Dimens.padding.bottom,
                            left: Dimens.screenHeight < Dimens.screenWidth
                                ? Dimens.padding.left
                                : 16,
                            right: Dimens.screenHeight < Dimens.screenWidth
                                ? Dimens.padding.left
                                : 16,
                            child: addNewTaskButton(context),
                          ),
                      ],
                    ),
                  ),
                )));
  }

  SizedBox _buildBackground() {
    return SizedBox(
      width: Dimens.screenWidth,
      height: Dimens.screenHeight,
      child: Column(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
              width: Dimens.screenWidth,
              color: MyAppColors.backgroundColor,
              child: Stack(
                children: [
                  Positioned(
                    top: Dimens.padding.top,
                    left: Dimens.screenHeight < Dimens.screenWidth
                        ? -Dimens.screenWidth / 6
                        : -Dimens.screenWidth / 2,
                    child: Image.asset(
                      Assets.images.circle.path,
                      width: 342,
                    ),
                  ),
                  Positioned(
                    right: -60,
                    top: -10,
                    child: Image.asset(
                      Assets.images.circle2.path,
                      width: 145,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: Dimens.screenHeight > Dimens.screenWidth ? 3 : 1,
            fit: FlexFit.tight,
            child: Container(
              color: MyAppColors.greyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget addNewTaskButton(BuildContext context) {
    return ButtonWidget(
      callback: () async {
        final res = await Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
        if (res is TaskModel) {
          if (!context.mounted) return;
          context.read<HomeViewModel>().addNewTask(res);
        }
      },
      title: "Add New Task",
    );
  }

  Widget todoListContainer(BuildContext context) {
    if (context.read<HomeViewModel>().status == Status.init) {
      context.read<HomeViewModel>().fetchTodos();
    }

    return Container(
        padding: const EdgeInsets.all(8),
        width: Dimens.screenWidth,
        height: 242,
        decoration: BoxDecoration(
          color: MyAppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: context.watch<HomeViewModel>().status == Status.error
            ? Center(
                child: Text(context.read<HomeViewModel>().errorFetchTodoList),
              )
            : context.watch<HomeViewModel>().status == Status.loading
                ? Skeletonizer(
                    enabled: true,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return TaskItem(task: fakeItem);
                      },
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final task =
                          context.read<HomeViewModel>().listTodo[index];
                      return TaskItem(
                        callback: () async {
                          await context
                              .read<HomeViewModel>()
                              .updateTask(task.id ?? 0);
                        },
                        task: task,
                      );
                    },
                    separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: MyAppColors.grayColor,
                    ),
                    itemCount: context.watch<HomeViewModel>().listTodo.length,
                  ));
  }

  Widget completedListContainer(BuildContext context) {
    final homeViewModel = context.read<HomeViewModel>();
    if (homeViewModel.completedStatus == Status.init) {
      homeViewModel.fetchCompletedTodos();
    }

    return Container(
      padding: const EdgeInsets.all(8),
      width: Dimens.screenWidth,
      height: 242,
      decoration: BoxDecoration(
        color: MyAppColors.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: homeViewModel.status == Status.error
          ? Center(
              child: Text(homeViewModel.errorFetchCompletedList),
            )
          : homeViewModel.status == Status.loading
              ? Skeletonizer(
                  enabled: true,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        task: fakeItem,
                      );
                    },
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final task = homeViewModel.listCompleted[index];
                    return TaskItem(
                      task: task,
                    );
                  },
                  separatorBuilder: (context, index) => Container(
                    height: 1,
                    color: MyAppColors.grayColor,
                  ),
                  itemCount: homeViewModel.listCompleted.length,
                ),
    );
  }
}
