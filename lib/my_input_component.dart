import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_input_component/ext.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:provider/provider.dart';

class InputComponent<T> extends StatefulWidget {
  final String locale;
  final String label;
  final T? value;
  final Function(T) onChanged;
  final Function(T)? validator;
  final bool isReadOnly;
  final bool isRequired;
  final bool isPassword;
  final String hint;
  final String errorText;
  final Widget? suffixIcon;
  final bool isSuffixIcon;
  final InputDecoration? inputDecoration;
  final Widget? prefixIcon;
  final PositionLabel positionLabel;
  final StringType stringType;
  final int maxLines;
  final int decimalDigits;
  final VoidCallback? onTap;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool alwaysUse24HourFormat;
  final Color? colorSuffixIcon;
  final Color? backgroundColor;
  final Color? cursorColor;
  final double? borderRadius;
  final String? defaultErrorText;
  final bool isIncludeTime;
  final DatePickerMode datePickerMode;
  final bool allowNegative;
  final TextStyle? labelStyle;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final bool isPin;
  final String? saveText;
  final String? cancelText;
  final String? confirmText;

  const InputComponent({
    super.key,
    this.locale = "id-ID",
    this.cancelText,
    this.saveText,
    this.confirmText,
    required this.label,
    this.value,
    required this.onChanged,
    this.validator,
    this.isReadOnly = false,
    this.isRequired = false,
    this.isPassword = false,
    this.isSuffixIcon = false,
    this.hint = '',
    this.errorText = '',
    this.suffixIcon,
    this.inputDecoration,
    this.prefixIcon,
    this.positionLabel = PositionLabel.top,
    this.stringType = StringType.text,
    this.maxLines = 5,
    this.decimalDigits = 2,
    this.onTap,
    this.firstDate,
    this.lastDate,
    this.alwaysUse24HourFormat = true,
    this.allowNegative = false,
    this.colorSuffixIcon,
    this.cursorColor,
    this.backgroundColor,
    this.borderRadius,
    this.defaultErrorText,
    this.isIncludeTime = false,
    this.datePickerMode = DatePickerMode.day,
    this.labelStyle,
    this.focusNode,
    this.nextFocusNode,
    this.isPin = false,
  }) : assert(
         !isPin || focusNode != null,
         'focusNode, nextFocusNode must not be null when isPin is true',
       );

  @override
  InputComponentState<T> createState() => InputComponentState<T>();
}

