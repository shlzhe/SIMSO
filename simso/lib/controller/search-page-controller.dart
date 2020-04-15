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


  void save() async {
    if (!state.formKey.currentState.validate()) {
      return;
    }
    state.formKey.currentState.save();

    print("searchTerm: " + searchTerm);

  var searchWordList = searchTerm
          .replaceAll(new RegExp(r"[^\'\w\s]+"), '')
          .replaceAll(new RegExp(r'[ ]{2,}'), ' ')
          .split(' ')
          .toSet();

  var validatedWords = [];

  for (var word in searchWordList) {
      if(await dictionaryService.wordInDictionary(word)){
        validatedWords.add(word);
      }
  }

  print("searchWordList: ");
  for(var word in searchWordList){
    print(word);
  }

    print("validatedWords: ");
  for(var word in validatedWords){
    print(word);
  }


    

    

  }

}
