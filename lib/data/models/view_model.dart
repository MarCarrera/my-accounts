class Account {
  final int idAccount;
  final String name;
  final String payment;
  final String password;
  final String bank;

  Account(
      {required this.idAccount,
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

class Pagos {
  final int idPayment;
  final int idUser;
  final int idAccount;
  final String paymentDate;
  final String status;
  final String amount;
  final String userName;

  Pagos({
    required this.idPayment,
    required this.idUser,
    required this.idAccount,
    required this.paymentDate,
    required this.status,
    required this.amount,
    required this.userName,
  });
}

class TotalPago {
  final int idAccount;
  final int totalPagado;
  final String month1;
  final String month2;
  final int mensualidad;
  final int ganancia;

  TotalPago(
      {required this.idAccount,
      required this.totalPagado,
      required this.month1,
      required this.month2,
      required this.mensualidad,
      required this.ganancia});
}

class InfoUser {
  final String account;
  final String password;
  final String user;
  final String pin;

  InfoUser({required this.account, required this.password, required this.user, required this.pin});
}
