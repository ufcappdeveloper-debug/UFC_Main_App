import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/navigation/pages/bottom_nav_bar.dart';
import 'package:ufc_mobile/screens/feed_old/payment/utils/mada_payment_utils.dart';
import 'package:ufc_mobile/global/shared/functions/common_functions.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_snack_bar.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/common/common_utils.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';
import 'package:ufc_mobile/global/util/navigation/navigation.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MadaPaymentScreen extends StatefulWidget {
  const MadaPaymentScreen({
    super.key,
    required this.integrity,
    required this.checkoutId,
    this.languageLocale = 'en_US',
  });
  final String integrity;
  final String checkoutId;
  final String languageLocale;

  @override
  State<MadaPaymentScreen> createState() => _MadaPaymentScreenState();
}

class _MadaPaymentScreenState extends State<MadaPaymentScreen>
    with ScreenEngagementTracker {
  String? paymentError;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..clearCache()
      ..enableZoom(true)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (value) {
          CustomSnackBar.message(context, value.message);
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) async {
            await Future.delayed(Duration(milliseconds: 111));
            if (!mounted) return;
            if (url.contains('id')) pop(context, result: true);
          },
          onHttpError: (HttpResponseError error) {
            setErrorAndGo(error.toString());
          },
          onWebResourceError: (WebResourceError error) {
            if (error.url != null && error.url!.contains('error_message')) {
              setErrorAndGo(error.description);
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(
        MadaPaymentUtils.cardSessionHtml(
          integrity: widget.integrity,
          checkoutId: widget.checkoutId,
          language: widget.languageLocale,
        ),
      );
  }

  @override
  void dispose() {
    controller.loadRequest(Uri.parse('about:blank'));
    controller.setNavigationDelegate(NavigationDelegate());

    super.dispose();
  }

  void setErrorAndGo(String error) {
    safeSetState(this, () {
      paymentError = MadaPaymentUtils.extractRelevantErrorMessage(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !isStringEmpty(paymentError)
          ? null
          : AppBar(
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              leading: TextButton(
                child: SizedBox(
                  width: 150,
                  child: Icon(
                    Icons.cancel,
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {
                  pop(context);
                },
              ),
            ),
      body: !isStringEmpty(paymentError)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: CustomText(
                          text: "${'Error:'.tr()}\n$paymentError",
                          textAlign: TextAlign.center,
                        ),
                      ),
                      CustomButton(
                        width: 200,
                        title: 'Go Home'.tr(),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BottomBar(),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 420,
                  width: double.infinity,
                  child: WebViewWidget(
                    controller: controller,
                  ),
                ),
              ),
            ),
    );
  }
}
