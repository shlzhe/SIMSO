import '../view/search-page.dart';
import 'package:flutter/material.dart';
import '../model/services/idictionary-service.dart';
import '../view/search-results-page.dart';
import '../service-locator.dart';

class SearchPageController {
  SearchPageState state;
  String searchTerm;
  SearchPageController(this.state);
  IDictionaryService dictionaryService = locator<IDictionaryService>();

  String validateSearchTerms(String searchTerm) {
    if (searchTerm == null || searchTerm.length == 0) {
      return 'Enter Text ';
    } else {
      dictionaryService.searchTermRetrieval(searchTerm).then((value) => {
            state.thoughtSet = value,
          });

      if (state.thoughtSet.isEmpty) {
        return "No results found";
      } else {
        return null;
      }
    }
  }

  void search() async {
    if (!state.formKey.currentState.validate()) {

      return;
    }
    state.formKey.currentState.save();

    state.thoughtSet.forEach((thought) => {state.thoughtList.add(thought)});

    Navigator.push(
        state.context,
        MaterialPageRoute(
            builder: (context) =>
                SearchResultsPage(state.user, state.thoughtList)));
    
  }
}