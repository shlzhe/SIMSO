import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service-locator.dart';
import '../model/entities/thought-model.dart';
import '../model/services/idictionary-service.dart';
import '../view/my-thoughts-page.dart';
import '../view/add-thought-page.dart';
import '../view/edit-thought-page.dart';
import '../view/mydialog.dart';

class MyThoughtsController {
  MyThoughtsPageState state;
  List<Thought> myThoughtsList;
  IDictionaryService _dictionaryService = locator<IDictionaryService>();

  MyThoughtsController(this.state);

  void addThought() {
    Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => AddThoughtPage(state.user),
        ));
  }

  void onTapThought(List<Thought> myThoughtsList, int index) async {
    MyDialog.showProgressBar(state.context);

    List<String> myKeywords = await _dictionaryService.getMyKeywords(
        myThoughtsList[index].thoughtId, null, null);

    await Navigator.push(
        state.context,
        MaterialPageRoute(
          builder: (context) => EditThoughtPage(
            state.user,
            myThoughtsList[index],
            myKeywords,
          ),
        ));
    Navigator.pop(state.context);
  }
}
