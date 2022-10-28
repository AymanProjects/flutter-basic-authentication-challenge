import 'package:basic_authentication_flutter_challenge/injection.dart';
import 'package:basic_authentication_flutter_challenge/src/data/exceptions/http_exception.dart';
import 'package:basic_authentication_flutter_challenge/src/data/models/user.dart';
import 'package:basic_authentication_flutter_challenge/src/data/repositories/users_repository.dart';
import 'package:basic_authentication_flutter_challenge/src/presentation/views/teammates/teammates_view.dart';
import 'package:basic_authentication_flutter_challenge/src/services/app_router.dart';
import 'package:basic_authentication_flutter_challenge/src/services/auth_service.dart';
import 'package:basic_authentication_flutter_challenge/src/services/current_auth_user.dart';
import 'package:basic_authentication_flutter_challenge/src/services/notifier.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {
  bool isLoading = false;
  User? currentUser;

  HomeViewModel() {
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    _setLoading(true);
    final usersRepo = locator<UsersRepository>();
    try {
      final currentUserId = await locator<CurrenAuthtUser>().getLocalUserId();
      currentUser = await usersRepo.find(currentUserId);
    } on HttpException catch (e) {
      locator<Notifier>().show(e.message);
    } catch (e) {
      locator<Notifier>().show('Couldn\'t get your details: ${e.toString()}');
    }
    _setLoading(false);
  }

  void onTeammatesButtonPressed() async {
    locator<AppRouter>().open(const TeammatesView());
  }

  void onLogoutButtonPressed() {
    locator<AuthService>().logout();
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
