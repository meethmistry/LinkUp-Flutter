
import 'package:flutter/material.dart';
import 'package:linkup/Theme/app.theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final int? maxLines;
  final TextInputType keyboardType;
  final String? pattern; // Add a pattern parameter
  final String? Function(String?)
      validator; // Update the type to handle validation

  CustomTextFormField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    this.pattern, // Make pattern optional
    required this.validator,
  });

  final ThemeColors _themeColors = ThemeColors();
  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    if (pattern != null) {
      final regex = RegExp(pattern!);
      if (!regex.hasMatch(value)) {
        return 'Invalid input';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      cursorColor: _themeColors.blueColor,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          prefixIcon,
          color: _themeColors.iconColor(context),
        ),
        floatingLabelStyle: TextStyle(color: _themeColors.blueColor),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _themeColors.blueColor),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) =>
          _validateField(value), // Use the internal validation
    );
  }
}

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onClick;

  CustomButton({
    super.key,
    required this.buttonText,
    required this.onClick,
  });

  final ThemeColors _themeColors = ThemeColors();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
        decoration: BoxDecoration(
          color: _themeColors.blueColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 7),
              const Icon(
                Icons.arrow_right_alt,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// for profile screen

class EditableTextFormField extends StatefulWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final int? maxLines;
  final TextInputType keyboardType;
  final String? pattern;
  final String? Function(String?) validator;

  const EditableTextFormField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    this.pattern,
    required this.validator,
  });

  @override
  _EditableTextFormFieldState createState() => _EditableTextFormFieldState();
}

class _EditableTextFormFieldState extends State<EditableTextFormField> {
  bool _isEditing = false;
  late FocusNode _focusNode;
  final ThemeColors _themeColors = ThemeColors();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
    });
    _focusNode.requestFocus();
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      widget.controller.text = ''; // Clear the field or reset to initial value
    });
    _focusNode.unfocus();
  }

  void _saveEditing() {
    setState(() {
      _isEditing = false;
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            cursorColor: _themeColors.blueColor,
            maxLines: widget.maxLines ?? 1,
            keyboardType: widget.keyboardType,
            readOnly: !_isEditing,
            decoration: InputDecoration(
              labelText: widget.labelText,
              prefixIcon: Icon(
                widget.prefixIcon,
                color: _themeColors.blueColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isEditing ? Icons.save : Icons.edit,
                  color: _themeColors.blueColor,
                ),
                onPressed: _isEditing ? _cancelEditing : _startEditing,
              ),
              floatingLabelStyle: TextStyle(color: _themeColors.blueColor),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: _themeColors.blueColor),
              ),
            ),
            validator: widget.validator,
          ),
          if (_isEditing)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _cancelEditing,
                  child: Text('Cancel', style: TextStyle(color: _themeColors.blueColor),),
                ),
                TextButton(
                  onPressed: _saveEditing,
                  child: Text('Save', style: TextStyle(color: _themeColors.blueColor),),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
