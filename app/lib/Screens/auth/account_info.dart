import 'package:app/Providers/app_provider.dart';
import 'package:app/Screens/Commons/common_functions.dart';
import 'package:app/Screens/Commons/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../Commons/notification_widget.dart';

class AccountInformationPage extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _dobController = TextEditingController();

  AccountInformationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.watch(AppProvider.authController.notifier);
    final state = ref.watch(AppProvider.authController);
    final authService = ref.watch(AppProvider.firebaseServiceProvider);
    _dobController.text =
        DateFormat("MM/dd/yyyy").format(authController.dob ?? DateTime.now());
    // authController.setEmail(authController.getLoggedEmail()??"");
    state.copyWith(email: authController.getLoggedEmail() ?? "");
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              onChanged: authController.setName,
                              decoration: InputDecoration(
                                label: const Text("Name"),
                                hintText: "Name",
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade800,
                                    width: 3.0,
                                  ),
                                ),
                              ),
                              validator: (value) =>
                                  CommonFunctions.validate(value, "Name"),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              readOnly: true,
                              initialValue: authController.getLoggedEmail(),
                              onChanged: authController.setEmail,
                              decoration: InputDecoration(
                                enabled: false,
                                label: const Text("Email"),
                                hintText: "Email",
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) =>
                                  CommonFunctions.validate(value, 'Email'),
                            ),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Select your gender:'),
                                RadioListTile(
                                  title: const Text('Male'),
                                  value: 'Male',
                                  groupValue: state.gender,
                                  // set the groupValue parameter
                                  onChanged: (value) {
                                    if (value == null) return;
                                    authController.setGender(value);
                                  },
                                ),
                                RadioListTile(
                                  title: const Text('Female'),
                                  value: 'Female',
                                  groupValue: state.gender,
                                  // set the groupValue parameter
                                  onChanged: (value) {
                                    if (value == null) return;
                                    authController.setGender(value);
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: authController.bio,
                              onChanged: authController.setBio,
                              maxLines: 4,
                              decoration: InputDecoration(
                                label: const Text("Bio"),
                                hintText: "Bio",
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) =>
                                  CommonFunctions.validate(value, 'Gender'),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                                controller: _dobController,
                                onChanged: authController.setName,
                                readOnly: true,
                                onTap: () => WidgetUtils.onSelectDate(
                                        context,
                                        _dobController.text.isEmpty
                                            ? DateTime.now()
                                            : _dobController.text, (datetime) {
                                      _dobController.text =
                                          DateFormat("MM/dd/yyyy")
                                              .format(datetime);
                                      authController.setDob(datetime);
                                    }),
                                decoration: WidgetUtils.dobDecoration(
                                    context,
                                    "Dob",
                                    _dobController.text.isEmpty
                                        ? DateTime.now()
                                        : _dobController.text, (datetime) {
                                  _dobController.text =
                                      DateFormat("MM/dd/yyyy").format(datetime);
                                  authController.setDob(datetime);
                                })),
                            // Text("${notifications.length} notifications!"),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          )),
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final isCompleted = await ref
                                              .read(AppProvider
                                                  .firebaseServiceProvider)
                                              .accountInformation(state);
                                          if (isCompleted) {
                                            await AppProvider.refresh();
                                          }
                                        }
                                      },
                                      child: const Text("Confirm")),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () async {
                                      await authService.signOut();
                                      AppProvider.refresh();
                                    },
                                    child: const Text("Logout"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            child: Center(
              child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                    maxHeight: MediaQuery.of(context).size.height * 0.6,
                  ),
                  child: const NotificationWidget()),
            ),
          ),
        ],
      ),
    );
  }
}
