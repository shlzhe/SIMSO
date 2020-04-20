import '../view/search-results-page.dart';
import '../model/services/idictionary-service.dart';
import '../model/entities/dictionary-word-model.dart';
import '../model/entities/thought-model.dart';
import '../model/entities/user-model.dart';
import '../view/profile-page.dart';
import '../service-locator.dart';

class SearchResultsPageController {
  SearchResultsPageState state;
  String searchTerm;
  SearchResultsPageController(this.state);

}
