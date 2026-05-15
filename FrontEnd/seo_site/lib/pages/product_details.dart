import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class ProductDetailsView extends StatelessComponent {
  final String productName;
  final String productType;
  final String productId;
  final String? parentProductId;
  final bool substituteRequested;

  const ProductDetailsView({
    super.key,
    required this.productName,
    required this.productType,
    required this.productId,
    this.parentProductId,
    this.substituteRequested = false,
  });

  @override
  Component build(BuildContext context) {
    return section([
      h1([Component.text('Product Details')]),
      div([
        p([Component.text('Product Name: $productName')]),
        p([Component.text('Product ID: $productId')]),
        p([Component.text('Product Type: $productType')]),
        if (parentProductId != null) p([Component.text('Parent Product ID: $parentProductId')]),
        if (substituteRequested) p([Component.text('Substitute Requested: Yes')]),
      ]),
    ]);
  }
}
