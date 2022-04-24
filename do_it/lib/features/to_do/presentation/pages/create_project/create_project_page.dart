import 'dart:io';

import 'package:do_it/core/base_page.dart';
import 'package:do_it/core/constants/app_colors.dart';
import 'package:do_it/core/constants/dimensions.dart';
import 'package:do_it/core/constants/texts.dart';
import 'package:do_it/core/router/route_paths.dart';
import 'package:do_it/core/util/input_validators.dart';
import 'package:do_it/features/to_do/data/models/user_profile.dart';
import 'package:do_it/features/to_do/presentation/pages/create_project/widgets/image_mode_modal.dart';
import 'package:do_it/features/to_do/presentation/providers/create_project_page_provider.dart';
import 'package:do_it/features/to_do/presentation/widgets/selected_users.dart';
import 'package:do_it/features/to_do/presentation/widgets/tags_input.dart';
import 'package:do_it/shared/widgets/custom_appbar.dart';
import 'package:do_it/shared/widgets/fill_width_button.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({ Key? key }) : super(key: key);

  @override
  _CreateProjectPageState createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final now = DateTime.now();
  
  @override
  Widget build(BuildContext context) {
    return BasePage<CreateProjectPageProvider>(
      child: null,
      provider: CreateProjectPageProvider(
        createProject: Provider.of(context)
      ),
      builder: (context, provider, child) {
        return Scaffold(
          appBar: getCustomAppBar(context),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: AppDimensions.padding,
            child: Form(
              key: provider.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customTextExtraLarge(
                    'Create Project',
                    alignment: TextAlign.start,
                    fontWeight: FontWeight.w600
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) {
                              return ImageSelectionModal(
                                onPickImage: (source) => provider.pickImage(source),
                              );
                            }
                          );
                        },
                        child: Builder(
                          builder: (context) {
                            if (provider.pickedImage == null) {
                              return Container(
                                width: 62,
                                height: 62,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.grey
                                ),
                              );
                            }
            
                            return Container(
                              width: 62,
                              height: 62,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    File(provider.pickedImage!.path),
                                  )
                                )
                              ),
                            );
                          }
                        )
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTextSmall(
                              'Project Name',
                              textColor: Colors.black54
                            ),
                            TextFormField(
                              controller: provider.nameController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) => lengthValidator(
                                value!, 
                                length: 4
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 42),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTextSmall(
                              'Created (from)',
                              textColor: Colors.black54
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final dateTime = await showDatePicker(
                                  context: context, 
                                  initialDate: now,
                                  firstDate: now, 
                                  lastDate: DateTime(now.year + 10)
                                );

                                if (dateTime == null) return;
                                provider.setCreatedDate(dateTime);
                              },
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) => baseValidator(value!),
                                controller: provider.createdDateController,
                                keyboardType: TextInputType.datetime,
                                enabled: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      MdiIcons.calendarMonthOutline,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                  ),
                                  prefixIconColor: Colors.grey,
                                  prefixIconConstraints: BoxConstraints.tight(Size(32, 24)),
                                  contentPadding: EdgeInsets.all(16)
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customTextSmall(
                              'End (to)',
                              textColor: Colors.black54
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                final dateTime = await showDatePicker(
                                  context: context, 
                                  initialDate: provider.endDate,
                                  firstDate: provider.endDate,
                                  lastDate: DateTime(now.year + 10)
                                );

                                if (dateTime == null) return;
                                provider.setEndDate(dateTime);
                              },
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                validator: (value) => baseValidator(value!),
                                controller: provider.endDateController,
                                keyboardType: TextInputType.datetime,
                                enabled: false,
                                decoration: InputDecoration(
                                  isDense: true,
                                  prefixIcon: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      MdiIcons.calendarMonthOutline,
                                      color: Colors.grey,
                                      size: 18,
                                    ),
                                  ),
                                  prefixIconColor: Colors.grey,
                                  prefixIconConstraints: BoxConstraints.tight(Size(32, 24)),
                                  contentPadding: EdgeInsets.all(16)
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 38),
                  SelectedUsersWidget(
                    users: provider.selectedUsers ?? [],
                    onAdd: () async {
                      final selectedUsers = await Navigator.of(context).pushNamed(
                        RoutePaths.selectUsersPage,
                        arguments: provider.selectedUsers
                      );
                      if (selectedUsers != null) {
                        provider.setSelectedUsers(selectedUsers as List<UserProfileModel>);
                      }
                    },
                  ),
                  const SizedBox(height: 38),
                  TagsInput(
                    onTagsModified: (tags) {
                      provider.tags = tags;
                    },
                  ),
                  const SizedBox(height: 38),
                  customTextSmall(
                    'Description',
                    textColor: Colors.black54
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: provider.descriptionController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => baseValidator(value!),
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: 4,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black12,
                        ),
                        borderRadius: BorderRadius.circular(4)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(4)
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        ),
                        borderRadius: BorderRadius.circular(4)
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        ),
                        borderRadius: BorderRadius.circular(4)
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  FillWidthButton(
                    onPressed: () {
                      if (provider.formKey.currentState!.validate()) {
                        provider.initCreateProject(context);
                      }
                    },
                    isLoading: provider.loading,
                    text: 'Create Project'
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}