/// Parses fullname (username#1234) and returns
/// [true, username, discriminator] if the input is valid and
/// [false, '', ''] otherwise
List<Object> parseFullDiscordName(String fullname) {
  if (fullname.isEmpty || fullname.length < 6) return [false, '', ''];
  final hashIdx = fullname.indexOf('#');
  if (hashIdx <= 0 || fullname.lastIndexOf('#') != hashIdx) {
    return [false, '', ''];
  }
  final parts = fullname.split('#');
  int? discriminator = int.tryParse(parts[1]);
  if (discriminator == null || discriminator > 9999 || parts[1].length != 4) {
    return [false, '', ''];
  }
  return [true, parts[0], parts[1]];
}
