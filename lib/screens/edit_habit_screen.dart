import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:habit_tracker_app/classes/habit.dart';
import 'package:habit_tracker_app/providers/habit_provider.dart';
import 'package:habit_tracker_app/providers/record_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class EditHabitScreen extends StatefulWidget {
  EditHabitScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-habit';

  @override
  _EditHabitScreenState createState() => _EditHabitScreenState();

  Map<String, IconData> ppMap = <String, IconData>{};

  get iconsMap {
    if (ppMap.isEmpty) {
      for (final iconName in MdiIcons.getIconsName()) {
        final iconData = MdiIcons.fromString(iconName);
        if (iconData != null) {
          ppMap[iconName] = iconData;
        }
      }
    }
    return ppMap;
  }
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  final _formKey = GlobalKey<FormState>();

  var _editedHabit = Habit(
    colorValue: Colors.grey.value,
    description: '',
    targetDuration: 0,
    iconCodePoint: Icons.question_answer.codePoint,
    iconFontFamily: Icons.question_answer.fontFamily,
    iconFontPackage: Icons.question_answer.fontPackage,
    name: '',
    isSelected: false,
  );

  bool _isLoading = false;
  bool _isInit = true;

  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);
  Icon? _icon;

  @override
  void didChangeDependencies() {
    if (_isInit && (ModalRoute.of(context) != null)) {
      final habitId = ModalRoute.of(context)!.settings.arguments as String;
      if (habitId.isNotEmpty) {
        _editedHabit = Provider.of<HabitProvider>(context, listen: false)
            .getHabitById(habitId);
        pickerColor = Color(_editedHabit.colorValue);
        _icon = Icon(IconData(_editedHabit.iconCodePoint,
            fontFamily: _editedHabit.iconFontFamily,
            fontPackage: _editedHabit.iconFontPackage));
      }
    }
    setState(() {
      _isInit = false;
    });
    super.didChangeDependencies();
  }

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
    });
  }

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(
      context,
      iconPackModes: [IconPack.custom],
      customIconPack: widget.iconsMap,
    );

    if (icon != null) {
      setState(() {
        _icon = Icon(icon);
      });
    }
  }

  void _deleteItem() async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("What??"),
        content: Text(
            "Are you sure you wish to delete the '${_editedHabit.name}' habit?"),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text("Abort!")),
          ElevatedButton(
              onPressed: () {
                Provider.of<HabitProvider>(context, listen: false)
                    .removeHabitById(_editedHabit.id);
                Provider.of<RecordProvider>(context)
                    .removeRecordsByHabitId(_editedHabit.id);
                Navigator.of(ctx).pop();
                Navigator.of(ctx).pop();
              },
              child: const Text("Delete!"))
        ],
      ),
    );
  }

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (_icon == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please pick an icon!"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    _editedHabit.iconCodePoint = _icon!.icon!.codePoint;
    _editedHabit.iconFontFamily = _icon!.icon!.fontFamily;
    _editedHabit.iconFontPackage = _icon!.icon!.fontPackage;
    _editedHabit.colorValue = pickerColor.value;

    if (_editedHabit.id.isEmpty) {
      _editedHabit.id = "habit_" +
          DateTime(2022).difference(DateTime.now()).inSeconds.toString();
    } else {
      Provider.of<HabitProvider>(context, listen: false)
          .removeHabitById(_editedHabit.id);
    }
    Provider.of<HabitProvider>(context, listen: false).addHabit(_editedHabit);
    setState(() {
      _isLoading = false;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Habit'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: <Widget>[
                  TextFormField(
                    initialValue: _editedHabit.name,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Habit name",
                      border: OutlineInputBorder(),
                    ),
                    maxLength: 8,
                    onChanged: (value) => _formKey.currentState!.validate(),

                    onSaved: (value) {
                      if (value != null) {
                        _editedHabit = Habit(
                            id: _editedHabit.id,
                            colorValue: _editedHabit.colorValue,
                            description: _editedHabit.description,
                            targetDuration: _editedHabit.targetDuration,
                            iconCodePoint: _editedHabit.iconCodePoint,
                            iconFontFamily: _editedHabit.iconFontFamily,
                            iconFontPackage: _editedHabit.iconFontFamily,
                            isSelected: false,
                            name: value);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    initialValue: _editedHabit.description,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Habit description",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (value) => _formKey.currentState!.validate(),
                    onSaved: (value) {
                      if (value != null) {
                        _editedHabit = Habit(
                            id: _editedHabit.id,
                            colorValue: _editedHabit.colorValue,
                            description: value,
                            targetDuration: _editedHabit.targetDuration,
                            iconCodePoint: _editedHabit.iconCodePoint,
                            iconFontFamily: _editedHabit.iconFontFamily,
                            iconFontPackage: _editedHabit.iconFontFamily,
                            isSelected: false,
                            name: _editedHabit.name);
                      }
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Pick a color!'),
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: currentColor,
                              onColorChanged: changeColor,
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text("Choose color"),
                              onPressed: () {
                                setState(() {
                                  currentColor = pickerColor;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      "Pick a color",
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(pickerColor)),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _pickIcon,
                        child: const Text('Pick an icon!'),
                      ),
                      const SizedBox(height: 10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _icon ?? Container(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    child: const Text("Submit!"),
                    onPressed: _saveForm,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                    child: const Text("Delete!"),
                    style: _editedHabit.name.isEmpty
                        ? null
                        : ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red)),
                    onPressed: _editedHabit.name.isEmpty ? null : _deleteItem,
                  )
                ],
              ),
            ),
    );
  }
}
