import 'package:flutter/material.dart';

class Gridhours extends StatefulWidget {
  final Function(String) setHour;
  const Gridhours({required this.setHour, super.key});

  @override
  State<Gridhours> createState() => _GridhoursState();
}

class _GridhoursState extends State<Gridhours> {
  List<bool> isSelectedList = List.generate(18, (_) => false);
  int prev = -1;
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 6,
      children: List.generate(15, (index) {
        return InkWell(
          child: Padding(
            padding: EdgeInsets.all(3),
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(4),
              constraints: BoxConstraints(
                minHeight: 0, // sin altura mínima
              ),
              child: Text(formatHour(index)),
              // padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelectedList[index]
                    ? Colors.blueAccent
                    : Colors.grey[300],
              ),
            ),
          ),

          onTap: () {
            setState(() {
              if (prev != -1) {
                isSelectedList[prev] = false;
              }
              isSelectedList[index] = !isSelectedList[index];
              prev = index;
             widget.setHour(formatHour(index));
            });
          },
        );
      }),
    );
  }

  String formatHour(int i) {
    if (i+5 < 10) {
      return "0${i + 5}:00";
    }
    return "${i + 5}:00";
  }
}
