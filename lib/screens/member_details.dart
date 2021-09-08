import 'dart:async';
import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:golden_gym_system/controllers/provider.dart';
import 'package:golden_gym_system/db/local_db.dart';
import 'package:golden_gym_system/utilities/general.dart';

import '../utilities/datetime_format.dart';

import 'view_image.dart';

class AddMemeberScreen extends StatefulWidget {
  final Member? member;
  const AddMemeberScreen({Key? key, this.member}) : super(key: key);

  @override
  _AddMemeberScreenState createState() => _AddMemeberScreenState();
}

class _AddMemeberScreenState extends State<AddMemeberScreen> {
  Member? _member;

  File? imageFile;
  final _formKey = GlobalKey<FormBuilderState>();
  late final StreamSubscription<Member> _streamSubscription;

  late bool _inViewMode;

  @override
  void initState() {
    _member = widget.member;
    _inViewMode = _member == null;
    if (_member != null && _member?.image != null) {
      imageFile = File(_member!.image!);
    }
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_member != null) {
        _streamSubscription = context.read<MembersProvider>().watchMember(_member!.id).listen((member) {
          if (mounted && _member != member) {
            setState(() {
              _member = member;

              imageFile = File(_member!.image!);
            });
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  void _toggleEnableEdit() {
    setState(() => _inViewMode = !_inViewMode);
  }

  void _addNewMember() async {
    var currentState = _formKey.currentState;
    if (!currentState!.saveAndValidate()) return;
    final memberProvider = context.read<MembersProvider>();
    final member = memberfromFieldss(currentState.fields, imageFile);
    try {
      await memberProvider.addNewMember(member);
      Navigator.pop(context);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void _upadateMember() async {
    if (!_inViewMode && _member != null) return;
    var currentState = _formKey.currentState;
    if (!currentState!.saveAndValidate()) return;
    final memberProvider = context.read<MembersProvider>();
    final member = updateMemberFromFields(currentState.fields, member: _member!);
    try {
      await memberProvider.updateMember(member, imageFile);
      // Navigator.pop(context);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    } finally {
      _toggleEnableEdit();
    }
  }

  void _deleteMember() async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("هل تود حذف العضو؟"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(primary: Colors.red),
                child: Text(" حذف " + _member!.name),
              ),
            ],
          );
        });
    if (result == null) return;
    context.read<MembersProvider>().deleteMember(_member!, imageFile);
    Navigator.pop(context);
  }

  void _selectImage() async {
    final typeGroup = XTypeGroup(label: 'images', extensions: ['jpg', 'png']);
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;
    setState(() => imageFile = File(file.path));
  }

  @override
  Widget build(BuildContext context) {
    // print(_member?.image ?? '-');
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_member?.name ?? ''),
          actions: [
            if (_member != null && _inViewMode)
              IconButton(
                onPressed: _deleteMember,
                icon: const Icon(Icons.delete_forever, color: Colors.red),
              )
          ],
        ),
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
              const VerticalDivider(endIndent: 10, indent: 15),
              Expanded(
                child: Align(
                  alignment: const Alignment(0.0, -0.9),
                  child: Column(
                    children: [
                      InkWell(
                        onDoubleTap: () {
                          if (imageFile == null && !_inViewMode) return;
                          ImageDialog(
                            image: FileImage(imageFile!),
                          ).show(context);
                        },
                        onTap: () {
                          if (_inViewMode) return _selectImage();
                          if (imageFile == null) return;
                          ImageDialog(
                            image: FileImage(imageFile!),
                          ).show(context);
                        },
                        child: _buildImage(),
                      ),
                      const SizedBox(height: 40),
                      DefaultTextStyle(
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                        child: Column(
                          children: [
                            const Text("تم التحديث في"),
                            const SizedBox(height: 6),
                            Text(_member?.updatedAt.toLocalizedDateTime(locale: context.locale) ?? '-'),
                          ],
                        ),
                      ),
                    ],
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
    ImageProvider? imageProvider = imageFile == null ? null : FileImage(imageFile!);
    Widget child;
    if (imageProvider != null) {
      child = Image(image: imageProvider);
    } else {
      child = SizedBox.fromSize(
        size: const Size.square(200),
        child: const Icon(Icons.person, size: 50),
      );
    }
    final borderRadius = BorderRadius.circular(10);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_member != null && _inViewMode) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'save_button',
            child: const Icon(Icons.save),
            onPressed: _upadateMember,
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: 'cancel_button',
            child: const Icon(Icons.close),
            onPressed: _toggleEnableEdit,
          ),
        ],
      );
    } else if (_member != null) {
      return FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: _toggleEnableEdit,
      );
    } else {
      return FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _addNewMember,
      );
    }
  }

  List<Widget> _forms() {
    final memberProvider = context.read<MembersProvider>();

    return <Widget>[
      FormBuilderTextField(
        enabled: _inViewMode,
        name: ForrmField.name.toStr(),
        initialValue: _member?.name,
        decoration: const InputDecoration(labelText: 'اسم المشترك'),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
        ]),
      ),
      FormBuilderDateTimePicker(
        enabled: _inViewMode,
        inputType: InputType.date,
        name: ForrmField.membershipStart.toStr(),
        initialValue: _member?.membershipStart,
        decoration: const InputDecoration(labelText: 'بداية الاشتراك'),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
        ]),
      ),
      FormBuilderDateTimePicker(
        enabled: _inViewMode,
        inputType: InputType.date,
        name: ForrmField.membershipEnd.toStr(),
        initialValue: _member?.membershipEnd,
        decoration: const InputDecoration(labelText: 'نهاية الاشتراك'),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(context),
        ]),
      ),
      FormBuilderDropdown(
        enabled: _inViewMode,
        initialValue: (_member == null
                ? null
                : enumFromString(
                    _member!.membershipType,
                    MembershipType.values,
                  )) ??
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
      FormBuilderTextField(
        enabled: _inViewMode,
        name: ForrmField.weight.toStr(),
        initialValue: _member?.weight?.toString(),
        decoration: const InputDecoration(labelText: 'الوزن'),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
        ],
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.numeric(context),
        ]),
      ),
      FormBuilderTextField(
        enabled: _inViewMode,
        name: ForrmField.height.toStr(),
        initialValue: _member?.height?.toString(),
        decoration: const InputDecoration(labelText: 'الطول'),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
        ],
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.numeric(context),
        ]),
      ),
      FormBuilderTextField(
        enabled: _inViewMode,
        name: ForrmField.muscleMass.toStr(),
        initialValue: _member?.muscleMass?.toString(),
        decoration: const InputDecoration(labelText: 'الكتلة العضلية'),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
        ],
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.numeric(context),
        ]),
      ),
      FormBuilderTextField(
        enabled: _inViewMode,
        name: ForrmField.fatPersentage.toStr(),
        initialValue: _member?.fatPersentage?.toString(),
        decoration: const InputDecoration(labelText: 'نسبة الدهون'),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
        ],
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.numeric(context),
        ]),
      ),
      FormBuilderTextField(
        enabled: _inViewMode,
        name: ForrmField.burnRate.toStr(),
        initialValue: _member?.burnRate?.toString(),
        decoration: const InputDecoration(labelText: 'معدل الحرق'),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp("[0-9.]")),
        ],
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.numeric(context),
        ]),
      ),
    ];
  }
}
