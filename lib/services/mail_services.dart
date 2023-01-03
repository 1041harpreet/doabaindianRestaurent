import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class MailService{
  userMail(email,name,date,total,orderid) async {
    print('sending');
    String username = '1041harpreet@gmail.com';
    String password = 'ualpmmclbwwazchx';
    String domainSmtp = 'mail.domain.com'; //also use for gmail smtp
    final smtpServer = gmail(username, password);
    // final smtpSer = SmtpServer(domainSmtp,
    //     username: username, password: password, port: 587);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(email)
    // ..ccRecipients.addAll([email])
    // ..bccRecipients.add(const Address('bccAddress@example.com'))
      ..subject = 'Order placed $name'
      ..text = 'DOABA INDIAN RESTAURANT.'
      ..html = "<h1>$name</h1>\n"
          "<p>Your order payment of $total on ${date}is successfully done.</p>\n"
          "<p>Your Order ID is ${orderid}</p>\n"

    ;
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent.${e.message}');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
  adminMail(name,date,total,orderid) async {
    print('sending');
    String username = '1041harpreet@gmail.com';
    String password = 'ualpmmclbwwazchx';
    String domainSmtp = 'mail.domain.com'; //also use for gmail smtp
    final smtpServer = gmail(username, password);
    // final smtpSer = SmtpServer(domainSmtp,
    //     username: username, password: password, port: 587);
    final message = Message()
      ..from = Address(username)
      ..recipients.add('12001033harpreeta2@gmail.com')

      ..subject = 'New Order from : $name'
      ..text = 'DOABA INDIAN RESTAURANT.'
      ..html = "<h1>$name</h1>\n"
          "<p>New order payment of $total on ${date}is successfully done.</p>\n"
          "<p>Order ID is ${orderid}</p>\n"

    ;
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent.${e.message}');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

}