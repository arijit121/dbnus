import '../utils/text_utils.dart';
import 'package:universal_html/html.dart' as html;

class SeoHandler {
  void setCanonicalLink() {
    String url = html.window.location.href;
    final head = html.document.head;
    final existingLink = head?.querySelector('link[rel="canonical"]');

    if (existingLink != null) {
      existingLink.attributes['href'] = url;
    } else {
      final canonicalLink = html.Element.tag('link');
      canonicalLink.setAttribute('rel', 'canonical');
      canonicalLink.setAttribute('href', url);
      head?.append(canonicalLink);
    }
  }

  void homeHooterSeo() {
    final document = html.document;
    final seoContainer = html.DivElement()..className = 'footerSeoCon';
    seoContainer.setInnerHtml(TextUtils.footer_msg_web,
        validator: html.NodeValidatorBuilder.common());
    if (document.querySelector('.footerSeoCon') == null) {
      document.body?.append(seoContainer);
    }
  }

  void removeFooterSeoContainer() {
    final element = html.document.querySelector('.footerSeoCon');
    if (element != null) {
      element.remove();
    }
  }
}
