import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:timer/models/timer_model.dart';
import 'package:timer/utilities/time_formatter.dart';

class TimerWidget extends StatefulWidget {
  final TimerModel model;
  final Function delete;

  const TimerWidget({super.key, required this.model, required this.delete});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Widget getNotSelected(widget) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text(widget.model.label),
          Text(
            Duration(seconds: widget.model.seconds).toString().split(".")[0],
            style: const TextStyle(fontSize: 40),
          )
        ],
      ),
    );
  }

  Widget getSelected(widget, FocusNode focusNode) {
    TextEditingController timeController = TextEditingController(
        text: TimeFormatter.durationToString(
            Duration(seconds: widget.model.seconds)));

    timeController.selection =
        TextSelection.collapsed(offset: timeController.text.length);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextFormField(
            textAlign: TextAlign.center,
            initialValue: widget.model.label,
            decoration: const InputDecoration(hintText: "Label"),
            onChanged: (value) {
              widget.model.label = value;
            },
          ),
          TextFormField(
            textAlign: TextAlign.center,
            showCursor: false,
            controller: timeController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(fontSize: 40),
            onChanged: (value) {
              Duration duration = TimeFormatter.stringToDuration(value);
              widget.model.seconds = duration.inSeconds;
              timeController.text = TimeFormatter.durationToString(duration);
              timeController.selection =
                  TextSelection.collapsed(offset: timeController.text.length);
            },
          ),
          IconButton(
              onPressed: (() {
                focusNode.unfocus();
                widget.delete();
              }),
              icon: const Icon(Icons.delete_outline))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Builder(builder: (context) {
        final FocusNode focusNode = Focus.of(context);
        final bool hasFocus = focusNode.hasFocus;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            focusNode.requestFocus();
          },
          child: hasFocus ? getSelected(widget, focusNode) : getNotSelected(widget),
        );
      }),
    );
  }
}
