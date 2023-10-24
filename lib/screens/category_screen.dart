import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/state/providers/category_provider.dart';
import 'package:todo_app/widgets/text_field.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _MyCategoryWidgetState();
}

class _MyCategoryWidgetState extends State<CategoryScreen> {
  Icon? _icon;
  int? _iconValue;
  Color? _color = Color(4278430196);
  int? _colorValue;
  bool iconError = false;
  bool colorError = false;
  final TextEditingController _nameController = TextEditingController();

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material]);

    setState(() {});

    _iconValue = icon != null ? icon.codePoint : _iconValue;
    _icon = icon != null ? Icon(icon) : _icon;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
        builder: (context, category, child) => Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.black,
                  statusBarIconBrightness: Brightness.light,
                ),
                elevation: 0,
                //backgroundColor: const Color.fromARGB(31, 163, 163, 163),
                title: const Center(child: Text('Create Category')),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        labelText: 'Category Name',
                        controller: _nameController,
                      ),
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text('Category icon :',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      const SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: _icon == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: _pickIcon,
                                    icon: _icon ?? Container(),
                                    label: _icon == null
                                        ? const Text('Choose icon from library')
                                        : const Text(''),
                                  ),
                                  iconError
                                      ? const Text(
                                          "Please Select Icon",
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : Container()
                                ],
                              )
                            : GestureDetector(
                                onTap: _pickIcon,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: _icon,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text('Category color :',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold))),
                      const SizedBox(
                        height: 16,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Pick a color!'),
                                            content: SingleChildScrollView(
                                              child: BlockPicker(
                                                availableColors: const [Color(4294198070),Color(4293467747),Color(4288423856),Color(4284955319),Color(4282339765),Color(4278430196),Color(4278238420),Color(4278228616),Color(4283215696),Color(4294940672),Color(4294924066),Color(4286141768)],
                                                pickerColor: _color ??
                                                    Color(4278430196), //default color
                                                
                                                onColorChanged: (Color color) {
                                                  //on color picked
                                                  // debugPrint('color:  ${color.value}');
                                                  int data = color.value;

                                                  setState(() {
                                                    colorError = false;
                                                  });
                                                  _colorValue = data;
                                                  _color = Color(data);
                                                },
                                              ),
                                            ),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child: const Text('DONE'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); //dismiss the color picker
                                                },
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text("Pick Color"),
                                ),
                                colorError
                                    ? const Text(
                                        "Please Pick Color",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Container()
                              ],
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            _color != null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: _color,
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                    height: 38,
                                    width: 38,
                                  )
                                : Container()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => {Navigator.pop(context)},
                        child: const Text("Cancel")),
                    ElevatedButton(
                      onPressed: () {
                        if (_colorValue == null) {
                          setState(() {
                            colorError = true;
                          });
                        }
                        if (_iconValue == null) {
                          setState(() {
                            iconError = true;
                          });
                        }
                        if (_formKey.currentState!.validate() && _iconValue != null && _colorValue != null) {
                          category.addCategory(
                              _iconValue, _colorValue, _nameController.text);
                          Navigator.of(context).pop();
                        }
                        
                      },
                      child: const Text("Create Category"),
                    ),
                  ],
                ),
              ),
            ));
  }
}
