import '../utils/text_utils.dart';
import 'package:universal_html/html.dart' deferred as html;

class SeoHandler {
  Future<void> setCanonicalLink() async {
    await html.loadLibrary();
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

  Future<void> homeHooterSeo() async {
    await html.loadLibrary();
    final document = html.document;
    final seoContainer = html.DivElement()..className = 'footerSeoCon';
    seoContainer.setInnerHtml(TextUtils.footer_msg_web,
        validator: html.NodeValidatorBuilder.common());
    if (document.querySelector('.footerSeoCon') == null) {
      document.body?.append(seoContainer);
    }
  }

  Future<void> removeFooterSeoContainer() async {
    await html.loadLibrary();
    final element = html.document.querySelector('.footerSeoCon');
    if (element != null) {
      element.remove();
    }
  }
}
