import 'dart:math';

String generateUniqueId(List<String> previousIds) {
  String id = '';
  final Random random = Random();
  const int idLength = 10;
  const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  print('entered');
  for (int i = 0; i < idLength; i++) {
    id += chars[random.nextInt(chars.length)];
    //print(id);
  }
  //print(previousIds.contains(id));
  int maxAttempts = 10;
  int attempts = 0;
  while (previousIds.contains(id) && attempts < maxAttempts) {
    id = '';
    for (int i = 0; i < idLength; i++) {
      id += chars[random.nextInt(chars.length)];
    }
    attempts++;
  }

  if (attempts == maxAttempts) {
    throw Exception('Unable to generate a unique ID.');
  }

  return id;
}
