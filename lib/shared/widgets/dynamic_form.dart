import 'package:flutter/material.dart';
import '../../templates/business/widgets/business_widgets.dart';

class DynamicForm extends StatefulWidget {
  final List<dynamic> fields;
  final String submitLabel;
  final VoidCallback onSubmit;
  final bool isLiquidButton;

  const DynamicForm({
    super.key,
    required this.fields,
    required this.onSubmit,
    this.submitLabel = 'Submit',
    this.isLiquidButton = false,
    this.validationMode = 'onUserInteraction',
  });

  final String validationMode;

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, bool> _isPasswordVisible = {};

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      final name = field['name'] as String;
      final type = field['type'] as String? ?? 'text';
      _controllers[name] = TextEditingController();
      if (type == 'password') {
        _isPasswordVisible[name] = false;
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  FormFieldValidator<String> _buildValidator(Map<String, dynamic> field) {
    final validations = field['validations'] as List<dynamic>? ?? [];
    
    return (value) {
      for (var v in validations) {
        final rule = v['rule'] as String;
        final message = v['message'] as String;

        if (rule == 'required') {
          if (value == null || value.isEmpty) return message;
        } else if (rule == 'email') {
          if (value != null && value.isNotEmpty) {
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value)) return message;
          }
        } else if (rule == 'min_length') {
          final length = v['value'] as int;
          if (value != null && value.length < length) return message;
        } else if (rule == 'max_length') {
          final length = v['value'] as int;
          if (value != null && value.length > length) return message;
        } else if (rule == 'match') {
          final targetField = v['field'] as String;
          final targetValue = _controllers[targetField]?.text;
          if (value != targetValue) return message;
        }
      }
      return null;
    };
  }

  TextInputType _getKeyboardType(String type) {
    switch (type) {
      case 'email':
        return TextInputType.emailAddress;
      case 'number':
        return TextInputType.number;
      case 'phone':
        return TextInputType.phone;
      case 'password':
        return TextInputType.visiblePassword;
      default:
        return TextInputType.text;
    }
  }

  IconData _getPrefixIcon(String type) {
    switch (type) {
      case 'email':
        return Icons.email_outlined;
      case 'password':
        return Icons.lock_outline;
      case 'text':
      default:
        if (type.contains('name')) return Icons.person_outline;
        return Icons.edit_outlined;
    }
  }

  AutovalidateMode _getAutovalidateMode(String mode) {
    switch (mode) {
      case 'always':
        return AutovalidateMode.always;
      case 'disabled':
        return AutovalidateMode.disabled;
      case 'onUserInteraction':
      default:
        return AutovalidateMode.onUserInteraction;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...widget.fields.where((f) => f['isVisible'] ?? true).map((field) {
            final name = field['name'] as String;
            final label = field['label'] as String;
            final hint = field['hint'] as String?;
            final type = field['type'] as String? ?? 'text';
            final isReadOnly = field['isReadOnly'] as bool? ?? false;
            final isPasswordField = type == 'password';
            
            // Password visibility state
            final bool showPassword = _isPasswordVisible[name] ?? false;
            final bool obscureText = isPasswordField && !showPassword;
            
            final prefixIcon = _getPrefixIcon(type);

            // Suffix icon logic
            Widget? suffixIcon;
            if (isReadOnly) {
              suffixIcon = Icon(
                Icons.lock_outline,
                size: 18,
                color: Colors.cyanAccent.withOpacity(0.5),
              );
            } else if (isPasswordField) {
              suffixIcon = IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  size: 18,
                  color: Colors.cyanAccent.withAlpha(150),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible[name] = !showPassword;
                  });
                },
              );
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withAlpha(200),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _controllers[name],
                    obscureText: obscureText,
                    readOnly: isReadOnly,
                    autovalidateMode: _getAutovalidateMode(widget.validationMode),
                    keyboardType: _getKeyboardType(type),
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(
                        color: Theme.of(
                          context,
                        ).textTheme.bodySmall?.color?.withAlpha(100),
                        fontSize: 13,
                      ),
                      prefixIcon: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 16),
                            Icon(
                              prefixIcon,
                              color: Colors.cyanAccent.withAlpha(180),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            VerticalDivider(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(30),
                              thickness: 1,
                              indent: 12,
                              endIndent: 12,
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      filled: true,
                      fillColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(30),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(30),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      suffixIcon: suffixIcon,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 18,
                      ),
                    ),
                    validator: _buildValidator(field),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          widget.isLiquidButton
              ? BusinessLiquidButton(
                  label: widget.submitLabel,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit();
                    }
                  },
                  isLarge: true,
                )
              : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    elevation: 8,
                    shadowColor: Colors.cyanAccent.withAlpha(100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: const Color(0xFF1E285D),
                  ),
                  child: Text(
                    widget.submitLabel.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontSize: 16,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
