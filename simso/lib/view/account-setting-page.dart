import 'dart:async';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/cupertino.dart';
import '../model/entities/fake-user-model.dart';
import 'package:simso/view/design-constants.dart';
import 'mydialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Account Setting Page',
      home: AccountSettingPage(),
      theme: ThemeData(
        accentColor: DesignConstants.blue, // background color of card headers
        cardColor: Colors.white, // background color of fields
        backgroundColor: Colors.white, // color outside the card
        primaryColor: Colors.white, // color of page header
        buttonColor: Colors.white, // background color of buttons
        textTheme: TextTheme(
          button: TextStyle(
              color: DesignConstants.blueGreyish), // style of button text
          subhead: TextStyle(color: Colors.grey[800]), // style of input text
        ),
        primaryTextTheme: TextTheme(
          title: TextStyle(color: Colors.lightBlue[50]), // style for headers
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.indigo[400]), // style for labels
        ),
      ),
      darkTheme: ThemeData.dark(),
    );
  }
}

class AccountSettingPage extends StatefulWidget {
  @override
  _AccountSettingPageState createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  final _fakeUserModel = FakeUserModel();

  // once the form submits, this is flipped to true, and fields can then go into autovalidate mode.
  bool _autoValidate = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // control state only works if the field order never changes.
  // to support orientation changes, we assign a unique key to each field
  // if you only have one orientation, the _formKey is sufficient
  final GlobalKey<FormState> _uidKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _usernameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _aboutmeKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _cityKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _dateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _ageKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _genderKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Account Settings"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _savePressed,
          ),
        ],
      ),
      body: Form(key: _formKey, child: _buildPortraitLayout()),
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
      key: _passwordKey,
      icon: Icon(Icons.lock),
      initialValue: _fakeUserModel.password,
      autovalidate: _autoValidate,
      validator: (value) {
        if (value == null) return 'Password is required.';
        if (value.length < 6) return 'Must be no less than 6 characters.';
        return null;
      },
      onSaved: (value) => _fakeUserModel.password = value,
      onChanged: (value) {
        setState(() {
          _fakeUserModel.password = value;
        });
        _showSnackBar('Password', value);
      },
    );
  }

  CardSettingsEmail _buildCardSettingsEmail() {
    return CardSettingsEmail(
      labelWidth: 150.0,
      key: _emailKey,
      icon: Icon(Icons.person),
      initialValue: _fakeUserModel.email,
      autovalidate: _autoValidate,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Email is required.';
        if (!value.contains('@'))
          return "Email not formatted correctly."; // use regex in real application
        return null;
      },
      onSaved: (value) => _fakeUserModel.email = value,
      onChanged: (value) {
        setState(() {
          _fakeUserModel.email = value;
        });
        _showSnackBar('Email', value);
      },
    );
  }

  CardSettingsDatePicker _buildCardSettingsDatePicker() {
    return CardSettingsDatePicker(
      key: _dateKey,
      justDate: true,
      icon: Icon(Icons.calendar_today),
      label: 'Birthday',
      initialValue: _fakeUserModel.showDateTime,
      onSaved: (value) => _fakeUserModel.showDateTime =
          updateJustDate(value, _fakeUserModel.showDateTime),
      onChanged: (value) {
        setState(() {
          _fakeUserModel.showDateTime = value;
        });
        _showSnackBar(
            'Show Date', updateJustDate(value, _fakeUserModel.showDateTime));
      },
    );
  }

  CardSettingsParagraph _buildCardSettingsParagraph(int lines) {
    return CardSettingsParagraph(
      key: _aboutmeKey,
      label: 'About Me',
      initialValue: _fakeUserModel.aboutme,
      numberOfLines: lines,
      onSaved: (value) => _fakeUserModel.aboutme = value,
      onChanged: (value) {
        setState(() {
          _fakeUserModel.aboutme = value;
        });
        _showSnackBar('About Me', value);
      },
    );
  }

  CardSettingsNumberPicker _buildCardSettingsNumberPicker(
      {TextAlign labelAlign}) {
    return CardSettingsNumberPicker(
      key: _ageKey,
      label: 'Age',
      labelAlign: labelAlign,
      initialValue: _fakeUserModel.age,
      min: 1,
      max: 100,
      validator: (value) {
        if (value == null) return 'Age is required.';
        return null;
      },
      onSaved: (value) => _fakeUserModel.age = value,
      onChanged: (value) {
        setState(() {
          _fakeUserModel.age = value;
        });
        _showSnackBar('Age', value);
      },
    );
  }

  CardSettingsListPicker _buildCardSettingsListPicker_Gender() {
    return CardSettingsListPicker(
      key: _genderKey,
      label: 'Gender',
      initialValue: _fakeUserModel.gender,
      hintText: 'Gender',
      autovalidate: _autoValidate,
      options: <String>['Male', 'Female', 'Secrete'],
      values: <String>['M', 'F', 'S'],
      validator: (String value) {
        if (value == null || value.isEmpty) return 'Please select your gender';
        return null;
      },
      onSaved: (value) => _fakeUserModel.gender = value,
      onChanged: (value) {
        setState(() {
          _fakeUserModel.gender = value;
        });
        _showSnackBar('Gender', value);
      },
    );
  }

  CardSettingsText _buildCardSettingsText_Name() {
    return CardSettingsText(
      key: _usernameKey,
      label: 'User Name',
      //hintText: 'User Name',
      initialValue: _fakeUserModel.username,
      requiredIndicator: Text('*', style: TextStyle(color: Colors.red)),
      autovalidate: _autoValidate,
      validator: (value) {
        if (value == null || value.isEmpty) return 'User name is required.';
        return null;
      },
      showErrorIOS:
          _fakeUserModel.username == null || _fakeUserModel.username.isEmpty,
      onSaved: (value) => _fakeUserModel.username = value,
      onChanged: (value) {
        setState(() {
          _fakeUserModel.username = value;
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
