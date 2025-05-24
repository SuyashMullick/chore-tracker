import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:provider/provider.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  GroupPageState createState() => GroupPageState();
}

class GroupPageState extends State<GroupPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GroupViewModel>(
      builder: (context, groupViewModel, _) {
        List<Group> groups = groupViewModel.getGroups();
        List<Widget> widgets = [];
        for (var group in groups) {
          widgets.add(
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: group.getName(),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    Column(
                      children: group
                          .getMembers()
                          .map(
                            (member) => ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(member.getName()),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () =>
                                    groupViewModel.removeMember(group, member),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return SizedBox.expand(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(children: widgets),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: FloatingActionButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CreateGroupDialog(
                            groupViewModel: groupViewModel);
                      },
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CreateGroupDialog extends StatefulWidget {
  final GroupViewModel groupViewModel;

  const CreateGroupDialog({super.key, required this.groupViewModel});

  @override
  CreateGroupDialogState createState() => CreateGroupDialogState();
}

class CreateGroupDialogState extends State<CreateGroupDialog> {
  late final TextEditingController _groupDescEditingController;
  final _formKey = GlobalKey<FormState>();
  List<User> _selectedMembers = [];

  @override
  void initState() {
    super.initState();
    _groupDescEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: const Text('Create a group'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(
            maxLength: 20,
            controller: _groupDescEditingController,
            decoration: const InputDecoration(
              labelText: 'Name of the group',
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'A name has to be set';
              }
              return null;
            },
          ),
          DropDownMultiSelect<User>(
            selectedValuesStyle: const TextStyle(color: Colors.transparent),
            onChanged: (List<User> selected) {
              setState(() {
                _selectedMembers = selected;
              });
            },
            options: widget.groupViewModel.getAllMembers(),
            selectedValues: _selectedMembers,
            whenEmpty: 'Select members',
          ),
        ]),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              if (_groupDescEditingController.text.isNotEmpty) {
                final Group newGroup =
                    Group(name: _groupDescEditingController.text, id: 0);
                widget.groupViewModel.addMembers(newGroup, _selectedMembers);

                widget.groupViewModel.addGroup(newGroup);
                _groupDescEditingController.clear();
                _selectedMembers.clear();
                Navigator.of(context).pop();
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
