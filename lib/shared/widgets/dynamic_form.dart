import 'package:flutter/material.dart';
import '../../templates/business/widgets/business_widgets.dart';

class DynamicForm extends StatefulWidget {
  final List<String> fields;
  final String submitLabel;
  final VoidCallback onSubmit;
  final Map<String, String> labels;
  final Map<String, String> hints;
  final bool isLiquidButton;

  const DynamicForm({
    super.key,
    required this.fields,
    required this.onSubmit,
    this.submitLabel = 'Submit',
    this.labels = const {},
    this.hints = const {},
    this.isLiquidButton = false,
  });

  @override
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      _controllers[field] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...widget.fields.map((field) {
            final isObscure = field.toLowerCase().contains('password');
            final isEmail = field.toLowerCase().contains('email');
            final isName = field.toLowerCase().contains('name');

            IconData prefixIcon = Icons.edit_outlined;
            if (isObscure) prefixIcon = Icons.lock_outline;
            if (isEmail) prefixIcon = Icons.email_outlined;
            if (isName) prefixIcon = Icons.person_outline;

            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.labels[field] ?? field,
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
                    controller: _controllers[field],
                    obscureText: isObscure,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hints[field],
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 18,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
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
