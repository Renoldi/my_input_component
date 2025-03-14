import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:my_input_component/my_input_component.dart';
import 'package:my_input_component_example/main.dart';
export 'package:provider/provider.dart';
import 'mains.dart' as mains;

void main() {
  initializeDateFormatting();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  mains.ViewModel model = mains.ViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ChangeNotifierProvider.value(
        value: model,
        child: Consumer<mains.ViewModel>(
          builder: (ctx, vm, child) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 50,
                            child: Center(
                              child: InputComponent<int>(
                                onChanged: (v) {
                                  model.pin1 = v;
                                  model.commit();
                                },
                                value: model.pin1,
                                positionLabel: PositionLabel.none,
                                label: "Input Number",
                                isRequired: true,
                                isPin: true,
                                focusNode: model.focusNode1,
                                nextFocusNode: model.focusNode2,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Center(
                              child: InputComponent<int>(
                                onChanged: (v) {
                                  model.pin2 = v;
                                  model.commit();
                                },
                                value: model.pin2,
                                positionLabel: PositionLabel.none,
                                label: "Input Number",
                                isRequired: true,
                                isPin: true,
                                focusNode: model.focusNode2,
                                nextFocusNode: model.focusNode3,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Center(
                              child: InputComponent<int>(
                                onChanged: (v) {
                                  model.pin3 = v;
                                  model.commit();
                                },
                                value: model.pin3,
                                positionLabel: PositionLabel.none,
                                label: "Input Number",
                                isRequired: true,
                                isPin: true,
                                focusNode: model.focusNode3,
                                nextFocusNode: model.focusNode4,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50,
                            child: Center(
                              child: InputComponent<int>(
                                onChanged: (v) {
                                  model.pin4 = v;
                                  model.commit();
                                },
                                value: model.pin4,
                                positionLabel: PositionLabel.none,
                                label: "Input Number",
                                isRequired: true,
                                isPin: true,
                                focusNode: model.focusNode4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      InputComponent<String>(
                        onChanged: (v) {
                          //do onchange
                        },
                        positionLabel: PositionLabel.top,
                        label: "Input Text",
                        hint: "Input Text",
                        lastDate: DateTime.now(),
                        isRequired: true,
                        defaultErrorText: "Please fill",
                      ),
                      InputComponent<DateTime>(
                        onChanged: (v) {
                          //do onchange
                        },
                        positionLabel: PositionLabel.top,
                        label: "Input Date",
                        hint: "Input Date",
                        lastDate: DateTime.now(),
                        isRequired: true,
                        defaultErrorText: "Please fill",
                      ),
                      InputComponent<int?>(
                        onChanged: (v) {
                          vm.intNull = v;
                        },
                        value: vm.intNull,
                        positionLabel: PositionLabel.top,
                        label: "Input Number",
                        hint: "Input Number",
                        lastDate: DateTime.now(),
                        isRequired: true,
                        defaultErrorText: "Please fill",
                      ),
                      InputComponent<int>(
                        onChanged: (v) {
                          //do onchange
                        },
                        positionLabel: PositionLabel.top,
                        label: "Input Number",
                        hint: "Input Number Min 10 max 100",
                        lastDate: DateTime.now(),
                        isRequired: true,
                        defaultErrorText: "Please fill",
                        validator: (v) {
                          if (v < 10 || v > 100) {
                            return "Value must be between 10 and 100";
                          }
                          return null;
                        },
                      ),
                      InputComponent<double>(
                        onChanged: (v) {
                          //do onchange
                        },
                        positionLabel: PositionLabel.top,
                        label: "Input decimal",
                        hint: "Input decimal",
                        lastDate: DateTime.now(),
                        isRequired: true,
                        defaultErrorText: "Please fill",
                      ),
                      InputComponent<double>(
                        onChanged: (v) {
                          //do onchange
                        },
                        positionLabel: PositionLabel.top,
                        label: "Input decimal for currency",
                        hint: "Input decimal for currency",
                        lastDate: DateTime.now(),
                        decimalDigits: 0,
                        isRequired: true,
                        defaultErrorText: "Please fill",
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              //do submit
            }
          },
          child: const Text("Submit"),
        ),
      ),
    );
  }
}
