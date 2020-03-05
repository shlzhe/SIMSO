import 'dart:async';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/view/design-constants.dart';
import 'mydialog.dart';
import '../service-locator.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../controller/account-setting-controller.dart';


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
  // once the form submits, this is flipped to true, and fields can then go into autovalidate mode.
  bool _autoValidate = true;
  var formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    AccountSettingPageState(this.user) {
    controller = AccountSettingController(this);
  }

  void stateChanged(Function f) {
    setState(f);
  }

  @override
  Widget build(BuildContext context) {
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
        CardSettingsSection(
          header: CardSettingsHeader(
            label: 'Security',
          ),
          children: <Widget>[
            _buildCardSettingsEmail(),
            _buildCardSettingsPassword(),
          ],
        ),
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
      onPressed: _logoutPressed,
    );
  }

  CardSettingsPassword _buildCardSettingsPassword() {
    return CardSettingsPassword(
      labelWidth: 150.0,
      icon: Icon(Icons.lock),
      initialValue: user.password,
      autovalidate: _autoValidate,
      validator: (value) {
        if (value == null) return 'Password is required.';
        if (value.length < 6) return 'Must be no less than 6 characters.';
        return null;
      },
      onSaved: (value) => user.password = value,
      onChanged: (value) {
        setState(() {
          user.password = value;
        });
        _showSnackBar('Password', value);
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
      onSaved: (value) => user.email = value,
      onChanged: (value) {
        setState(() {
          user.email = value;
        });
        _showSnackBar('Email', value);
      },
    );
  }

  // CardSettingsDatePicker _buildCardSettingsDatePicker() {
  //   return CardSettingsDatePicker(
  //     key: _dateKey,
  //     justDate: true,
  //     icon: Icon(Icons.calendar_today),
  //     label: 'Birthday',
  //     initialValue: user.showDateTime,
  //     onSaved: (value) => user.showDateTime =
  //         updateJustDate(value, user.showDateTime),
  //     onChanged: (value) {
  //       setState(() {
  //         user.showDateTime = value;
  //       });
  //       _showSnackBar(
  //           'Show Date', updateJustDate(value, user.showDateTime));
  //     },
  //   );
  // }

  CardSettingsParagraph _buildCardSettingsParagraph(int lines) {
    return CardSettingsParagraph(
      label: 'About Me',
      initialValue: user.aboutme,
      numberOfLines: lines,
      onSaved: (value) => user.aboutme = value,
      onChanged: (value) {
        setState(() {
          user.aboutme = value;
        });
        _showSnackBar('About Me', value);
      },
    );
  }

  CardSettingsNumberPicker _buildCardSettingsNumberPicker(
      {TextAlign labelAlign}) {
    return CardSettingsNumberPicker(
      label: 'Age',
      labelAlign: labelAlign,
      initialValue: user.age,
      min: 1,
      max: 100,
      validator: (value) {
        if (value == null) return 'Age is required.';
        return null;
      },
      onSaved: (value) => user.age = value,
      onChanged: (value) {
        setState(() {
          user.age = value;
        });
        _showSnackBar('Age', value);
      },
    );
  }

  CardSettingsListPicker _buildCardSettingsListPicker_Gender() {
    return CardSettingsListPicker(
      label: 'Gender',
      initialValue: user.gender,
      hintText: 'Gender',
      autovalidate: _autoValidate,
      options: <String>['Male', 'Female', 'Secrete'],
      values: <String>['M', 'F', 'S'],
      validator: (String value) {
        if (value == null || value.isEmpty) return 'Please select your gender';
        return null;
      },
      onSaved: (value) => user.gender = value,
      onChanged: (value) {
        setState(() {
          user.gender = value;
        });
        _showSnackBar('Gender', value);
      },
    );
  }

  CardSettingsText _buildCardSettingsText_Name() {
    return CardSettingsText(
      label: 'User Name',
      //hintText: 'User Name',
      initialValue: user.username,
      requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      autovalidate: _autoValidate,
      validator: (value) {
        if (value == null || value.isEmpty) return 'User name is required.';
        return null;
      },
      showErrorIOS:
          user.username == null || user.username.isEmpty,
      onSaved: (value) => user.username = value,
      onChanged: (value) {
        setState(() {
          user.username = value;
        });
        _showSnackBar('User Name', value);
      },
    );
  }

  /* EVENT HANDLERS */

  Future _savePressed() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
    } else {
      setState(() => _autoValidate = true);
    }
  }

  void _logoutPressed() {}
  void _inactivePressed() {}

  void _showSnackBar(String label, dynamic value) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(label + ' = ' + value.toString()),
      ),
    );
  }
}
