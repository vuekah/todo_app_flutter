import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:todo_app_flutter/common/widgets/button.widgets.dart';
import 'package:todo_app_flutter/utils/dimens.dart';
import 'package:todo_app_flutter/gen/assets.gen.dart';
import 'package:todo_app_flutter/model/task.model.dart';
import 'package:todo_app_flutter/pages/add_task/add_task.page.dart';
import 'package:todo_app_flutter/pages/home/items/task.item.dart';
import 'package:todo_app_flutter/pages/auth/login.page.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:todo_app_flutter/theme/text_style.dart';
import 'package:todo_app_flutter/pages/auth/auth.viewmodel.dart';
import 'package:todo_app_flutter/pages/home/home.viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  void _fetchTasks() async {
    final homeViewModel = context.read<ViewModel>();
    if (homeViewModel.status == Status.init) {
      homeViewModel.fetchTodos();
      homeViewModel.fetchCompletedTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);
    Widget addNewTaskButton() {
      return ButtonWidget(
        callback: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
        },
        title: "Add New Task",
      );
    }

    // Widget for Todo list item container
    Widget todoListContainer() {
      return Container(
        padding: const EdgeInsets.all(8),
        width: Dimens.screenWidth,
        height: 242,
        decoration: BoxDecoration(
          color: MyAppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Consumer<ViewModel>(
          builder: (context, value, child) {
            // if (value.listTodo.isEmpty && value.status == Status.init) {
            //   value.fetchTodos();
            // }
            if (value.status == Status.error) {
              return Center(
                child: Text(value.errorFetchTodoList),
              );
            }
            if (value.status == Status.loading) {
              return Skeletonizer(
                enabled: true,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    return TaskItem(task: fakeItem);
                  },
                ),
              );
            } else {
              return ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final task = value.listTodo[index];

                  return TaskItem(
                    callback: () async {
                      await value.updateTask(
                          task.id == null ? value.currentId : task.id!);
                    },
                    task: task,
                  );
                },
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: MyAppColors.grayColor,
                ),
                itemCount: value.listTodo.length,
              );
            }
          },
        ),
      );
    }

    Widget completedListContainer() {
      return Container(
        padding: const EdgeInsets.all(8),
        width: Dimens.screenWidth,
        height: 242,
        decoration: BoxDecoration(
          color: MyAppColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Consumer<ViewModel>(
          builder: (context, value, child) {
            // if (value.listCompleted.isEmpty &&
            //     value.completedStatus == Status.init) {
            //   value.fetchCompletedTodos();
            // }
            if (value.status == Status.error) {
              return Center(
                child: Text(value.errorFetchCompletedList),
              );
            }
            if (value.status == Status.loading) {
              return Skeletonizer(
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
              );
            } else {
              return ListView.separated(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final task = value.listCompleted[index];
                  return TaskItem(
                    task: task,
                  );
                },
                separatorBuilder: (context, index) => Container(
                  height: 1,
                  color: MyAppColors.grayColor,
                ),
                itemCount: value.listCompleted.length,
              );
            }
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: MyAppColors.greyColor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background Column with Circle images
            SizedBox(
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
            ),

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
                  Consumer<AuthViewModel>(
                    builder: (context, value, child) => AppBar(
                      backgroundColor: MyAppColors.transparentColor,
                      // leading: IconButton(
                      //     onPressed: () {},
                      //     icon: const Icon(
                      //       Icons.language,
                      //       color: MyAppColors.whiteColor,
                      //       size: 30,
                      //     )),
                      title: Text(
                        context.read<ViewModel>().date,
                        textAlign: TextAlign.center,
                        style: MyAppStyles.formattedDateTextStyle,
                      ),
                      actions: [
                        GestureDetector(
                          onTap: () async {
                            await value.logout();
                            if (!context.mounted) return;
                            context.read<ViewModel>().resetAllState();
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
                  todoListContainer(),
                  const SizedBox(height: 10),
                  const Text(
                    "Completed",
                    textAlign: TextAlign.start,
                    style: MyAppStyles.completedTextStyle,
                  ),
                  const SizedBox(height: 10),
                  // Second Todo List Item
                  completedListContainer(),
                  const SizedBox(height: 60),
                  // Add Task button for landscape layout
                  if (Dimens.screenHeight < Dimens.screenWidth)
                    addNewTaskButton(),
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
                child: addNewTaskButton(),
              ),
          ],
        ),
      ),
    );
  }
}
