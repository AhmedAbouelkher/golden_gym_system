import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:golden_gym_system/db/local_db.dart';
import 'package:moor_flutter/moor_flutter.dart' hide Column;
import 'package:provider/provider.dart';

enum FormFields {
  name,
  membershipStart,
  membershipEnd,
  membershipType,
}

extension on FormFields {
  String toStr() {
    return toString();
  }
}

class AddMemeberScreen extends StatefulWidget {
  const AddMemeberScreen({Key? key}) : super(key: key);

  @override
  _AddMemeberScreenState createState() => _AddMemeberScreenState();
}

class _AddMemeberScreenState extends State<AddMemeberScreen> {
  File? imageFile;
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final db = context.read<MemberDao>();
            var currentState = _formKey.currentState!;
            currentState.validate();
            // if (imageFile == null) return;
            final name = currentState.fields[FormFields.name.toStr()]!.value as String;
            final memebershipStart = currentState.fields[FormFields.membershipStart.toStr()]!.value as DateTime;
            final memebershipEnd = currentState.fields[FormFields.membershipEnd.toStr()]!.value as DateTime;
            // final memebershipType = currentState.fields[FormFields.membershipType.toStr()]!.value as String;

            final m = MembersCompanion(
              name: Value(name),
              membershipStart: Value(memebershipStart),
              membershipEnd: Value(memebershipEnd),
            );
            await db.insertMember(m);
            Navigator.pop(context);
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        name: FormFields.name.toStr(),
                        decoration: const InputDecoration(
                          labelText: 'اسم المشترك',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      FormBuilderDateTimePicker(
                        inputType: InputType.date,
                        name: FormFields.membershipStart.toStr(),
                        decoration: const InputDecoration(
                          labelText: 'بداية الاشتراك',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      FormBuilderDateTimePicker(
                        inputType: InputType.date,
                        name: FormFields.membershipEnd.toStr(),
                        decoration: const InputDecoration(
                          labelText: 'نهاية الاشتراك',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      // FormBuilderDropdown(
                      //   name: FormFields.membershipType.toStr(),
                      //   decoration: const InputDecoration(
                      //     labelText: 'نوع الاشتراك',
                      //   ),
                      //   validator: FormBuilderValidators.compose([
                      //     FormBuilderValidators.required(context),
                      //   ]),
                      //   items: const [
                      //     DropdownMenuItem(value: "s", child: Text("Normal")),
                      //     DropdownMenuItem(value: "ss", child: Text("Extreme")),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: const Alignment(0.0, -0.9),
                  child: GestureDetector(
                    onTap: () async {
                      final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'png']);
                      final file = await openFile(acceptedTypeGroups: [typeGroup]);
                      if (file == null) return;
                      setState(() {
                        imageFile = File(file.path);
                      });
                    },
                    child: CircleAvatar(
                      radius: 50,
                      child: const Icon(Icons.person),
                      backgroundImage: imageFile == null ? null : FileImage(imageFile!),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
