import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomHtmlHandler {
  static StylesMap? customStyleBuilderForHtml(element) {
    final Map<String, String> styles = {};

    final style = element.attributes['class'];

    if (style != null) {
      bool hasIndent = style.contains('ql-indent-');
      List<String> textAlign = style.split('ql-align-');
      if (hasIndent) {
        List<String> txtIndent = style.split('ql-indent-');

        int indent = int.tryParse(txtIndent[1].trim()) ?? 0;
        if (indent == 1) {
          styles['padding-left'] = '5px';
        } else if (indent > 1) {
          styles['padding-left'] = '10px';
        }
      }
      if (textAlign[1].isNotEmpty) {
        styles['text-align'] = textAlign[1];
      } else {
        styles['text-align'] = "justify";
      }
    } else {
      styles['text-align'] = "justify";
    }

    return styles.isEmpty ? null : styles;
  }

  static Widget? customWidgetBuilderHtml(element) {
    if (element.localName == 'img') {
      final src = element.attributes['src'] ?? '';
      if (src.endsWith('.svg')) {
        return InlineCustomWidget(
          alignment: PlaceholderAlignment.middle,
          child: SvgPictureNetwork(src),
        );
      }
    } else if (element.localName == 'svg') {
      final svgString = element.outerHtml;
      return InlineCustomWidget(
        alignment: PlaceholderAlignment.middle,
        child: SvgPictureNetwork(svgString),
      );
    }
    return null;
  }

  static FutureOr<bool> ontapHtmlUrl(url) async {
    debugPrint('URL in html widget $url');
    return _launchURL(url);
  }

  static Future<bool> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
      return true;
    } else {
      return false;
    }
  }
}

class SvgPictureNetwork extends StatelessWidget {
  final String svgData;

  const SvgPictureNetwork(this.svgData, {super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.network(svgData);
  }
}
