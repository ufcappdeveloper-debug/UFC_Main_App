import 'package:easy_localization/easy_localization.dart' as loc;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ufc_mobile/screens/farm/domain/services/farm_date_rules.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart' as intl;
import 'package:ufc_mobile/global/extensions/app_font_family.dart';

import '../../../../global/extensions/app_colors.dart';
import '../../../../global/shared/constants/constants.dart';
import '../charts/weight_chart.dart';
import 'custome_container.dart';

class FarmSearchField extends StatelessWidget {
  final String? hint;
  final String? iconSvg;
  final Function(String value) onSubmitted;

  const FarmSearchField(
      {super.key, this.hint, this.iconSvg, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomFarmContainer(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          onSubmitted: (value) => onSubmitted(value),
          decoration: InputDecoration(
            icon: SvgPicture.asset(iconSvg ?? 'assets/svg/global/search.svg'),
            hintText: hint ?? 'Search Livestock type, number, name, etc.'.tr(),
            hintStyle: TextStyle(
              color: Color(0xFFCFCFCF),
              fontWeight: FontWeight.w400,
              fontFamily:
                  (isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic),
              fontSize: 12,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
      {super.key,
      this.isMsg = false,
      this.isPhone = false,
      this.controller,
      required this.context,
      this.validator,
      this.hintText,
      this.keyboardType,
      this.suffixIcon,
      this.inputFormatters,
      this.readOnly = false,
      this.onTap,
      this.focusNode,
      this.onFieldSubmitted,
      this.textAlign = TextAlign.start,
      this.textDirection,
      this.hintStyle,
      this.fromLogin = false,
      this.maxLength,
      this.onCountryChange,
      this.maxLines,
      this.nodeAfter,
      this.obscureText = false});

  final bool isMsg;
  final bool isPhone;
  final bool fromLogin;
  final TextEditingController? controller;
  final BuildContext context;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final Function()? onTap;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final TextDirection? textDirection;
  final TextAlign textAlign;
  final TextStyle? hintStyle;
  final int? maxLength;
  final Function(String)? onCountryChange;
  final int? maxLines;
  final FocusNode? nodeAfter;
  final bool obscureText;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  String selectedCountryCode = '+966';
  String selectedFlagEmoji = '🇸🇦';
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // Keep the focused field well above the keyboard (and any button
      // floating on it).
      scrollPadding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
      obscureText: _obscureText,
      maxLength: widget.maxLength,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      controller: widget.controller,
      validator: widget.validator,
      maxLines: widget.isMsg ? 10 : widget.maxLines ?? 1,
      minLines: widget.isMsg ? 5 : widget.maxLines ?? 1,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      focusNode: widget.focusNode,
      onFieldSubmitted: widget.onFieldSubmitted,
      textDirection: widget.isPhone ? TextDirection.ltr : widget.textDirection,
      textAlign: widget.isPhone ? TextAlign.left : widget.textAlign,
      onEditingComplete: () {
        if (widget.nodeAfter != null) {
          return widget.nodeAfter!.requestFocus();
        }
        return FocusScope.of(context).requestFocus(FocusNode());
      },
      decoration: InputDecoration(
        counterText: '',
        suffixIcon: widget.isPhone
            ? Directionality(
                textDirection: TextDirection.ltr,
                child: _buildPhoneSuffix(),
              )
            : widget.obscureText // Only show toggle for password fields
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
        hintText:
            widget.fromLogin && widget.isPhone ? '5XXXXXXX' : widget.hintText,
        suffixIconConstraints: widget.isPhone && !widget.fromLogin
            ? const BoxConstraints(
                minHeight: 70,
                minWidth: 70,
              )
            : null,
        hintStyle: widget.hintStyle ??
            TextStyle(
              fontSize: 13,
              color: Colors.grey.shade300,
              fontFamily:
                  isEnglish ? AppFontsFamily.english : AppFontsFamily.arabic,
            ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColors.grey, width: 1),
        ),
      ),
    );
  }

  Widget _buildPhoneSuffix() {
    return PopupMenuButton<_Country>(
      elevation: 1,
      onSelected: (country) {
        if (widget.onCountryChange != null) {
          widget.onCountryChange!(country.code);
        }
        setState(() {
          selectedFlagEmoji = country.flag;
          selectedCountryCode = country.code;
        });
      },
      itemBuilder: (context) => [
        _buildPopupItem('🇸🇦', '+966'),
        // _buildPopupItem('🇦🇪', '+971'),
      ],
      child: Directionality(
          textDirection: TextDirection.ltr,
          child: CustomFarmContainer(
            needShadow: widget.fromLogin ? false : true,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedFlagEmoji,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: Colors.black54,
                ),
              ],
            ),
          )),
    );
  }

  PopupMenuItem<_Country> _buildPopupItem(String flag, String code) {
    return PopupMenuItem<_Country>(
      value: _Country(flag, code),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 8),
          Text(code),
        ],
      ),
    );
  }
}

