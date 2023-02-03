import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../config/const.dart';

class MailService {
  userMail(email, name, date, total, orderid) async {
    print('sending');
    String username = 'doabarestaurent@gmail.com';
    String password = Platform.isIOS ? 'kiwhnjowwvgzfysu' : 'khihyxvwpwybztby';
    String domainSmtp = 'mail.domain.com'; //also use for gmail smtp
    final smtpServer = gmail(username, password);
    // final smtpSer = SmtpServer(domainSmtp,
    //     username: username, password: password, port: 587);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(email)
      ..subject = 'Order placed'
      ..text = 'DOABA INDIAN RESTAURANT.'
      ..html =
          '''<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 <h1>Hi $name,</h1>
<p>Thanks for using DOABA INDIAN RESTAURANT. Your order of Total \$$total on $date of OrderID $orderid</p>
<table class="attribute-list" width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td class="attribute-list-container">
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
          <td class="attribute-list-item"><strong>Amount Due:</strong> \$$total</td>
        </tr>
        <tr>
          <td class="attribute-list-item"><strong>Due By:</strong> $date</td>
        </tr>
        <tr>
          <td class="attribute-list-item"><strong>Order ID:</strong> $orderid</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<center>
  <img 
src="https://firebasestorage.googleapis.com/v0/b/doabaindianrestaurent.appspot.com/o/logo%2Flogo-web.png?alt=media&token=32047992-37d9-40e7-8100-b25b02790d69" alt="logo"style="height:148px;">
</center>

<!-- Action -->
<p>If you have any questions about this, simply reply to this email for help.</p>
<p>Cheers,
  <br>DOABA INDIAN RESTAURANT</p>
</html>''';

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

  adminMail(name, date, total, orderid) async {
    print('sending');
    String username = 'doabarestaurent@gmail.com';
    String password = Platform.isIOS ? 'kiwhnjowwvgzfysu' : 'khihyxvwpwybztby';
    String domainSmtp = 'mail.domain.com'; //also use for gmail smtp
    final smtpServer = gmail(username, password);
    // final smtpSer = SmtpServer(domainSmtp,
    //     username: username, password: password, port: 587);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(Const.adminMail)
      ..subject = 'New Order from : $name'
      ..text = 'DOABA INDIAN RESTAURANT.'
      ..html =
          '''<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 <h1>Hi </h1>
<p>New Order for DOABA INDIAN RESTAURANT. Your order of Total \$$total on $date of OrderID $orderid</p>
<table class="attribute-list" width="100%" cellpadding="0" cellspacing="0">
  <tr>
    <td class="attribute-list-container">
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
          <td class="attribute-list-item"><strong>Amount Due:</strong> \$$total</td>
        </tr>
        <tr>
          <td class="attribute-list-item"><strong>Due By:</strong> $date</td>
        </tr>
        <tr>
          <td class="attribute-list-item"><strong>Order ID:</strong> $orderid</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<center>
  <img 
src="https://firebasestorage.googleapis.com/v0/b/doabaindianrestaurent.appspot.com/o/logo%2Flogo-web.png?alt=media&token=32047992-37d9-40e7-8100-b25b02790d69" alt="logo"style="height:148px;">
</center>

<!-- Action -->
<p>If you have any questions about this, simply reply to this email for help.</p>
<p>Cheers,
  <br>DOABA INDIAN RESTAURANT</p>
</html>''';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent.${e.message}');
    }
  }
  devMail(name, email) async {
    String username = 'doabarestaurent@gmail.com';
    String password = Platform.isIOS ? 'kiwhnjowwvgzfysu' : 'khihyxvwpwybztby';
    String domainSmtp = 'mail.domain.com'; //also use for gmail smtp
    final smtpServer = gmail(username, password);
    // final smtpSer = SmtpServer(domainSmtp,
    //     username: username, password: password, port: 587);
    final message = Message()
      ..from = Address(username)
      ..recipients.add(Const.devMail)
      ..subject = 'Delete req from : $name'
      ..text = 'DOABA INDIAN RESTAURANT.'
      ..html =
          '''<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
 delete request from : $email''';
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: $sendReport');
    } on MailerException catch (e) {
      print('Message not sent.${e.message}');
    }
  }
}
