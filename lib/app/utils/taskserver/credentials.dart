class Credentials {
  const Credentials({
    required this.org,
    required this.user,
    required this.key,
  });

  factory Credentials.fromString(String credentials) => Credentials(
        org: credentials.split('/')[0],
        user: credentials.split('/')[1],
        key: credentials.split('/')[2],
      );

  final String org;
  final String user;
  final String key;
}