class CustomDatePicker extends StatefulWidget {
  final Function(String date) onDateSelect;
  final TextEditingController controller;
  final bool needIcon;
  final String? hintText;
  final bool needFormat;

  /// Earliest selectable date, e.g. the animal's birth date.
  final DateTime? minimumDate;

  /// Latest selectable date. Defaults to today (Saudi time) because the API
  /// rejects future farm dates; pass [allowFuture] for forecast questions
  /// such as "Expected Calving Date".
  final DateTime? maximumDate;
  final bool allowFuture;

  /// Logical check (see FarmDateRules). A non-null message refuses the date
  /// and is shown under the field.
  final String? Function(DateTime date)? validateDate;

  const CustomDatePicker({
    super.key,
    required this.onDateSelect,
    required this.controller,
    this.needIcon = true,
    this.hintText,
    this.needFormat = true,
    this.minimumDate,
    this.maximumDate,
    this.allowFuture = false,
    this.validateDate,
  });

  /// "Today" as the farm API sees it (Saudi time, UTC+3).
  static DateTime saudiToday() => FarmDateRules.today();

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime selectedDate = DateTime.now();
  String? _error;

  DateTime get _min => widget.minimumDate ?? DateTime(1900);

  DateTime get _max {
    DateTime max;
    if (widget.maximumDate != null) {
      max = DateTime(widget.maximumDate!.year, widget.maximumDate!.month,
          widget.maximumDate!.day, 23, 59);
    } else if (widget.allowFuture) {
      max = DateTime(2100);
    } else {
      // End of today, so today itself stays selectable.
      max = CustomDatePicker.saudiToday()
          .add(const Duration(hours: 23, minutes: 59));
    }
    // Contradicting limits (bad data): keep the wheel usable; the
    // validator still refuses the date.
    return max.isBefore(_min) ? _min : max;
  }

  void _showCupertinoDatePicker(BuildContext context) {
    // Keep the wheel inside the allowed range.
    if (selectedDate.isBefore(_min)) selectedDate = _min;
    if (selectedDate.isAfter(_max)) selectedDate = _max;
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: SizedBox(
            height: 250,
            child: Column(
              children: [
                Expanded(
                  child: CupertinoTheme(
                    data: const CupertinoThemeData(
                        brightness: Brightness.light,
                        primaryColor: AppColors.farmColor),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: selectedDate,
                      minimumDate: _min,
                      maximumDate: _max,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => selectedDate = newDate);
                      },
                    ),
                  ),
                ),
                CustomOutlinedContainer(
                  margin: EdgeInsets.all(12),
                  fill: true,
                  title: 'Done',
                  onTap: () {
                    Navigator.pop(context);
                    final error = widget.validateDate?.call(selectedDate);
                    setState(() => _error = error);
                    if (error != null) return;
                    final formattedDate = intl.DateFormat(
                            widget.needFormat ? 'dd/MM/yyyy' : 'yyyy-MM-dd',
                            'en')
                        .format(selectedDate);

                    widget.controller.text = formattedDate;
                    widget.onDateSelect(formattedDate);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final field = CustomTextFormField(
      context: context,
      readOnly: true,
      controller: widget.controller,
      onTap: () => _showCupertinoDatePicker(context),
      hintText: widget.hintText ?? 'Date (ex. 01/02/2022)'.tr(),
      suffixIcon: widget.needIcon
          ? Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset('assets/svg/farm/date.svg'),
            )
          : null,
    );
    if (_error == null) return field;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        field,
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(_error!,
              style: const TextStyle(color: Colors.red, fontSize: 12)),
        ),
      ],
    );
  }
}

class _Country {
  final String flag;
  final String code;
  _Country(this.flag, this.code);
}
