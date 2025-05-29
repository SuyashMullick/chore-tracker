import 'package:dev_flutter/ViewModel/group_viewmodel.dart';
import 'package:flutter/material.dart';
//import 'package:multiselect/multiselect.dart';
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
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.castle_rounded),
                        title: Text(group.getName()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return GroupDialog(
                                      groupViewModel: groupViewModel,
                                      selectedGroup: group,
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                groupViewModel.removeGroup(group);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: group
                          .getMembers()
                          .map(
                            (member) => ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(member.getUsername()),
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
                        return GroupDialog(groupViewModel: groupViewModel);
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

class GroupDialog extends StatefulWidget {
  final GroupViewModel groupViewModel;
  final Group? selectedGroup;

  const GroupDialog(
      {super.key, required this.groupViewModel, this.selectedGroup});

  @override
  GroupDialogState createState() => GroupDialogState();
}

class GroupDialogState extends State<GroupDialog> {
  late final TextEditingController _groupNameEditingController;
  final _formKey = GlobalKey<FormState>();
  List<User> _selectedMembers = [];
  bool okPressed = false;

  @override
  void initState() {
    super.initState();
    _groupNameEditingController = TextEditingController(
        text: widget.selectedGroup != null
            ? widget.selectedGroup!.getName()
            : "");
    _selectedMembers =
        widget.selectedGroup != null ? widget.selectedGroup!.getMembers() : [];
  }

  @override
  void dispose() {
    _groupNameEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AlertDialog(
        title: widget.selectedGroup != null
            ? const Text('Edit group')
            : const Text('Create a group'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              maxLength: 20,
              controller: _groupNameEditingController,
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
            Stack(
              children: [
                Positioned(
                  top: 14,
                  child: Text(
                    style: TextStyle(
                      fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                      color: okPressed && _selectedMembers.isEmpty
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    _selectedMembers.isEmpty
                        ? 'Select members'
                        : _selectedMembers
                            .map((user) => user.getUsername())
                            .join(' , '),
                  ),
                ),
                DropdownButtonFormField(
                  onChanged: (x) {},
                  items: widget.groupViewModel.getUsers().map((member) {
                    return DropdownMenuItem(
                      value: member,
                      child: StatefulBuilder(
                        builder: (context, setCbxState) {
                          return Row(
                            children: [
                              Checkbox(
                                value: _selectedMembers.contains(member),
                                onChanged: (isSelected) {
                                  if (isSelected == true) {
                                    _selectedMembers.add(member);
                                  } else {
                                    _selectedMembers.remove(member);
                                  }
                                  setCbxState(() {});
                                  setState(() {});
                                },
                              ),
                              const SizedBox(width: 10),
                              Text(member.getUsername()),
                            ],
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
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
              setState(() {
                okPressed = true;
              });
              if (!_formKey.currentState!.validate()) {
                return;
              }
              if (_groupNameEditingController.text.isNotEmpty) {
                if (widget.selectedGroup == null) {
                  final Group newGroup =
                      Group(name: _groupNameEditingController.text, id: 0);
                  widget.groupViewModel.addGroup(newGroup);
                  widget.groupViewModel.addMembers(newGroup, _selectedMembers);
                } else {
                  widget.selectedGroup!
                      .setName(_groupNameEditingController.text);
                  widget.groupViewModel.refreshView();
                }
                okPressed = false;
                _groupNameEditingController.clear();
                _selectedMembers = [];
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
