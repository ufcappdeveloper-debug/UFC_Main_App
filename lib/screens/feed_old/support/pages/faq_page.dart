import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/feed_old/support/widgets/faq_expansion_list.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/mixin/screen_engagement_tracker.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> with ScreenEngagementTracker {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: const Color(0xffe5e5e5).withValues(alpha: 0.2),
        elevation: 8,
        title: CustomText(
          text: 'FAQ',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
        ),
      ),
      body: Theme(
        data: ThemeData(
          primaryColor: Colors.green,
          primarySwatch: Colors.green,
          dividerColor: Colors.transparent,
          listTileTheme: ListTileTheme.of(context).copyWith(
            dense: true,
          ),
        ),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 16,
                        color: const Color(0xFFe5e5e5).withValues(alpha: 0.7)),
                  ]),
              child: Column(
                children: faqData
                    .map(
                      (data) => FAQExpansionList(
                        heading: data["heading"],
                        description: data["description"],
                        descriptionChildren: data["description_children"],
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> oldFaqData = [
  {
    "heading": "Can I buy online from United Feeds website?",
    "description": null,
    "description_children": [
      CustomText(
          fontWeight: FontWeight.w300,
          text:
              "Yes you can buy most of our products will be shipped inside Saudi Arabia only can’t There is no minimum or maximum order value for online orders, but the available quantity is specified in the quantity list on the product page."),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsetsDirectional.only(start: 11),
        child: CustomText(
            fontWeight: FontWeight.w300,
            text:
                "1. Customer must create an account in Jarir.com\n2. Must have Credit card or SADAD account\n3. Shipping Address must be clear & correct. It is better to use (national address OR WASEL address)"),
      ),
    ],
  },
  {
    "heading": "What is the minimum and maximum purchase",
    "description":
        "There is no specific minimum or maximum purchase requirement for our products.",
    "description_children": null,
  },
  {
    "heading": "Are all products available online?",
    "description":
        "Not all products are available online. Please check the product listings for availability.",
    "description_children": null,
  },
  {
    "heading":
        "How can I know if the product is available online in United Feeds?",
    "description":
        "You can check the product listings on our website to see if a specific product is available for online purchase.",
    "description_children": null,
  },
];

List<Map<String, dynamic>> faqData = [
  {
    "heading": "What is the United Feeds Store?",
    "description":
        "It is an online store that offers products from the United Feeds Company, which are animal products imported from the best farms in the world, including various bulk grains such as barley, corn, soybean, and bran in all their forms.",
    "description_children": null,
  },
  {
    "heading": "What distinguishes United Store from its competitors?",
    "description":
        "It stands out by offering high-quality products at the best prices. Some of the key features of the store include: Meeting customer needs. Reducing cash transactions. Providing easy access to the customer database. Offering products imported from the best farms. and product information. Facilitating direct order tracking. Providing a cash-on-delivery service. Supporting all types of devices and multiple languages. Easy to use and navigate. Quick response and service.",
    "description_children": null,
  },
  {
    "heading": "How can I order from United Feeds Store?",
    "description": null,
    "description_children": [
      CustomText(
          fontWeight: FontWeight.w300,
          text:
              "You can place an order from United Feeds Store by following these steps:"),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsetsDirectional.only(start: 11),
        child: CustomText(
            fontWeight: FontWeight.w300,
            text:
                "1. Add the selected products to your shopping cart.\n2. After choosing the products, go to your shopping cart and click 'Proceed to Checkout' to complete the order.\n3. After confirming the order, you will receive a confirmation message with the order number on your mobile and the email registered with the order."),
      ),
    ],
  },
  {
    "heading": "What is the order number?",
    "description":
        "The order number is the number that is automatically generated upon completing the order and is used to track the order's status with customer service representatives or in the order status section.",
    "description_children": null,
  },
  {
    "heading": "Where can I find the order number?",
    "description":
        "After completing the order process, you will be automatically redirected to a page that contains your order number. You can also find it by checking the email sent from the website, which includes the details of your order. Additionally, you can review the order number and its details from your account.",
    "description_children": null,
  },
  {
    "heading": "What payment methods are available?",
    "description":
        "Payment on Delivery (Cash on Delivery): Available for our customers in all our branches in the Kingdom. In addition to payment through SADAD. Soon, payment methods using debit cards, Visa, MasterCard, Apple Pay, and Tamara will be available.",
    "description_children": null,
  },
  {
    "heading": "How long does it take to process an order?",
    "description":
        "Order processing takes 30 minutes for all our branches in the Kingdom of Saudi Arabia.",
    "description_children": null,
  },
  {
    "heading": "When are the products available?",
    "description":
        "There is no specific availability date for products. To track their availability, you can add the product to your favorites, and you will be notified as soon as the product becomes available, either through the website or the app.",
    "description_children": null,
  },
  {
    "heading": "I have an issue, can I contact you?",
    "description":
        "Yes, of course! You can contact us through customer service on the website or by emailing us at info@ufc.com.sa, or by calling our unified number at 920006839.",
    "description_children": null,
  },
  {
    "heading": "How can I track my order?",
    "description":
        "You can check the status of your order through our website or the app by logging into your account, going to 'My Orders,' selecting the order, and tracking its status.",
    "description_children": null,
  },
  {
    "heading": "Can I cancel the order?",
    "description": null,
    "description_children": [
      CustomText(
          fontWeight: FontWeight.w300,
          text: "1. If the order has not been processed:"),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsetsDirectional.only(start: 11),
        child: CustomText(
            fontWeight: FontWeight.w300,
            text:
                "- To cancel your order, please contact us at the unified number 920006839.\n- Our team may ask for the reason for cancellation so that we can serve you better in the future."),
      ),
      const SizedBox(height: 10),
      CustomText(
          fontWeight: FontWeight.w300,
          text: "2. If the order has been processed:"),
      const SizedBox(height: 10),
      Padding(
        padding: const EdgeInsetsDirectional.only(start: 11),
        child: CustomText(
            fontWeight: FontWeight.w300,
            text:
                "- Once the order is processed, we will not be able to cancel your order."),
      ),
    ],
  },
  {
    "heading": "Can I edit/delete/add a product?",
    "description":
        "Yes, you can edit, delete, or add a product unless the order has been processed. You can do this by contacting our customer service team during official working hours at the unified number: 920006839.",
    "description_children": null,
  },
  {
    "heading": "Can I edit my account information?",
    "description":
        "You can edit any of your account information (phone number, password, or email) through our website or app. Simply log in, go to 'My Account' > 'Profile,' click on the field you want to edit, enter the data, and then click 'Edit.'",
    "description_children": null,
  },
  {
    "heading": "I forgot my password, how can I recover it?",
    "description":
        "If you forget your password, please go to the login page on the website or app, then click on 'Forgot Password' and enter the recovery information or your mobile number.",
    "description_children": null,
  },
  {
    "heading": "What is Wallet Balance?",
    "description":
        "Wallet Balance is a specific amount of money that a customer can use entirely at any time during the purchasing process.",
    "description_children": null,
  },
  {
    "heading": "How can I use Wallet Balance?",
    "description":
        "Upon completing an order, the entire amount in the wallet is deducted immediately along with any remaining amount paid by the customer using one of the available payment methods.",
    "description_children": null,
  },
  {
    "heading": "If I delete my account, can I recover the balance?",
    "description":
        "You can recover the balance by contacting the customer service team via email or by calling the unified number: 920006839.",
    "description_children": null,
  },
];
