class Account {
  final int idAccount;
  final String name;
  final String payment;
  final String password;
  final String bank;

  Account({required this.idAccount,
  required this.name,
  required this.payment,
  required this.password,
  required this.bank});
}

class Profile {
  final int idUser;
  final int idAccount;
  final String letter;
  final String user;
  final String payment;
  final String amount;
  final String phone;
  final String pin;
  final String status;
  final String genre;

  Profile(
      {required this.idUser,
      required this.idAccount,
      required this.letter,
      required this.user,
      required this.payment,
      required this.amount,
      required this.phone,
      required this.pin,
      required this.status,
      required this.genre});
}
