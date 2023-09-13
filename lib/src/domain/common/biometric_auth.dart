import 'package:beldex_wallet/l10n.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';


class BiometricAuth {
  Future<bool> isAuthenticated(AppLocalizations t) async {
    final _localAuth = LocalAuthentication();

    try {
     return await _localAuth.authenticate(
      localizedReason:  t.biometric_auth_reason,
      options: const AuthenticationOptions(
        biometricOnly: true,
        useErrorDialogs: true,
        stickyAuth: false
      ),
      );
      // return await _localAuth.authenticateWithBiometrics(
      //     localizedReason: S.current.biometric_auth_reason,
      //     useErrorDialogs: true,
      //     stickyAuth: false);
    } on PlatformException catch (e) {
      print(e);
    }

    return false;
  }
}
