class Tasks {
  int? id;
  int? isCompleted;
  int? color;
  int? remind;
  String? title;
  String? note;
  String? date;
  String? startTime;
  String? endTime;
  String? repeat;

  Tasks({
    this.id,
    this.isCompleted,
    this.color,
    this.remind,
    this.title,
    this.note,
    this.date,
    this.startTime,
    this.endTime,
    this.repeat,
  });

  // to make map use it in insert data
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "isCompleted": isCompleted,
      "color": color,
      "remind": remind,
      "title": title,
      "note": note,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "repeat": repeat,
    };
  }

  // to get data from json
  Tasks.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isCompleted = json['isCompleted'];
    color = json['color'];
    remind = json['remind'];
    title = json['title'];
    note = json['note'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    repeat = json['repeat'];
  }
}
