import 'package:flutter/material.dart';
import 'package:taskreminder/Components/themes.dart';

// to make shape to show notification and reuse it
Widget notificationShow(
    {required context,
    required notificationMSG,
    required icon,
    required TitleText}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).appBarTheme.iconTheme?.color,
          ),
          const SizedBox(width: 20),
          Text("$TitleText", style: Theme.of(context).textTheme.headlineLarge),
        ],
      ),
      const SizedBox(height: 20),
      Text(
        notificationMSG,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 20),
    ],
  );
}

Widget textForm(
    {required String title,
    required String hint,
    required context,
    TextEditingController? controller,
    TextInputAction? textinputaction,
    Widget? widget}) {
  return Container(
    margin: const EdgeInsets.only(left: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: themes().PinkCol)),
            padding: const EdgeInsets.only(left: 10, right: 5),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: controller,
                  textInputAction: widget == null ? textinputaction : null,
                  autofocus: false,
                  readOnly: widget != null ? true : false,
                  cursorColor: Theme.of(context).appBarTheme.backgroundColor,
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.normal),
                    focusedBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder:
                        const UnderlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty && widget == null) {
                      return '$title must not by Empty';
                    }
                    return null;
                  },
                )),
                widget ?? Container()
              ],
            )),
      ],
    ),
  );
}

Widget dropDownButton(
    {required context, required List item, required onChange}) {
  return Padding(
    padding: const EdgeInsets.only(right: 10.0),
    child: DropdownButton(
        icon: Icon(Icons.keyboard_arrow_down,
            color: Theme.of(context).iconTheme.color),
        iconSize: 32,
        elevation: 16,
        alignment: Alignment.center,
        // to remove line under button
        underline: Container(height: 0),
        borderRadius: BorderRadius.circular(25),
        dropdownColor: Theme.of(context).appBarTheme.backgroundColor,
        // to make the items of menu from list
        items: item
            .map((value) => DropdownMenuItem(
                alignment: Alignment.center,
                value: value,
                child: Text(
                  "$value",
                  style: Theme.of(context).textTheme.bodyMedium,
                )))
            .toList(),
        onChanged: onChange),
  );
}
