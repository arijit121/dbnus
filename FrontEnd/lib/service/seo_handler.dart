
// import 'package:universal_html/html.dart' as html;

class SeoHandler {
  Future<void> setCanonicalLink() async {
/*    String url = html.window.location.href;
    final head = html.document.head;
    final existingLink = head?.querySelector('link[rel="canonical"]');

    if (existingLink != null) {
      existingLink.attributes['href'] = url;
    } else {
      final canonicalLink = html.Element.tag('link');
      canonicalLink.setAttribute('rel', 'canonical');
      canonicalLink.setAttribute('href', url);
      head?.append(canonicalLink);
    }*/
  }

  Future<void> homeHooterSeo() async {
/*    final document = html.document;
    final seoContainer = html.DivElement()..className = 'footerSeoCon';
    seoContainer.setInnerHtml(TextUtils.footer_msg_web,
        validator: html.NodeValidatorBuilder.common());
    if (document.querySelector('.footerSeoCon') == null) {
      document.body?.append(seoContainer);
    }*/
  }

  Future<void> removeFooterSeoContainer() async {
/*    final element = html.document.querySelector('.footerSeoCon');
    if (element != null) {
      element.remove();
    }*/
  }

/*  void injectSeoNodes({String? id, required List<html.Node> children}) {
    final resolvedContainerId = id ?? 'seo-node';

    final div = html.document.getElementById(resolvedContainerId) ??
        (html.DivElement()..id = resolvedContainerId);

    for (final node in children) {
      div.append(node);
    }
    html.document.body?.append(div);
  }*/

  void removeSeoNodes({String? id}) {
    // html.document.getElementById(id ?? 'seo-node')?.remove();
  }
}
