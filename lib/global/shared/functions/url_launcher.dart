import 'package:url_launcher/url_launcher.dart';

void launchPhoneCall(String phoneNumber) async {
  final url = Uri.parse("tel:$phoneNumber");
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $phoneNumber';
  }
}
