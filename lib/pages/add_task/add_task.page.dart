import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app_flutter/common/widgets/button.widgets.dart';
import 'package:todo_app_flutter/common/widgets/textfield.widget.dart';
import 'package:todo_app_flutter/utils/dimens.dart';
import 'package:todo_app_flutter/gen/assets.gen.dart';
import 'package:todo_app_flutter/gen/fonts.gen.dart';
import 'package:todo_app_flutter/model/task.model.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:todo_app_flutter/utils/date.util.dart';
import 'package:todo_app_flutter/pages/home/home.viewmodel.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _taskTitleController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _taskTitleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimens.init(context);
    return Scaffold(
      backgroundColor: MyAppColors.greyColor,
      body: Stack(
        children: [
          _buildBackground(context),
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Consumer<ViewModel> _buildSaveButton(BuildContext context) {
    return Consumer<ViewModel>(
      builder: (_, hm, __) => Positioned(
        bottom: Dimens.padding.bottom,
        left:
            Dimens.screenHeight < Dimens.screenWidth ? Dimens.padding.left : 16,
        right:
            Dimens.screenHeight < Dimens.screenWidth ? Dimens.padding.left : 16,
        child: hm.addTaskStatus == Status.loading
            ? const Center(child: CircularProgressIndicator())
            : ButtonWidget(
                callback: () async {
                  _saveTask(hm);
                },
                title: "Save"),
      ),
    );
  }

  SizedBox _buildBackground(BuildContext context) {
    return SizedBox(
      width: Dimens.screenWidth,
      height: Dimens.screenHeight,
      child: Column(
        children: [
          _buildHeader(),
          _buildForm(context),
        ],
      ),
    );
  }

  Future<void> _saveTask(ViewModel hm) async {
    await hm.addTask(TaskModel(
        id: (hm.currentId + 1),
        category: hm.selectedButton,
        taskTitle: _taskTitleController.text,
        date: hm.date.toReverseFormattedDateString()!,
        time: hm.time.convertTo24HourFormat(),
        notes: _notesController.text,
        uid: Supabase.instance.client.auth.currentUser?.id ?? "",
        isCompleted: false));
    _notesController.clear();
    _taskTitleController.clear();
    final snackBarMessage = hm.addTaskStatus == Status.error
        ? hm.errorAddTask
        : 'Task added successfully!';
    if(!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(snackBarMessage)));
  }

  Flexible _buildForm(BuildContext context) {
    return Flexible(
      flex: Dimens.screenHeight > Dimens.screenWidth ? 5 : 3,
      fit: FlexFit.tight,
      child: Container(
        padding: EdgeInsets.only(
          bottom: 60,
          left: Dimens.screenHeight < Dimens.screenWidth
              ? Dimens.padding.left
              : 16,
          right: Dimens.screenHeight < Dimens.screenWidth
              ? Dimens.padding.left
              : 16,
        ),
        color: MyAppColors.greyColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              TextFieldWidget(
                hint: "Task Title",
                controller: _taskTitleController,
              ),
              const SizedBox(height: 10),
              Consumer<ViewModel>(builder: (context, value, child) {
                return Row(
                  children: [
                    const Text(
                      "Category",
                      style: TextStyle(
                        color: MyAppColors.black,
                        fontSize: 14,
                        fontFamily: FontFamily.inter,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        value.setSelected(1);
                      },
                      child: Opacity(
                          opacity: value.selectedButton == 1 ? 1 : .2,
                          child: Image.asset(Assets.images.book.path)),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        value.setSelected(2);
                      },
                      child: Opacity(
                          opacity: value.selectedButton == 2 ? 1 : .2,
                          child: Image.asset(Assets.images.schedule.path)),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {
                        value.setSelected(3);
                      },
                      child: Opacity(
                          opacity: value.selectedButton == 3 ? 1 : .2,
                          child: Image.asset(Assets.images.cup.path)),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: Consumer<ViewModel>(
                      builder: (_, hm, __) => TextFieldWidget(
                        hint: "Date",
                        isReadOnly: true,
                        placeholder: hm.date.toFormattedDateString(),
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                              lastDate: DateTime(2999),
                            );
                            hm.setDateSelected(date);
                          },
                          child: const Icon(
                            Icons.date_range,
                            color: MyAppColors.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Consumer<ViewModel>(
                      builder: (_, hm, __) => TextFieldWidget(
                        isReadOnly: true,
                        hint: "Time",
                        placeholder: hm.time,
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            final time = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            hm.setTimeSelected(time);
                          },
                          child: const Icon(
                            Icons.schedule,
                            color: MyAppColors.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFieldWidget(
                hint: "Notes",
                controller: _notesController,
                height: 177,
                maxLines: 10,
              ),
              SizedBox(height: Dimens.padding.bottom + 20),
            ],
          ),
        ),
      ),
    );
  }

  Flexible _buildHeader() {
    return Flexible(
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: Dimens.screenHeight > Dimens.screenWidth ? 0 : 10),
              child: AppBar(
                leading: Consumer<ViewModel>(
                  builder: (context, value, child) {
                    return GestureDetector(
                      onTap: () {
                        // value.fetchCompletedTodos();
                        // value.fetchTodos();
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: MyAppColors.whiteColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(Icons.close),
                      ),
                    );
                  },
                ),
                backgroundColor: MyAppColors.transparentColor,
                title: const Text("Add new task"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
