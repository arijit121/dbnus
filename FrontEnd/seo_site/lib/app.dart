import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'pages/product_details.dart' deferred as product_details;
import 'pages/error_page.dart' deferred as error_route_widget;
import 'constants/routes.dart';

// The main component of your application.
//
// By using multi-page routing, this component will only be built on the server during pre-rendering and
// **not** executed on the client. Instead only the nested [Home] and [About] components will be mounted on the client.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    // This method is rerun every time the component is rebuilt.
    
    // Renders a <div class="main"> html element with children.
    return div(classes: 'main', [
      Router(routes: [
        Route.lazy(
          name: RouteName.productDetails,
          path: "/order-otc/:name-:id",
          load: product_details.loadLibrary,
          builder: (context, state) {
            if (state.params["name"]?.isNotEmpty == true) {
              return product_details.ProductDetailsView(
                  key: ValueKey(state.params["id"] ?? ""),
                  productName: state.params["name"] ?? "",
                  productType: "O",
                  productId: state.params["id"] ?? "",
                  parentProductId: state.queryParams["parent_product_id"]);
            }
            return error_route_widget.ErrorRouteWidget();
          },
        ),
        Route.lazy(
          name: RouteName.medDetails,
          path: "/order-medicine/:name-:id",
          load: product_details.loadLibrary,
          builder: (context, state) {
            if (state.params["name"]?.isNotEmpty == true) {
              return product_details.ProductDetailsView(
                key: ValueKey(state.params["id"] ?? ""),
                productName: state.params["name"] ?? "",
                productType: "P",
                productId: state.params["id"] ?? "",
                substituteRequested: state.queryParams["substitute_requested"] == "1",
                parentProductId: state.queryParams["parent_product_id"],
              );
            }
            return error_route_widget.ErrorRouteWidget();
          },
        ),
      ]),
    ]);
  }

  // Defines the CSS styles for this component.
  //
  // By using the @css annotation, these will be rendered automatically to CSS and included in your page.
  // Must be a variable or getter of type [List<StyleRule>].
  @css
  static List<StyleRule> get styles => [
    css('.main', [
      // The '&' refers to the parent selector of a nested style rules.
      css('&').styles(
        display: .flex,
        height: 100.vh,
        flexDirection: .column,
        flexWrap: .wrap,
      ),
      css('section').styles(
        display: .flex,
        flexDirection: .column,
        justifyContent: .center,
        alignItems: .center,
        flex: Flex(grow: 1),
      ),
    ]),
  ];
}
