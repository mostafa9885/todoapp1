
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:thisapp/Shared/Cuibt/cubit.dart';

class color {
  static var mainColor = const Color(0xFFA75B6B);
  static var primeColor = const Color(0xFFA75B6B).withOpacity(0.62);
  static var greyColor = Colors.grey;
  static var greenColor = const Color(0xFF20B237);
  static var custumarchivecolor = const Color(0xFF818381);
}

Widget TextFromFieldDefualt({
  required TextEditingController controller,
  required String label,
  required IconData prefixIcon,
  required TextInputType keyboardType,
  String? Function(String?)? validator,
  Function()? onTap,
  TextStyle? labelStyle,
  String? hintText,
  double hintStyleFS = 15,
  double borderSideWidth = 3,
  double borderRadiusCircular = 13,
  bool isReadOnly = false,
}) =>
    TextFormField(
      validator: validator,
      controller: controller,
      onTap: onTap,
      keyboardType: keyboardType,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: hintStyleFS,
        ),
        prefixIcon: Icon(prefixIcon),
        label: Text(label),
        labelStyle: labelStyle,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            width: borderSideWidth,
          ),
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusCircular)),
        ),
      ),
    );


Widget buildTaskItem(Map key, context) => Dismissible(
      key: Key(key['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Text('${key['time']}'),
                  backgroundColor: color.mainColor.withOpacity(0.98),
                  foregroundColor: Colors.white,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${key['title']}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: color.mainColor,
                        ),
                        maxLines: 50,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${key['data']}',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: color.greyColor[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: 36,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      AppCubit.get(context)
                          .UpdateData(status: 'done', id: key['id']);
                    },
                    icon: Icon(Icons.playlist_add_check_sharp,
                        color: color.greenColor),
                    label:
                        Text('Done', style: TextStyle(color: color.greenColor)),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      AppCubit.get(context)
                          .UpdateData(status: 'archive', id: key['id']);
                    },
                    icon: Icon(Icons.archive_outlined,
                        color: color.custumarchivecolor),
                    label: Text('Archive',
                        style: TextStyle(color: color.custumarchivecolor)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction)
      {
        AppCubit.get(context).DeletData(id: key['id']);
      },
    );


Widget ConditionalItemBuilder ({
  required List<Map> task,
  required String hint,
  required String? src
}) => ConditionalBuilder(
  condition: task.isNotEmpty,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(task[index], context),
    separatorBuilder: (context, index)=>Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0, end: 20),
      child: Container(
        width: double.infinity,
        height: 1,
        color: color.mainColor,
      ),
    ),
    itemCount: task.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
            '$src',
            width: 150,
            height: 150
        ),
        const SizedBox(height: 15),
        Text(
          '$hint',
          style: TextStyle(
              fontSize: 15,
              color: color.mainColor,
              fontWeight: FontWeight.w300
          ),
        ),
      ],
    ),
  ),
);

