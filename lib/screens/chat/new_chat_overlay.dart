import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timetable_app/app_themes.dart';
import 'package:timetable_app/main.dart';
import 'package:timetable_app/models/chat_room.dart';
import 'package:timetable_app/providers/chat_room_provider.dart';
import 'package:timetable_app/providers/nav_provider.dart';
import 'package:timetable_app/widgets/chat/email_list_tile.dart';
import 'package:timetable_app/widgets/primary_elevated_button_loading_child.dart';
import 'package:timetable_app/widgets/shadowed_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewChatOverlay extends ConsumerStatefulWidget {
  const NewChatOverlay({super.key, this.chatRoom})
      : isNewMode = chatRoom == null;

  final ChatRoom? chatRoom;
  final bool isNewMode;

  @override
  ConsumerState<NewChatOverlay> createState() => _NewChatOverlayState();
}

class _NewChatOverlayState extends ConsumerState<NewChatOverlay> {
  final _formKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  String enteredChatName = '';
  final TextEditingController _chatNameController = TextEditingController();
  final List<String> _emails = [];
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  String _enteredEmail = '';
  bool _loadingEditing = false;

  @override
  void initState() {
    _initializeEditing();
    super.initState();
  }

  @override
  void dispose() {
    _chatNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _setEditingLoading(bool loading) {
    setState(() {
      _loadingEditing = loading;
    });
  }

  void _submitAddEmail() {
    if (_emailFormKey.currentState!.validate()) {
      _emailFormKey.currentState!.save();
      setState(() {
        _emails.add(_enteredEmail);
      });
      _emailController.clear();
    }
  }

  void _submitCreateOrEdit() {
    if (_formKey.currentState!.validate()) {
      if (_emails.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.noEmailsAdded),
              content:
                  Text(AppLocalizations.of(context)!.pleaseAddAtLeastOneEmail),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.ok))
              ],
            );
          },
        );
        return;
      }
      _formKey.currentState!.save();
      if (widget.isNewMode) {
        _createChatRoom();
      } else {
        _updateChatRoom();
      }
    }
  }

  void _createChatRoom() async {
    _setLoading(true);
    final creationError = await ref
        .read(chatRoomProvider.notifier)
        .addChatRoom(enteredChatName.trim(), _emails);
    _setLoading(false);
    if (creationError != null) {
      if (context.mounted) {
        showErrorDialog(context, creationError.toString());
      }
    } else {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _updateChatRoom() async {
    _setLoading(true);
    final editError = await ref
        .read(chatRoomProvider.notifier)
        .updateChatRoom(widget.chatRoom!.id, enteredChatName.trim(), _emails);
    _setLoading(false);
    if (editError != null) {
      if (context.mounted) {
        showErrorDialog(context, editError.toString());
      }
    } else {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _onDeleteChatRoomTapped() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Chatroom'),
          content: const Text(
              'Are you sure you want to delete this chatroom? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                _deleteChatRoom();
              },
              child: Text(AppLocalizations.of(context)!.delete),
            ),
          ],
        );
      },
    );
  }

  void _deleteChatRoom() async {
    _setLoading(true);
    final deleteError = await ref
        .read(chatRoomProvider.notifier)
        .deleteChatRoom(widget.chatRoom!.id);
    _setLoading(false);
    if (deleteError != null) {
      if (context.mounted) {
        showErrorDialog(context, deleteError.toString());
      }
    } else {
      if (context.mounted) {
        popAllScreens(context);
      }
    }
  }

  void _initializeEditing() async {
    if (!widget.isNewMode) {
      _setEditingLoading(true);
      _setLoading(true);
      final chatroom = widget.chatRoom!;
      final resp = await kSupabase.functions.invoke(
        'getChatRoomMemberEmails',
        body: {'chatroomId': chatroom.id},
      );
      final List<dynamic> emails = resp.data['memberEmailsList'];
      final List<String> emailStrings =
          emails.map((e) => e.toString()).toList();
      setState(() {
        _emails.addAll(emailStrings);
      });
      _chatNameController.text = widget.chatRoom!.name;
      _setEditingLoading(false);
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    var addEmailForm = Form(
      key: _emailFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.invitePeopleToChat),
          ShadowedTextFormField(
            child: TextFormField(
              controller: _emailController,
              decoration: AppThemes.entryFieldTheme.copyWith(
                hintText: AppLocalizations.of(context)!.email,
              ),
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              textCapitalization: TextCapitalization.none,
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    !value.contains('@')) {
                  return AppLocalizations.of(context)!.plsEnterEmail;
                } else if (value == kSupabase.auth.currentUser!.email) {
                  return AppLocalizations.of(context)!.cannotAddYourself;
                } else if (_emails.contains(value)) {
                  return AppLocalizations.of(context)!.emailAlreadyAdded;
                } else {
                  return null;
                }
              },
              onSaved: (newValue) {
                _enteredEmail = newValue!;
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  _emailFormKey.currentState!.reset();
                  _emailController.clear();
                },
                icon: const Icon(Icons.clear),
                label: Text(AppLocalizations.of(context)!.clear),
              ),
              ElevatedButton.icon(
                style: AppThemes.entryButtonTheme,
                onPressed: _submitAddEmail,
                icon: const Icon(Icons.add_circle),
                label: Text(AppLocalizations.of(context)!.add),
              ),
            ],
          ),
        ],
      ),
    );

    var emailListContainerChild = _emails.isEmpty
        ? Center(child: Text(AppLocalizations.of(context)!.noEmailsAdded))
        : ListView(
            children: _emails.map(
              (email) {
                return EmailListTile(
                  email: email,
                  onTapDelete: () {
                    setState(
                      () {
                        _emails.remove(email);
                      },
                    );
                  },
                );
              },
            ).toList(),
          );

    var emailListContainer = Container(
      decoration: AppThemes.listViewContainerDecoration,
      height: min(deviceHeight * 0.3, 300),
      child: _loadingEditing
          ? const Center(child: CircularProgressIndicator())
          : emailListContainerChild,
    );

    var bottomButtons = Row(
      children: [
        if (!widget.isNewMode)
          TextButton.icon(
              onPressed: (!_isLoading && !_loadingEditing)
                  ? _onDeleteChatRoomTapped
                  : null,
              icon: const Icon(Icons.delete_forever),
              label: Text(AppLocalizations.of(context)!.delete)),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed:
              (!_isLoading && !_loadingEditing) ? _submitCreateOrEdit : null,
          style: AppThemes.entryButtonTheme,
          child: _isLoading && !_loadingEditing
              ? const PrimaryElevatedButtonLoadingChild()
              : Text(
                  widget.isNewMode
                      ? AppLocalizations.of(context)!.create
                      : AppLocalizations.of(context)!.save,
                ),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      child: SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.isNewMode
                        ? AppLocalizations.of(context)!.newChat
                        : AppLocalizations.of(context)!.editChat,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ShadowedTextFormField(
                      child: TextFormField(
                    controller: _chatNameController,
                    decoration: AppThemes.entryFieldTheme.copyWith(
                      hintText: AppLocalizations.of(context)!.chatRoomName,
                      enabled: (!_isLoading && !_loadingEditing),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty ||
                          value.trim().length < 5) {
                        return AppLocalizations.of(context)!
                            .chatRoomNameTooShort;
                      } else {
                        return null;
                      }
                    },
                    onSaved: (newValue) {
                      enteredChatName = newValue!;
                    },
                  )),
                  const SizedBox(height: 10),
                  addEmailForm,
                  const SizedBox(height: 20),
                  emailListContainer,
                  const SizedBox(height: 40),
                  bottomButtons,
                ],
              ),
            ),
          )),
    );
  }
}

showErrorDialog(BuildContext ctx, String message) {
  showDialog(
    context: ctx,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.ok))
        ],
      );
    },
  );
}

class ChatRoomCreationException implements Exception {
  final String message;
  ChatRoomCreationException(this.message);
  @override
  String toString() {
    return message;
  }
}
