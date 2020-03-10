import 'dart:async';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/view/design-constants.dart';
import 'package:simso/view/navigation-drawer.dart';
import 'mydialog.dart';
import '../service-locator.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../controller/account-setting-controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountSettingPage extends StatefulWidget {
  final UserModel user;
  AccountSettingPage(this.user);
  @override
  State<StatefulWidget> createState() {
    return AccountSettingPageState(user);
    
  }
}

class AccountSettingPageState extends State<AccountSettingPage> {
  IUserService userService = locator<IUserService>();
  BuildContext context;
  AccountSettingController controller;
  UserModel user;
  UserModel userCopy;
  bool _autoValidate = true;
  var formKey = GlobalKey<FormState>();
  MyDrawer drawer;

  AccountSettingPageState(this.user) {
    controller = AccountSettingController(this);
    userCopy = UserModel.clone(user);
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Account Settings"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: controller.save,
          ),
        ],
      ),
      body: Form(key: formKey, child: _buildPortraitLayout()),
    );
  }

  /* CARDSETTINGS FOR EACH LAYOUT */

  CardSettings _buildPortraitLayout() {
    return CardSettings.sectioned(
      labelWidth: 100,
      children: <CardSettingsSection>[
        CardSettingsSection(
          header: CardSettingsHeader(
            label: 'Info',
          ),
          children: <Widget>[
            _buildCardSettingsText_Name(),
            _buildCardSettingsListPicker_Gender(),
            _buildCardSettingsNumberPicker(),
            // _buildCardSettingsDatePicker(),
            _buildCardSettingsParagraph(3),
          ],
        ),
        // CardSettingsSection(
        //   header: CardSettingsHeader(
        //     label: 'Security',
        //   ),
        //   children: <Widget>[
        //     _buildCardSettingsEmail(),
        //     _buildCardSettingsPassword(),
        //   ],
        // ),
        CardSettingsSection(
          header: CardSettingsHeader(
            label: 'Actions',
          ),
          children: <Widget>[
            _buildCardSettingsButton_Logout(),
            _buildCardSettingsButton_Inactive(),
          ],
        ),
      ],
    );
  }

  /* BUILDERS FOR EACH FIELD */
  CardSettingsButton _buildCardSettingsButton_Inactive() {
    return CardSettingsButton(
      label: 'INACTIVE',
      isDestructive: true,
      onPressed: _inactivePressed,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }

  CardSettingsButton _buildCardSettingsButton_Logout() {
    return CardSettingsButton(
      label: 'LOGOUT',
      //onPressed:drawer.signOut
      // () => FirebaseAuth.instance.signOut(),
    );
  }

  CardSettingsPassword _buildCardSettingsPassword() {
    return CardSettingsPassword(
      labelWidth: 150.0,
      icon: Icon(Icons.lock),
      initialValue: userCopy.password,
      autovalidate: _autoValidate,
      validator: (value) {
        if (value == null) return 'Password is required.';
        if (value.length < 6) return 'Must be no less than 6 characters.';
        return null;
      },
      onSaved: (value) => userCopy.password = value,
      onChanged: (value) {
        setState(() {
          userCopy.password = value;
        });
      },
    );
  }

  CardSettingsEmail _buildCardSettingsEmail() {
    return CardSettingsEmail(
      labelWidth: 150.0,
      icon: Icon(Icons.person),
      initialValue: user.email,
      autovalidate: _autoValidate,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email is required.';
        if (!value.contains('@'))
          return "Email not formatted correctly."; // use regex in real application
        return null;
      },
      onSaved: (value) => userCopy.email = value,
      onChanged: (value) {
        setState(() {
          userCopy.email = value;
        });
      },
    );
  }

  CardSettingsParagraph _buildCardSettingsParagraph(int lines) {
    return CardSettingsParagraph(
      label: 'About Me',
      initialValue: userCopy.aboutme,
      numberOfLines: lines,
      onSaved: controller.saveAboutMe,
      onChanged: (value) {
        setState(() {
          userCopy.aboutme = value;
          user.aboutme = value;
        });
      },
    );
  }

  CardSettingsNumberPicker _buildCardSettingsNumberPicker(
      {TextAlign labelAlign}) {
    return CardSettingsNumberPicker(
      label: 'Age',
      labelAlign: labelAlign,
      initialValue: userCopy.age,
      min: 1,
      max: 100,
      validator: (value) {
        if (value == null) return 'Age is required.';
        return null;
      },
      onSaved: (value) => userCopy.age = value,
      onChanged: (value) {
        setState(() {
          userCopy.age = value;
          user.age = value;
        });
      },
    );
  }

  CardSettingsListPicker _buildCardSettingsListPicker_Gender() {
    return CardSettingsListPicker(
      label: 'Gender',
      initialValue: userCopy.gender,
      hintText: 'Gender',
      autovalidate: _autoValidate,
      options: <String>['Male', 'Female', 'Secrete'],
      values: <String>['M', 'F', 'S'],
      validator: (String value) {
        if (value == null || value.isEmpty) return 'Please select your gender';
        return null;
      },
      onSaved: (value) => userCopy.gender = value,
      onChanged: (value) {
        setState(() {
          userCopy.gender = value;
          user.gender = value;
        });
      },
    );
  }

  CardSettingsText _buildCardSettingsText_Name() {
    return CardSettingsText(
      label: 'User Name',
      //hintText: 'User Name',
      initialValue: userCopy.username,
      requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      autovalidate: _autoValidate,
      validator: (value) {
        if (value == null || value.isEmpty) return 'User name is required.';
        return null;
      },
      onSaved: (value) => userCopy.username = value,
      onChanged: (value) {
        setState(() {
          userCopy.username = value;
          user.username = value;
        });
      },
    );
  }

  /* EVENT HANDLERS */

  void _logoutPressed() {}
  void _inactivePressed() {}
}
