import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/global/util/community/html_widget.dart';

class RuleItem extends StatelessWidget {
  final String text1;
  final String text2;
  const RuleItem({super.key, required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: text1,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        kHeight15,
        HtmlWidget(
          text2,
          renderMode: RenderMode.column,
          customWidgetBuilder: CustomHtmlHandler.customWidgetBuilderHtml,
          textStyle: const TextStyle(fontSize: 14),
          customStylesBuilder: CustomHtmlHandler.customStyleBuilderForHtml,
          onTapUrl: CustomHtmlHandler.ontapHtmlUrl,
        ),
      ],
    );
  }
}
