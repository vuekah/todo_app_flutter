class TaskModel {
  final int? id;
  final int category;
  final String taskTitle;
  final String date;
  final String time;
  final String notes;
  final bool isCompleted;
  final String uid;

  TaskModel({
    this.id,
    required this.category,
    required this.taskTitle,
    required this.date,
    required this.time,
    required this.notes,
    required this.isCompleted,
    required this.uid,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
      category: json['category'],
      taskTitle: json['taskTitle'],
      date: json['date'],
      time: json['time'],
      id: json['id'],
      notes: json['notes'],
      isCompleted: json['isCompleted'],
      uid: json['uid']);

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'date': date,
      'time': time,
      'notes': notes,
      'isCompleted': isCompleted,
      'taskTitle': taskTitle,
      'uid': uid
    };
  }

  TaskModel copyWith({
    int? id,
    int? category,
    String? taskTitle,
    String? date,
    String? time,
    String? notes,
    bool? isCompleted,
    String? uid,
  }) {
    return TaskModel(
      id: id ?? this.id,
      category: category ?? this.category,
      taskTitle: taskTitle ?? this.taskTitle,
      date: date ?? this.date,
      time: time ?? this.time,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
      uid: uid ?? this.uid,
    );
  }

  @override
  String toString() {
    return 'TaskModel{id: $id,category: $category, taskTitle: $taskTitle, date: $date, time: $time, notes: $notes, isCompleted: $isCompleted, uid: $uid}';
  }
}

TaskModel fakeItem = TaskModel(
    category: 2,
    taskTitle: 'taskTitle',
    date: 'date',
    time: 'time',
    notes: 'notes',
    isCompleted: true,
    uid: 'uid');
