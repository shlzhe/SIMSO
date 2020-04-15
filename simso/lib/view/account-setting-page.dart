import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:simso/model/entities/user-model.dart';
import 'package:simso/view/design-constants.dart';
import 'package:simso/view/navigation-drawer.dart' as drawer;
import '../service-locator.dart';
import 'package:simso/model/services/iuser-service.dart';
import '../controller/account-setting-controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  bool autoValidate = true;
  bool changing = false;
  bool changing_p = false;
  bool changing_s = false;

  var formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();

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
    return WillPopScope(
      onWillPop: controller.onBackPressed,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Account Settings"),
          actions: (changing || (changing_p && changing_s)) == true
              ? <Widget>[
                  IconButton(
                      icon: Icon(Icons.save), onPressed: controller.save),
                ]
              : null,
        ),
        body: Form(key: formKey, child: _buildPortraitLayout()),
      ),
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
            Container(
              padding: EdgeInsets.all(10),
              width: 70,
              height: 120,
              child: CachedNetworkImage(
                imageUrl: user.profilePic != null && user.profilePic != ''
                    ? user.profilePic
                    : DesignConstants.profile,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.account_circle),
              ),
            ),
            _buildCardSettingsButton_Avatar(),
            _buildCardSettingsText_Name(),
            _buildCardSettingsText_City(),
            _buildCardSettingsListPicker_Gender(),
            _buildCardSettingsListPicker_Language(),
            _buildCardSettingsNumberPicker(),
            _buildCardSettingsParagraph(3),
          ],
        ),
        CardSettingsSection(
          header: CardSettingsHeader(
            label: 'Security',
          ),
          children: <Widget>[
            //_buildCardSettingsEmail(),
            _buildCardSettingsSwitch(),
            _buildCardSettingsPassword(),
            //_buildCardSettingsButton_Logout(),
            _buildCardSettingsButton_Delete(),
          ],
        ),
      ],
    );
  }

  /* BUILDERS FOR EACH FIELD */
  CardSettingsButton _buildCardSettingsButton_Delete() {
    return CardSettingsButton(
      label: 'Delete Account',
      isDestructive: true,
      onPressed: controller.deleteUser,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }

  CardSettingsButton _buildCardSettingsButton_Avatar() {
    return CardSettingsButton(
      label: 'Change Avatar',
      onPressed: controller.changeAvatar,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
    );
  }

  CardSettingsSwitch _buildCardSettingsSwitch() {
    return CardSettingsSwitch(
      label: 'Want to change password?',
      labelWidth: 250.0,
      initialValue: changing_s,
      onSaved: (value) => changing_s = value,
      onChanged: (value) {
        setState(() {
          changing_s = value;
        });
      },
    );
  }

  CardSettingsPassword _buildCardSettingsPassword() {
    return CardSettingsPassword(
      visible: changing_s,
      hintText: 'Enter new password',
      labelWidth: 150.0,
      icon: Icon(Icons.lock),
      initialValue: null,
      autovalidate: autoValidate,
      validator: (value) {
        if (changing_p == true) {
          if (value == null) return 'Password is required';
          if (value.length < 6) return 'Must be no less than 6 characters';
          return null;
        } else
          return null;
      },
      onSaved: controller.savePassword,
      onChanged: (value) {
        setState(() {
          userCopy.password = value;
          changing_p = true;
        });
      },
    );
  }

  // CardSettingsEmail _buildCardSettingsEmail() {
  //   return CardSettingsEmail(
  //     labelWidth: 150.0,
  //     icon: Icon(Icons.person),
  //     initialValue: user.email,
  //     autovalidate: autoValidate,
  //   );
  // }

  CardSettingsParagraph _buildCardSettingsParagraph(int lines) {
    return CardSettingsParagraph(
      label: 'About Me',
      initialValue: userCopy.aboutme,
      numberOfLines: lines,
      onSaved: controller.saveAboutMe,
      onChanged: (value) {
        setState(() {
          changing = true;
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
      min: 0,
      max: 100,
      validator: (value) {
        //if (value == null) return 'Age is required.';
        return null;
      },
      onSaved: (value) => userCopy.age = value,
      onChanged: (value) {
        setState(() {
          changing = true;
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
      autovalidate: autoValidate,
      options: <String>['Male', 'Female', 'Secrete'],
      values: <String>['M', 'F', 'S'],
      validator: (String value) {
        //if (value == null || value.isEmpty) return 'Please select your gender';
        return null;
      },
      onSaved: (value) => userCopy.gender = value,
      onChanged: (value) {
        changing = true;
        setState(() {
          userCopy.gender = value;
          user.gender = value;
        });
      },
    );
  }

  CardSettingsListPicker _buildCardSettingsListPicker_Language() {
    return CardSettingsListPicker(
      label: 'Language',
      initialValue: userCopy.language,
      hintText: 'Language',
      autovalidate: autoValidate,
      options: <String>[
        'None',
        'Afrikaans',
        'Albanian',
        'Amharic',
        'Arabic',
        'Armenian',
        'Azerbaijani',
        'Basque',
        'Belarusian',
        'Bengali',
        'Bosnian',
        'Bulgarian',
        'Catalan',
        'Cebuano',
        'Chichewa',
        'Chinese Simplified',
        'Chinese Traditional',
        'Corsican',
        'Croatian',
        'Czech',
        'Danish',
        'Dutch',
        'English',
        'Esperanto',
        'Estonian',
        'Filipino',
        'Finnish',
        'French',
        'Frisian',
        'Galician',
        'Georgian',
        'German',
        'Greek',
        'Gujarati',
        'Haitian Creole',
        'Hausa',
        'Hawaiian',
        'Hebrew',
        'Hindi',
        'Hmong',
        'Hungarian',
        'Icelandic',
        'Igbo',
        'Indonesian',
        'Irish',
        'Italian',
        'Japanese',
        'Javanese',
        'Kannada',
        'Kazakh',
        'Khmer',
        'Korean',
        'Kurdish (Kurmanji)',
        'Kyrgyz',
        'Lao',
        'Latin',
        'Latvian',
        'Lithuanian',
        'Luxembourgish',
        'Macedonian',
        'Malagasy',
        'Malay',
        'Malayalam',
        'Maltese',
        'Maori',
        'Marathi',
        'Mongolian',
        'Myanmar (Burmese)',
        'Nepali',
        'Norwegian',
        'Pashto',
        'Persian',
        'Polish',
        'Portuguese',
        'Punjabi',
        'Romanian',
        'Russian',
        'Samoan',
        'Scots Gaelic',
        'Serbian',
        'Sesotho',
        'Shona',
        'Sindhi',
        'Sinhala',
        'Slovak',
        'Slovenian',
        'Somali',
        'Spanish',
        'Sundanese',
        'Swahili',
        'Swedish',
        'Tajik',
        'Tamil',
        'Telugu',
        'Thai',
        'Turkish',
        'Ukrainian',
        'Urdu',
        'Uzbek',
        'Vietnamese',
        'Welsh',
        'Xhosa',
        'Yiddish',
        'Yoruba',
        'Zulu'
      ],
      values: <String>[
        'none',
        'af',
        'sq',
        'am',
        'ar',
        'hy',
        'az',
        'eu',
        'be',
        'bn',
        'bs',
        'bg',
        'ca',
        'ceb',
        'ny',
        'zh-cn',
        'zh-tw',
        'co',
        'hr',
        'cs',
        'da',
        'nl',
        'en',
        'eo',
        'et',
        'tl',
        'fi',
        'fr',
        'fy',
        'gl',
        'ka',
        'de',
        'el',
        'gu',
        'ht',
        'ha',
        'haw',
        'iw',
        'hi',
        'hmn',
        'hu',
        'is',
        'ig',
        'id',
        'ga',
        'it',
        'ja',
        'jw',
        'kn',
        'kk',
        'km',
        'ko',
        'ku',
        'ky',
        'lo',
        'la',
        'lv',
        'lt',
        'lb',
        'mk',
        'mg',
        'ms',
        'ml',
        'mt',
        'mi',
        'mr',
        'mn',
        'my',
        'ne',
        'no',
        'ps',
        'fa',
        'pl',
        'pt',
        'pa',
        'ro',
        'ru',
        'sm',
        'gd',
        'sr',
        'st',
        'sn',
        'sd',
        'si',
        'sk',
        'sl',
        'so',
        'es',
        'su',
        'sw',
        'sv',
        'tg',
        'ta',
        'te',
        'th',
        'tr',
        'uk',
        'ur',
        'uz',
        'vi',
        'cy',
        'xh',
        'yi',
        'yo',
        'zu'
      ],
      validator: (String value) {
        //if (value == null || value.isEmpty) return 'Please select your gender';
        return null;
      },
      onSaved: (value) => userCopy.language = value,
      onChanged: (value) {
        changing = true;
        setState(() {
          userCopy.language = value;
          user.language = value;
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
      autovalidate: autoValidate,
      validator: (value) {
        if (value == null || value.isEmpty) return 'User name is required.';
        return null;
      },
      onSaved: (value) => userCopy.username = value,
      onChanged: (value) {
        setState(() {
          changing = true;
          userCopy.username = value;
          user.username = value;
        });
      },
    );
  }

  CardSettingsText _buildCardSettingsText_City() {
    return CardSettingsText(
      label: 'City',
      //hintText: 'User Name',
      initialValue: userCopy.city,
      autovalidate: autoValidate,
      onSaved: (value) => userCopy.city = value,
      onChanged: (value) {
        setState(() {
          changing = true;
          userCopy.city = value;
          user.city = value;
        });
      },
    );
  }
}
