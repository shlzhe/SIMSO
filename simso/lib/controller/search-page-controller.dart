import '../view/search-page.dart';
import 'package:flutter/material.dart';
import '../model/services/idictionary-service.dart';
import '../view/search-results-page.dart';
import '../model/entities/thought-model.dart';
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
      this.searchTerm = searchTerm;
      return null;
    }
  }

  void search()  {
    if (!state.formKey.currentState.validate()) {
      return;
    }
    state.formKey.currentState.save();
    Thought noThoughtsFound = Thought.empty();
      noThoughtsFound.text = 'No thoughts found associated with ' + searchTerm;
    dictionaryService.searchTermRetrieval(searchTerm).then((value) => {
          state.thoughtList = [],
          state.thoughtSet = {},
          value.isEmpty ?  state.thoughtSet = {} : state.thoughtSet = value,
          state.thoughtSet.forEach((thought) => state.thoughtList.add(thought)),
          Navigator.push(
              state.context,
              MaterialPageRoute(
                  builder: (context) =>
                      SearchResultsPage(state.user, state.thoughtList)))
                      
        });
  }
}
