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
    this.templateType = 'business',
    this.socialLogins = const [],
  });

  final String validationMode;
  final String templateType;
  final List<String> socialLogins;

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isMedical = widget.templateType == 'healthcare';
    final primaryColor = colorScheme.primary;
    final labelSize = isMedical ? 15.0 : 13.0;
    final textSize = isMedical ? 16.0 : 14.0;

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
                color: colorScheme.secondary.withOpacity(0.5),
              );
            } else if (isPasswordField) {
              suffixIcon = IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  size: 18,
                  color: primaryColor.withAlpha(150),
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible[name] = !showPassword;
                  });
                },
              );
            }

            return Padding(
              padding: EdgeInsets.only(bottom: isMedical ? 24.0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: labelSize,
                          color: isMedical
                              ? (colorScheme.onSurface)
                              : theme.textTheme.bodyMedium?.color?.withAlpha(
                                  200,
                                ),
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
                    autovalidateMode: _getAutovalidateMode(
                      widget.validationMode,
                    ),
                    keyboardType: _getKeyboardType(type),
                    style: TextStyle(
                      fontSize: textSize,
                      color: isMedical
                          ? colorScheme.onSurface
                          : theme.textTheme.bodyLarge?.color,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(
                        color: isMedical
                            ? Colors.grey.withAlpha(150)
                            : theme.textTheme.bodySmall?.color?.withAlpha(100),
                        fontSize: labelSize,
                      ),
                      prefixIcon: IntrinsicHeight(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(width: 16),
                            Icon(
                              prefixIcon,
                              color: primaryColor.withAlpha(180),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            VerticalDivider(
                              color: isMedical
                                  ? primaryColor.withAlpha(50)
                                  : colorScheme.onSurface.withAlpha(30),
                              thickness: 1,
                              indent: 12,
                              endIndent: 12,
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      filled: true,
                      fillColor: isMedical
                          ? Colors.white.withOpacity(0.9)
                          : colorScheme.onSurface.withAlpha(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          isMedical ? 15 : 12,
                        ),
                        borderSide: BorderSide(
                          color: isMedical
                              ? primaryColor.withAlpha(80)
                              : colorScheme.onSurface.withAlpha(30),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          isMedical ? 15 : 12,
                        ),
                        borderSide: BorderSide(
                          color: isMedical
                              ? primaryColor.withAlpha(80)
                              : colorScheme.onSurface.withAlpha(30),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          isMedical ? 15 : 12,
                        ),
                        borderSide: BorderSide(color: primaryColor, width: 2),
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
                  primaryColor: primaryColor,
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
                    shadowColor: primaryColor.withAlpha(100),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: primaryColor,
                    foregroundColor: colorScheme.onPrimary,
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
          if (_isLogin) _buildSocialSection(colorScheme, isMedical),
        ],
      ),
    );
  }

  bool get _isLogin =>
      widget.submitLabel.toLowerCase().contains('login') ||
      widget.submitLabel.toLowerCase().contains('sign in');

  Widget _buildSocialSection(ColorScheme colorScheme, bool isMedical) {
    if (widget.socialLogins.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: 32),
        // Divider
        Row(
          children: [
            Expanded(
              child: Divider(color: colorScheme.onSurface.withOpacity(0.1)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "OR CONTINUE WITH",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: colorScheme.onSurface.withOpacity(0.4),
                ),
              ),
            ),
            Expanded(
              child: Divider(color: colorScheme.onSurface.withOpacity(0.1)),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // Social Buttons Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.socialLogins.map((provider) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildSocialIconContainer(
                provider,
                colorScheme,
                isMedical,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSocialIconContainer(
    String provider,
    ColorScheme colorScheme,
    bool isMedical,
  ) {
    IconData icon;
    switch (provider.toLowerCase()) {
      case 'google':
        icon = Icons.g_mobiledata;
        break;
      case 'apple':
        icon = Icons.apple;
        break;
      case 'facebook':
        icon = Icons.facebook;
        break;
      default:
        icon = Icons.login;
    }

    return InkWell(
      onTap: () {
        // Social login simulation
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Connecting to $provider...')));
      },
      borderRadius: BorderRadius.circular(isMedical ? 15 : 12),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isMedical
              ? Colors.white.withOpacity(0.4)
              : colorScheme.onSurface.withAlpha(10),
          borderRadius: BorderRadius.circular(isMedical ? 15 : 12),
          border: Border.all(
            color: colorScheme.onSurface.withOpacity(0.08),
            width: 1.5,
          ),
          boxShadow: isMedical
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            size: 32,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
