import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ufc_mobile/global/extensions/app_font_family.dart';
import 'package:ufc_mobile/global/shared/constants/constants.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_button.dart';
import 'package:ufc_mobile/global/shared/widgets/custom_widgets/custom_text.dart';
import 'package:ufc_mobile/screens/farm/presentation/widgets/farm_text_field.dart';
import 'package:ufc_mobile/screens/pet_veterinary/components/extensions/pet_veterinary_colors.dart';

class QuantitySelector extends StatefulWidget {
  final int stock;
  final ValueChanged<int> onSelected;
  final int? initialQuantity;
  final bool isWide;

  const QuantitySelector({
    super.key,
    required this.stock,
    required this.onSelected,
    required this.isWide,
    this.initialQuantity,
  });

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int? selectedQty;

  /// Start with presets
  final List<int> presetValues = [1, 5, 10, 30, 50, 80, 100, 120];

  /// Keep a mutable list so we can add custom qtys
  late List<int> qtyValues;

  @override
  void initState() {
    super.initState();
    qtyValues = List.from(presetValues);
    selectedQty = widget.initialQuantity ?? (widget.stock >= 1 ? 1 : null);

    // Notify parent if initial quantity exists
    if (selectedQty != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSelected(selectedQty!);
        setState(() {});
      });
    }
  }

  bool get isEnglish =>
      Localizations.localeOf(context).languageCode.toLowerCase() == "en";

  String getCustomizeText() => isEnglish ? 'Customize' : 'تخصيص';
  String getEnterBagCountText() =>
      isEnglish ? 'Enter bag count' : 'أدخل عدد الأكياس';
  String getValueMustBeLessThanText(int stock) => isEnglish
      ? 'Value must be less than $stock'
      : 'القيمة يجب أن تكون أقل من $stock';
  String getSelectText() => isEnglish ? 'Select' : 'اختيار';

  @override
  Widget build(BuildContext context) {
    if (widget.stock <= 0) {
      return Padding(
          padding: EdgeInsets.only(top: 18, bottom: 24),
          child: Center(
            child: CustomText(
              text: "No stock is available",
              fontSize: widget.isWide ? 16 : 14,
              fontWeight: FontWeight.w300,
              color: Colors.red,
            ),
          ));
    }
    // Filter values based on stock
    final availableValues = qtyValues.where((v) => v <= widget.stock).toList();

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ...availableValues.map(
          (qty) => ChoiceChip(
            label: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: "$qty",
                  fontSize: widget.isWide ? 15 : 14,
                ),
                CustomText(
                  text: qty > 1 ? 'Bags' : 'Bag',
                  color: selectedQty == qty
                      ? Colors.black
                      : PetVeterinaryColors.newPetLightGray,
                  fontSize: widget.isWide ? 15 : 14,
                ),
              ],
            ),
            labelPadding: const EdgeInsets.all(8), // padding 10
            selected: selectedQty == qty,
            backgroundColor: Colors.white, // unselected
            selectedColor: PetVeterinaryColors.yellowBackground, // selected

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // radius 10
            ),
            onSelected: (_) {
              setState(() => selectedQty = qty);
              widget.onSelected(qty);
            },
          ),
        ),

        SizedBox(
          width: widget.isWide ? 8 : 4,
        ),

        // Customize option
        ChoiceChip(
          label: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: widget.isWide ? 18 : 16),
              SizedBox(
                height: 2,
              ),
              CustomText(
                text: 'Customize',
                fontSize: widget.isWide ? 17 : 15,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
          labelPadding: EdgeInsets.symmetric(
              horizontal: widget.isWide ? 12 : 8, vertical: 6),
          selected: false,
          backgroundColor: Colors.white,
          onSelected: (_) => _showCustomInput(context),
        ),
      ],
    );
  }

  void _showCustomInput(BuildContext context) {
    final controller = TextEditingController();
    bool isEnglish =
        Localizations.localeOf(context).languageCode.toLowerCase() == "en";

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top row: Close button, Title, empty space for alignment
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                  CustomText(
                    text: isEnglish ? 'Customize' : 'تخصيص',
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: isEnglish
                        ? AppFontsFamily.english
                        : AppFontsFamily.arabic,
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              // Text input for number
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: CustomTextFormField(
                  hintText: isEnglish ? 'Enter bag count' : 'أدخل عدد الأكياس',
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textDirection:
                      isEnglish ? TextDirection.ltr : TextDirection.rtl,
                  context: context,
                ),
              ),

              const SizedBox(height: 12),

              CustomButton(
                  height: 50,
                  // fontFamily: isArOrUr ? 'Graphik Arabic' : 'Kanit',
                  fontFamily: isEnglish
                      ? AppFontsFamily.english
                      : AppFontsFamily.arabic,
                  width: MediaQuery.of(context).size.width * 0.8,
                  title: isEnglish ? 'Save' : 'حفظ',
                  onTap: () {
                    final value = int.tryParse(controller.text);
                    if (value == null) {
                      Fluttertoast.showToast(
                          msg: 'Please enter number of bags'.tr());
                      return;
                    }
                    if (value > 0 && value <= widget.stock) {
                      setState(() {
                        selectedQty = value;

                        if (!qtyValues.contains(value)) {
                          qtyValues.add(value);
                          qtyValues.sort();
                        }
                      });

                      widget.onSelected(value);
                      Navigator.pop(ctx);
                    } else {
                      Fluttertoast.showToast(
                        msg: isEnglish
                            ? 'Value must be less than ${widget.stock}'
                            : 'القيمة يجب أن تكون أقل من ${widget.stock}',
                      );
                    }
                  }),

              kHeight40
            ],
          ),
        );
      },
    );
  }
}
