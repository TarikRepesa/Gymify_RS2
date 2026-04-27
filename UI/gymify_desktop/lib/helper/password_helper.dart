import 'dart:math';

class CredentialHelper {
  static final _rng = Random();

  static String _normalize(String s) {
    var x = s.trim().toLowerCase();

    x = x
        .replaceAll('š', 's')
        .replaceAll('đ', 'dj')
        .replaceAll('č', 'c')
        .replaceAll('ć', 'c')
        .replaceAll('ž', 'z');

    x = x.replaceAll(RegExp(r'[^a-z0-9]'), '');
    return x;
  }

  static String generateUsername({
    required String firstName,
    required String lastName,
    String special = '#',
  }) {
    final fn = _normalize(firstName);
    final ln = _normalize(lastName);

    if (fn.isEmpty || ln.isEmpty) return "";

    final upper = String.fromCharCode(65 + _rng.nextInt(26)); 
    final digit = _rng.nextInt(10); 

    return "$fn.$ln$special$upper$digit";
  }

  static String generatePassword({int length = 10}) {

    const lowers = 'abcdefghijkmnopqrstuvwxyz';
    const uppers = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    const digits = '23456789';
    const specials = '!@#\$%&*?';

    final all = lowers + uppers + digits + specials;

    final chars = <String>[
      lowers[_rng.nextInt(lowers.length)],
      uppers[_rng.nextInt(uppers.length)],
      digits[_rng.nextInt(digits.length)],
      specials[_rng.nextInt(specials.length)],
    ];

    while (chars.length < length) {
      chars.add(all[_rng.nextInt(all.length)]);
    }

    chars.shuffle(_rng);
    return chars.join();
  }
}
