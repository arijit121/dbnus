import 'package:material_ui/material_ui.dart';

import 'package:dbnus/shared/constants/color_const.dart';
import 'package:dbnus/shared/extensions/spacing.dart';
import 'package:dbnus/shared/extensions/logger_extension.dart';
import 'package:dbnus/shared/ui/molecules/dropdowns/custom_dropdown.dart';
import 'package:dbnus/shared/ui/atoms/inputs/custom_text_formfield.dart';

class FormsSection extends StatelessWidget {
  const FormsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorConst.cardBg,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTextFormField(fieldHeight: 200),
          16.ph,
          const CustomTextFormField(),
          16.ph,
          const CustomTextFormField(maxLines: 1),
          16.ph,
          CustomDropdownMenuFormField<String>(
              hintText: "Please choose val",
              suffix: const Icon(Icons.keyboard_arrow_down_rounded),
              onChanged: (value) {
                AppLog.d(value);
              },
              items: List.generate(
                  10,
                  (index) => CustomDropDownModel<String>(
                      value: "test$index", title: "test$index"))),
          16.ph,
          CustomMenuAnchor<String>(
            onPressed: (value) {
              AppLog.d(value);
            },
            items: List.generate(
                10,
                (index) => CustomDropDownModel<String>(
                    value: "test$index", title: "test$index")),
            child: const Icon(
              Icons.zoom_out_rounded,
              color: Colors.amber,
            ),
          ),
          16.ph,
          CustomAutocompleteWidget<String>(
            debouncer: Duration(seconds: 1, milliseconds: 500),
            displayStringForOption: (o) => o,
            fieldViewBuilder: (ctx, ctrl, focusNode, onSubmit) => TextField(
              controller: ctrl,
              focusNode: focusNode,
              decoration: const InputDecoration(labelText: 'Search...'),
              onEditingComplete: onSubmit,
            ),
            optionsBuilder: (query) async {
              // Replace with your real API / local filter

              await Future.delayed(const Duration(milliseconds: 200));
              AppLog.i(query, tag: "Check Debouncer");
              return query.text.trim().isNotEmpty
                  ? ([
                      "apple",
                      "banana",
                      "cherry",
                      "date",
                      "elderberry",
                      "fig",
                      "grape",
                      "honeydew",
                      "kiwi",
                      "lemon",
                      "mango",
                      "nectarine",
                      "orange",
                      "papaya",
                      "quince",
                      "raspberry",
                      "strawberry",
                      "tangerine",
                      "ugli_fruit",
                      "vanilla_bean",
                      "watermelon",
                      "xigua",
                      "yuzu",
                      "zucchini",
                      "apricot"
                    ]
                      .where((s) => s.contains(query.text.trim().toLowerCase()))
                      .toList())
                  : <String>[];
            },
            optionsViewBuilder: (ctx, onSelected, options) => Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (_, i) => ListTile(
                      title: Text(options.elementAt(i)),
                      onTap: () => onSelected(options.elementAt(i)),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
