import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_app_flutter/common/widgets/button_widget.dart';
import 'package:todo_app_flutter/common/widgets/category_widget.dart';
import 'package:todo_app_flutter/common/widgets/textfield_widget.dart';
import 'package:todo_app_flutter/pages/add_task/add_task_viewmodel.dart';
import 'package:todo_app_flutter/pages/home/home_viewmodel.dart';
import 'package:todo_app_flutter/utils/dimens_util.dart';
import 'package:todo_app_flutter/gen/assets.gen.dart';
import 'package:todo_app_flutter/gen/fonts.gen.dart';
import 'package:todo_app_flutter/model/task_model.dart';
import 'package:todo_app_flutter/theme/color_style.dart';
import 'package:todo_app_flutter/utils/date_util.dart';

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
          _buildBackground(),
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Positioned(
      bottom: Dimens.padding.bottom,
      left: Dimens.screenHeight < Dimens.screenWidth ? Dimens.padding.left : 16,
      right:
          Dimens.screenHeight < Dimens.screenWidth ? Dimens.padding.left : 16,
      child: context.select(
                  (AddTaskViewModel viewModel) => viewModel.addTaskStatus) ==
              Status.loading
          ? const Center(child: CircularProgressIndicator())
          : ButtonWidget(
              callback: () async {
                final addTaskViewModel = context.read<AddTaskViewModel>();
                try {
                  final task = TaskModel(
                    category: addTaskViewModel.selectedButton,
                    taskTitle: _taskTitleController.text,
                    date: addTaskViewModel.date.toReverseFormattedDateString()!,
                    time: addTaskViewModel.time.convertTo24HourFormat(),
                    notes: _notesController.text,
                    uid: Supabase.instance.client.auth.currentUser?.id ?? "",
                    isCompleted: false,
                  );
                  final id = await addTaskViewModel.addTask(task);

                  _notesController.clear();
                  _taskTitleController.clear();

                  final snackBarMessage =
                      addTaskViewModel.addTaskStatus == Status.error
                          ? addTaskViewModel.errorAddTask
                          : 'Task added successfully!';

                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(snackBarMessage)));
                      //them vao home
                  context.read<HomeViewModel>().addNewTask(task.copyWith(id: id));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add task: $e')));
                }
              },
              title: "Save",
            ),
    );
  }

  SizedBox _buildBackground() {
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
              Row(
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
                  CategoryWidget(
                    index: 1,
                    assets: Assets.images.book.path,
                  ),
                  const SizedBox(width: 12),
                  CategoryWidget(
                    index: 2,
                    assets: Assets.images.schedule.path,
                  ),
                  const SizedBox(width: 12),
                  CategoryWidget(
                    index: 3,
                    assets: Assets.images.cup.path,
                  )
                ],
              ),
              const SizedBox(height: 10),
              Consumer<AddTaskViewModel>(
                builder: (context, value, child) => Row(
                  children: [
                    Flexible(
                      child: TextFieldWidget(
                        hint: "Date",
                        isReadOnly: true,
                        placeholder: value.date.toFormattedDateString(),
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialEntryMode:
                                  DatePickerEntryMode.calendarOnly,
                              lastDate: DateTime(2999),
                            );
                            if (!context.mounted) return;
                            value.setDateSelected(date);
                          },
                          child: const Icon(
                            Icons.date_range,
                            color: MyAppColors.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: TextFieldWidget(
                        isReadOnly: true,
                        hint: "Time",
                        placeholder: value.time,
                        suffixIcon: GestureDetector(
                          onTap: () async {
                            final time = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (!context.mounted) return;
                            value.setTimeSelected(time);
                          },
                          child: const Icon(
                            Icons.schedule,
                            color: MyAppColors.backgroundColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                leading: GestureDetector(
                  onTap: () {
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