class InputComponentState<T> extends State<InputComponent<T>> {
  bool isObscureText = true;
  Notifier model = Notifier<T>();
  Debouncer bouncer = Debouncer(duration: const Duration(milliseconds: 800));

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setValue();
    });
  }

  @override
  void dispose() {
    super.dispose();
    model.controller.dispose();
  }

  @override
  void didUpdateWidget(covariant InputComponent<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setValue();
    });
  }

  void setValue() {
    if (widget.value != null) {
      if (T == int) {
        var formatter = NumberFormat.decimalPatternDigits(decimalDigits: 0);
        model.text = formatter.format(widget.value ?? 0);
      } else if (T == double) {
        var formatter = NumberFormat.decimalPatternDigits(
          decimalDigits: widget.decimalDigits,
        );
        model.text = formatter.format(widget.value ?? 0.0);
      } else if (T == TimeOfDay) {
        TimeOfDay timeOfDay = widget.value as TimeOfDay;
        model.text = "${timeOfDay.hour}:${timeOfDay.minute}";
      } else if (T == DateTime) {
        widget.isIncludeTime
            ? model.text = (widget.value as DateTime).toStrings(
              locale: widget.locale,
              format: Formats.dateTime,
            )
            : model.text = (widget.value as DateTime).toStrings(
              locale: widget.locale,
            );
      } else if (T == DateTimeRange) {
        DateTimeRange date = widget.value as DateTimeRange;
        model.text =
            "${date.start.toStrings(locale: widget.locale)} - ${date.end.toStrings(locale: widget.locale)}";
      } else {
        model.text = widget.value as String;
      }
    } else {
      model.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<Notifier>(
        builder: (ctx, vm, child) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            child:
                widget.positionLabel == PositionLabel.top
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          width: double.infinity,
                          child: Text(
                            widget.label,
                            textAlign: TextAlign.left,
                            style:
                                widget.labelStyle ??
                                Theme.of(context).textTheme.titleMedium!,
                          ),
                        ),
                        input(vm),
                      ],
                    )
                    : widget.positionLabel == PositionLabel.bottom
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        input(vm),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          width: double.infinity,
                          child: Text(
                            widget.label,
                            textAlign: TextAlign.left,
                            style:
                                widget.labelStyle ??
                                Theme.of(context).textTheme.titleMedium!,
                          ),
                        ),
                      ],
                    )
                    : widget.positionLabel == PositionLabel.left
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                right: 10,
                                bottom: vm.isError ? 25 : 0,
                              ),
                              child: Text(
                                widget.label,
                                textAlign: TextAlign.left,
                                style:
                                    widget.labelStyle ??
                                    Theme.of(context).textTheme.titleMedium!,
                              ),
                            ),
                            Expanded(child: input(vm)),
                          ],
                        ),
                      ],
                    )
                    : widget.positionLabel == PositionLabel.right
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: input(vm)),
                            Container(
                              margin: EdgeInsets.only(
                                left: 10,
                                bottom: vm.isError ? 25 : 0,
                              ),
                              child: Text(
                                widget.label,
                                textAlign: TextAlign.right,
                                style:
                                    widget.labelStyle ??
                                    Theme.of(context).textTheme.titleMedium!,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                    : Column(children: [input(vm)]),
          );
        },
      ),
    );
  }

  Widget input(Notifier vm) {
    TextFormField input = TextFormField(
      focusNode: widget.focusNode,
      autofocus: true,
      controller: vm.controller,
      readOnly: widget.isReadOnly,
      obscureText: widget.isPassword ? vm.isObscureText : false,
      cursorColor:
          widget.backgroundColor == null
              ? null
              : widget.cursorColor ?? Colors.white,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType:
          T == String
              ? widget.stringType == StringType.multiline
                  ? TextInputType.multiline
                  : widget.stringType == StringType.emailAddress
                  ? TextInputType.emailAddress
                  : widget.stringType == StringType.url
                  ? TextInputType.url
                  : TextInputType.text
              : T == int || T == double
              ? TextInputType.number
              : TextInputType.text,
      inputFormatters:
          T == int
              ? [
                NumberTextInputFormatter(
                  groupDigits: 3,
                  groupSeparator: ',',
                  decimalDigits: 0,
                ),
              ]
              : T == double
              ? [
                NumberTextInputFormatter(
                  decimalDigits: widget.decimalDigits,
                  decimalSeparator: '.',
                  groupDigits: 3,
                  groupSeparator: ',',
                  allowNegative: widget.allowNegative,
                  overrideDecimalPoint: true,
                  insertDecimalPoint: false,
                  insertDecimalDigits: true,
                ),
              ]
              : null,
      maxLines:
          T == String
              ? widget.stringType == StringType.multiline
                  ? widget.maxLines
                  : 1
              : 1,
      onChanged: (value) {
        bouncer.run(() {
          if (widget.isPin &&
              value.isNotEmpty &&
              widget.nextFocusNode != null) {
            widget.focusNode?.unfocus();
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
          if (T == int) {
            var a = value.replaceAll(',', "");
            if (widget.isPin) {
              int parsedValue =
                  int.tryParse(a.length > 1 ? a[a.length - 1] : a) ?? 0;
              widget.onChanged(parsedValue as T);
            } else {
              int parsedValue = int.tryParse(a) ?? 0;
              widget.onChanged(parsedValue as T);
            }
          } else if (T == double) {
            var a = value.replaceAll(',', "");
            double parsedValue = double.tryParse(a) ?? 0.0;
            widget.onChanged(parsedValue as T);
          } else if (T == String) {
            if (widget.isPin) {
              String parsedValue =
                  value.length > 1 ? value[value.length - 1] : value;
              widget.onChanged(parsedValue as T);
            } else {
              widget.onChanged(value as T);
            }
          }
        });
      },
      validator:
          widget.validator != null
              ? (v) {
                if (T == int) {
                  var a = (v ?? "").replaceAll(',', "");
                  int parsedValue = int.tryParse(a) ?? 0;
                  return widget.validator?.call(parsedValue as T);
                } else if (T == double) {
                  var a = (v ?? "").replaceAll(',', "");
                  double parsedValue = double.tryParse(a) ?? 0.0;
                  return widget.validator?.call(parsedValue as T);
                } else if (T == String) {
                  return widget.validator?.call(v as T);
                } else {
                  return null;
                }
              }
              : widget.isRequired
              ? (value) {
                if (value == null || value.trim().isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    vm.isError = true;
                  });

                  return widget.errorText.isEmpty
                      ? "${widget.defaultErrorText ?? "Please input"} ${widget.label}"
                          .toTitleCase
                      : widget.errorText.toBeginning;
                }
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  vm.isError = false;
                });
                return null;
              }
              : null,
      onTap:
          widget.onTap ??
          () async {
            if (T == TimeOfDay) {
              TimeOfDay? date = await showTimePicker(
                context: context,
                initialTime:
                    widget.value == null
                        ? TimeOfDay.now()
                        : widget.value as TimeOfDay,
                cancelText: widget.cancelText,
                confirmText: widget.confirmText,
                builder: (context, childWidget) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: widget.alwaysUse24HourFormat,
                    ),
                    child: childWidget!,
                  );
                },
              );
              if (date != null) {
                model.text = "${date.hour}:${date.minute}";
                widget.onChanged(date as T);
              }
            } else if (T == DateTime) {
              DateTime? lastDate =
                  widget.lastDate ??
                  DateTime.now().add(const Duration(days: 365));
              DateTime? initialDate = widget.value as DateTime?;
              final date = await showDatePicker(
                context: context,
                initialDatePickerMode: widget.datePickerMode,
                initialDate:
                    initialDate != null && initialDate.isAfter(lastDate)
                        ? null
                        : initialDate,
                firstDate:
                    widget.firstDate ??
                    DateTime.now().subtract(const Duration(days: 365)),
                lastDate: lastDate,
                cancelText: widget.cancelText,
                confirmText: widget.confirmText,
                locale: Locale(widget.locale.split('-')[0]),
              );
              if (date != null) {
                if (widget.isIncludeTime) {
                  TimeOfDay timeOfDays = TimeOfDay.fromDateTime(date);
                  await Future.delayed(Duration.zero);
                  if (!mounted) return;
                  TimeOfDay? timeOfDay = await showTimePicker(
                    context: context,
                    initialTime: timeOfDays,
                    cancelText: widget.cancelText,
                    confirmText: widget.confirmText,
                    builder: (context, childWidget) {
                      return MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          alwaysUse24HourFormat: widget.alwaysUse24HourFormat,
                        ),
                        child: childWidget!,
                      );
                    },
                  );
                  if (timeOfDay != null) {
                    DateTime selectedDate = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      timeOfDay.hour,
                      timeOfDay.minute,
                    );
                    model.text = selectedDate.toStrings(
                      locale: widget.locale,
                      format: Formats.dateTime,
                    );
                    widget.onChanged(selectedDate as T);
                  }
                } else {
                  model.text = date.toStrings(locale: widget.locale);
                  widget.onChanged(date as T);
                }
              }
            } else if (T == DateTimeRange) {
              final date = await showDateRangePicker(
                context: context,
                cancelText: widget.cancelText,
                confirmText: widget.confirmText ?? widget.confirmText,
                saveText: widget.saveText ?? widget.saveText,
                locale: Locale(widget.locale.split('-')[0]),
                initialDateRange:
                    widget.value == null
                        ? DateTimeRange(
                          start: DateTime.now(),
                          end: DateTime.now(),
                        )
                        : widget.value as DateTimeRange,
                currentDate: DateTime.now(),
                firstDate:
                    widget.firstDate ??
                    DateTime.now().subtract(const Duration(days: 365)),
                lastDate:
                    widget.lastDate ??
                    DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) {
                model.text =
                    "${date.start.toStrings(locale: widget.locale)} - ${date.end.toStrings(locale: widget.locale)}";
                widget.onChanged(date as T);
              }
            }
          },
      decoration:
          widget.inputDecoration ??
          (const InputDecoration())
              .applyDefaults(Theme.of(context).inputDecorationTheme)
              .copyWith(
                contentPadding:
                    T == String
                        ? widget.stringType == StringType.multiline
                            ? const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            )
                            : const EdgeInsets.all(10)
                        : const EdgeInsets.all(10),
                filled: widget.backgroundColor != null ? true : false,
                fillColor: widget.backgroundColor,
                label:
                    widget.positionLabel == PositionLabel.input
                        ? Text(widget.label.toBeginning)
                        : null,
                hintText: widget.hint,
                prefixIcon: widget.prefixIcon,
                suffixIconColor:
                    widget.colorSuffixIcon ??
                    Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.6),
                suffixIcon:
                    widget.suffixIcon ??
                    (widget.isPassword
                        ? IconButton(
                          icon: Icon(
                            vm.isObscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              vm.isObscureText = !vm.isObscureText;
                            });
                          },
                        )
                        : (T == TimeOfDay
                            ? IconButton(
                              onPressed: () async {
                                TimeOfDay? date = await showTimePicker(
                                  context: context,
                                  cancelText:
                                      widget.cancelText ?? widget.cancelText,
                                  confirmText:
                                      widget.confirmText ?? widget.confirmText,
                                  initialTime:
                                      widget.value == null
                                          ? TimeOfDay.now()
                                          : widget.value as TimeOfDay,
                                  builder: (context, childWidget) {
                                    return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                        alwaysUse24HourFormat:
                                            widget.alwaysUse24HourFormat,
                                      ),
                                      child: childWidget!,
                                    );
                                  },
                                );
                                if (date != null) {
                                  model.text = "${date.hour}:${date.minute}";
                                  widget.onChanged(date as T);
                                }
                              },
                              icon: const Icon(Icons.access_time),
                            )
                            : (T == DateTime)
                            ? IconButton(
                              onPressed: () async {
                                DateTime? lastDate =
                                    widget.lastDate ??
                                    DateTime.now().add(
                                      const Duration(days: 365),
                                    );
                                DateTime? initialDate =
                                    widget.value as DateTime?;
                                final date = await showDatePicker(
                                  context: context,
                                  cancelText:
                                      widget.cancelText ?? widget.cancelText,
                                  confirmText:
                                      widget.confirmText ?? widget.confirmText,
                                  initialDatePickerMode: widget.datePickerMode,
                                  initialDate:
                                      initialDate.isAfter(lastDate)
                                          ? null
                                          : initialDate,
                                  firstDate:
                                      widget.firstDate ??
                                      DateTime.now().subtract(
                                        const Duration(days: 365),
                                      ),
                                  lastDate: lastDate,
                                  locale: Locale(widget.locale.split('-')[0]),
                                );
                                if (date != null) {
                                  if (widget.isIncludeTime) {
                                    TimeOfDay timeOfDays =
                                        TimeOfDay.fromDateTime(date);
                                    await Future.delayed(Duration.zero);
                                    if (!mounted) return;
                                    TimeOfDay? timeOfDay = await showTimePicker(
                                      context: context,
                                      initialTime: timeOfDays,
                                      cancelText:
                                          widget.cancelText ??
                                          widget.cancelText,
                                      confirmText:
                                          widget.confirmText ??
                                          widget.confirmText,
                                      builder: (context, childWidget) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat:
                                                widget.alwaysUse24HourFormat,
                                          ),
                                          child: childWidget!,
                                        );
                                      },
                                    );
                                    if (timeOfDay != null) {
                                      DateTime selectedDate = DateTime(
                                        date.year,
                                        date.month,
                                        date.day,
                                        timeOfDay.hour,
                                        timeOfDay.minute,
                                      );
                                      model.text = selectedDate.toStrings(
                                        locale: widget.locale,
                                        format: Formats.dateTime,
                                      );
                                      widget.onChanged(selectedDate as T);
                                    }
                                  } else {
                                    model.text = date.toStrings(
                                      locale: widget.locale,
                                    );
                                    widget.onChanged(date as T);
                                  }
                                }
                              },
                              icon: const Icon(Icons.calendar_today),
                            )
                            : T == DateTimeRange
                            ? IconButton(
                              onPressed: () async {
                                final date = await showDateRangePicker(
                                  context: context,
                                  cancelText:
                                      widget.cancelText ?? widget.cancelText,
                                  confirmText:
                                      widget.confirmText ?? widget.confirmText,
                                  saveText: widget.saveText ?? widget.saveText,
                                  locale: Locale(widget.locale.split('-')[0]),
                                  initialDateRange:
                                      widget.value == null
                                          ? DateTimeRange(
                                            start: DateTime.now(),
                                            end: DateTime.now(),
                                          )
                                          : widget.value as DateTimeRange,
                                  currentDate: DateTime.now(),
                                  firstDate:
                                      widget.firstDate ??
                                      DateTime.now().subtract(
                                        const Duration(days: 365),
                                      ),
                                  lastDate:
                                      widget.lastDate ??
                                      DateTime.now().add(
                                        const Duration(days: 365),
                                      ),
                                );
                                if (date != null) {
                                  model.text =
                                      "${date.start.toStrings(locale: widget.locale)} - ${date.end.toStrings(locale: widget.locale)}";
                                  widget.onChanged(date as T);
                                }
                              },
                              icon: const Icon(Icons.date_range),
                            )
                            : widget.isSuffixIcon
                            ? IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                if (T == int) {
                                  model.text = "0";
                                  widget.onChanged(0 as T);
                                } else if (T == double) {
                                  model.text = "0.0";
                                  widget.onChanged(0.0 as T);
                                } else if (T == String) {
                                  model.text = "";
                                  widget.onChanged("" as T);
                                }
                              },
                            )
                            : null)),
                focusedErrorBorder:
                    widget.borderRadius == null
                        ? null
                        : OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius ?? 5),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                errorBorder:
                    widget.borderRadius == null
                        ? null
                        : OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius ?? 5),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                focusedBorder:
                    widget.borderRadius == null
                        ? null
                        : OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius ?? 5),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                enabledBorder:
                    widget.borderRadius == null
                        ? null
                        : OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius ?? 5),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                border:
                    widget.borderRadius == null
                        ? null
                        : OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius ?? 5),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                disabledBorder:
                    widget.borderRadius == null
                        ? null
                        : OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(widget.borderRadius ?? 5),
                          ),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
              ),
    );

    return input;
  }
}

class Notifier<T> extends ChangeNotifier {
  void commit() {
    notifyListeners();
  }

  bool _isError = false;
  bool get isError => _isError;
  set isError(bool value) {
    _isError = value;
    commit();
  }

  bool _isObscureText = true;
  bool get isObscureText => _isObscureText;
  set isObscureText(bool value) {
    _isObscureText = value;
    commit();
  }

  TextEditingController controller = TextEditingController();
  set text(String value) {
    controller.text = value;
    commit();
  }
}

enum PositionLabel { top, bottom, left, right, input, none }

enum StringType { text, multiline, emailAddress, url }

class Debouncer {
  Duration? duration;
  Timer? _timer;

  Debouncer({this.duration});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(duration ?? const Duration(milliseconds: 500), action);
  }
}
