import 'package:flutter/material.dart';
import 'package:taskreminder/Components/Widgets.dart';
import 'package:taskreminder/Components/themes.dart';

// ignore: must_be_immutable
class NotificationScreen extends StatelessWidget {
  String notificationMSG;
  NotificationScreen({required this.notificationMSG, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          // split use to divide text when find | and [0] to choose the first word
          notificationMSG.split('|')[0],
        ),
      ),
      body: SafeArea(
          minimum: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello",
                    // to get general theme and copyWith to make edit on it use only here
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "You Have A New Reminder",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          color: themes().PinkCol,
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 30),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //  make Title
                          notificationShow(
                              context: context,
                              notificationMSG: notificationMSG.split('|')[0],
                              TitleText: "Title",
                              icon: Icons.text_format),
                          //  make Description
                          notificationShow(
                            context: context,
                            notificationMSG: notificationMSG.split('|')[1],
                            TitleText: "Description",
                            icon: Icons.description,
                          ),
                          //  make Date
                          notificationShow(
                            context: context,
                            notificationMSG: notificationMSG.split('|')[2],
                            TitleText: "Date",
                            icon: Icons.date_range,
                          ),
                        ],
                      )))
            ],
          )),
    );
  }
}
