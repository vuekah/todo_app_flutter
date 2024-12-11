import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/common/widgets/button_widget.dart';
import 'package:todo_app_flutter/l10n/language_provider.dart';
import 'package:todo_app_flutter/pages/home/home_viewmodel.dart';
import 'package:todo_app_flutter/pages/settings/setting_page.dart';
import 'package:todo_app_flutter/utils/dimens_util.dart';
import 'package:todo_app_flutter/gen/assets.gen.dart';
import 'package:todo_app_flutter/pages/add_task/add_task.page.dart';
import 'package:todo_app_flutter/pages/home/items/task_item.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:todo_app_flutter/theme/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isCollapsed = false;
  @override
  void initState() {
    super.initState();
    if (context.read<HomeViewModel>().status == Status.init &&
        context.read<HomeViewModel>().completedStatus == Status.init) {
      context.read<HomeViewModel>().fetchTodos();
      context.read<HomeViewModel>().fetchCompletedTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);
    return Scaffold(
      backgroundColor: MyAppColors.backgroundColor,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          _buildBackground(context),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: isCollapsed
                    ? MyAppColors.backgroundColor
                    : MyAppColors.transparentColor,
                expandedHeight: 116.0,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  centerTitle: true,
                  title: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          isCollapsed = constraints.maxHeight <= 76;
                        });
                      });
                      return isCollapsed
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                AppLocalizations.of(context)!.myToDoList,
                                style: MyAppStyles.todoListTitleTextStyle,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Selector<LanguageProvider, Locale>(
                                  builder: (context, locale, child) {
                                    return Text(
                                      locale.languageCode == 'en'
                                          ? DateFormat("MMMM dd, yyyy")
                                              .format(DateTime.now())
                                          : DateFormat("dd MMMM, yyyy", 'vi')
                                              .format(DateTime.now()),
                                      textAlign: TextAlign.center,
                                      style: MyAppStyles.formattedDateTextStyle,
                                    );
                                  },
                                  selector: (p0, languageProvider) =>
                                      languageProvider.locale,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.myToDoList,
                                  style: MyAppStyles.todoListTitleTextStyle,
                                ),
                              ],
                            );
                    },
                  ),
                  expandedTitleScale: 1.2,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SettingPage()));
                      },
                      child: const Icon(
                        Icons.settings,
                        color: MyAppColors.whiteColor,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: todoListContainer(context),
                ),
              ),
              if (context.watch<HomeViewModel>().listCompleted.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.completed,
                        style: MyAppStyles.completedTextStyle,
                      ),
                    ),
                  ),
                ),
              SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: completedListContainer(context),
                  )),
              const SliverPadding(padding: EdgeInsets.only(bottom: 80))
            ],
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: addNewTaskButton(context),
          )
        ],
      ),
    );
  }

  Widget todoListContainer(BuildContext context) {
    if (context.read<HomeViewModel>().status == Status.init) {
      context.read<HomeViewModel>().fetchTodos();
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final task = context.read<HomeViewModel>().listTodo[index];
        return TaskItem(
          callback: () async {
            await context.read<HomeViewModel>().updateTask(task.id ?? 0);
          },
          task: task,
        );
      },
      separatorBuilder: (context, index) => Container(),
      itemCount: context.watch<HomeViewModel>().listTodo.length,
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Flexible(
              flex: 2,
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
              flex: Dimens.screenHeight > Dimens.screenWidth ? 4 : 1,
              fit: FlexFit.tight,
              child: Container(
                color: MyAppColors.greyColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget addNewTaskButton(BuildContext context) {
    return ButtonWidget(
      callback: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
      },
      title: AppLocalizations.of(context)!.addNewTask,
    );
  }
}

Widget completedListContainer(BuildContext context) {
  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    itemBuilder: (context, index) {
      final task = context.read<HomeViewModel>().listCompleted[index];
      return TaskItem(
        task: task,
      );
    },
    separatorBuilder: (context, index) => Container(),
    itemCount: context.read<HomeViewModel>().listCompleted.length,
  );
}
