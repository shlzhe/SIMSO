import '../view/search-page.dart';
import '../model/services/idictionary-service.dart';
import '../model/entities/dictionary-word-model.dart';
import '../service-locator.dart';

class SearchPageController {
  SearchPageState state;  
  String searchTerm;
  SearchPageController(this.state);
  IDictionaryService dictionaryService = locator<IDictionaryService>();

  String validateText(String value) {
    if (value == null || value.length == 0) {
      return 'Enter Text ';
    }
    return null;
  }

  void saveText(String value) {
    print("saveText: "+ value);
    searchTerm = value;
  }


  void search() async {
    if (!state.formKey.currentState.validate()) {
      return;
    }
    state.formKey.currentState.save();

    //searchTerm(searchTerm) to retrieve all thoughts


    dictionaryService.searchTermRetrieval(searchTerm);
  }

}
