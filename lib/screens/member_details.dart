import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:golden_gym_system/db/local_db.dart';
import 'package:golden_gym_system/utilities/general.dart';
import 'package:moor/moor.dart';
import 'package:provider/provider.dart';

import 'package:golden_gym_system/controllers/provider.dart';

class AddMemeberScreen extends StatefulWidget {
  final Member? member;
  const AddMemeberScreen({Key? key, this.member}) : super(key: key);

  @override
  _AddMemeberScreenState createState() => _AddMemeberScreenState();
}

class _AddMemeberScreenState extends State<AddMemeberScreen> {
  File? imageFile;
  final _formKey = GlobalKey<FormBuilderState>();

  late bool _enable;

  @override
  void initState() {
    _enable = widget.member == null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        floatingActionButton: _buildFloatingActionButton(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: FormBuilder(
                  key: _formKey,
                  child: ListView.separated(
                    itemCount: _forms().length,
                    separatorBuilder: (context, index) => const SizedBox(height: 15),
                    itemBuilder: (context, index) => _forms()[index],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: const Alignment(0.0, -0.9),
                  child: IgnorePointer(
                    ignoring: !_enable,
                    child: GestureDetector(
                      onTap: _selectImage,
                      child: _buildImage(),
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

  Widget _buildImage() {
    ImageProvider? imageProvider;
    if (imageFile != null) {
      imageProvider = FileImage(imageFile!);
    } else if (widget.member != null && widget.member!.image != null) {
      imageProvider = MemoryImage(widget.member!.image!);
    }

    return CircleAvatar(
      radius: 50,
      child: imageProvider != null ? null : const Icon(Icons.person),
      backgroundImage: imageProvider,
    );
  }

  FloatingActionButton? _buildFloatingActionButton() {
    if (widget.member != null && _enable) {
      return FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () {
          setState(() {
            _enable = !_enable;
          });
        },
      );
    } else if (widget.member != null) {
      return FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
          setState(() {
            _enable = !_enable;
          });
        },
      );
    } else {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _addNewMember,
      );
    }
  }

  T _getFormValue<T>(ForrmField field) {
    var currentState = _formKey.currentState!;
    return currentState.fields[field.toStr()]!.value as T;
  }

  void _addNewMember() async {
    var currentState = _formKey.currentState;

    if (!currentState!.saveAndValidate()) return;

    final memberProvider = context.read<MembersProvider>();

    final code = int.tryParse(_getFormValue((ForrmField.code)));
    // ignore: avoid_print
    if (code == null) return print("dsjfkldjfkjdklf");

    final image = imageFile != null ? await imageFile!.readAsBytes() : null;

    final name = _getFormValue<String>(ForrmField.name);
    final membershipStart = _getFormValue<DateTime>(ForrmField.membershipStart);
    final membershipEnd = _getFormValue<DateTime>(ForrmField.membershipEnd);
    final membershipType = _getFormValue<MembershipType>(ForrmField.membershipType);

    var member = MembersCompanion.insert(
      code: code,
      name: name,
      membershipStart: membershipStart,
      membershipEnd: membershipEnd,
      membershipType: enumToString(membershipType),
    ).copyWith(image: Value(image));

    try {
      await memberProvider.addNewMember(member);
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  void _selectImage() async {
    final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'png']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;
    setState(() => imageFile = File(file.path));
  }

  List<Widget> _forms() {
    final memberProvider = context.read<MembersProvider>();

    return <Widget>[
      FormBuilderTextField(
        enabled: _enable,
        name: ForrmField.code.toStr(),
        decoration: const InputDecoration(labelText: 'كود المشترك'),
        initialValue: widget.member?.code.toString(),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
          FormBuilderValidators.integer(context),
        ]),
      ),
      FormBuilderTextField(
        enabled: _enable,
        name: ForrmField.name.toStr(),
        initialValue: widget.member?.name,
        decoration: const InputDecoration(labelText: 'اسم المشترك'),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
        ]),
      ),
      FormBuilderDateTimePicker(
        enabled: _enable,
        inputType: InputType.date,
        name: ForrmField.membershipStart.toStr(),
        initialValue: widget.member?.membershipStart,
        decoration: const InputDecoration(labelText: 'بداية الاشتراك'),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
        ]),
      ),
      FormBuilderDateTimePicker(
        enabled: _enable,
        inputType: InputType.date,
        name: ForrmField.membershipEnd.toStr(),
        initialValue: widget.member?.membershipEnd,
        decoration: const InputDecoration(labelText: 'نهاية الاشتراك'),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
        ]),
      ),
      FormBuilderDropdown(
        enabled: _enable,
        initialValue:
            (widget.member == null ? null : enumFromString(widget.member!.membershipType, MembershipType.values)) ??
                MembershipType.normal,
        name: ForrmField.membershipType.toStr(),
        decoration: const InputDecoration(labelText: 'نوع الاشتراك'),
        allowClear: true,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
        ]),
        items: MembershipType.values.map((type) {
          return DropdownMenuItem(
            value: type,
            child: Text(memberProvider.membershipType(type)),
          );
        }).toList(),
      ),
    ];
  }
}
