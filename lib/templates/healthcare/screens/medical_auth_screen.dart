import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/auth_service.dart';
import '../../../shared/widgets/dynamic_form.dart';
import '../../../core/theme/template_theme_extension.dart';
import '../widgets/medical_widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicalAuthScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const MedicalAuthScreen({super.key, required this.data});

  @override
  ConsumerState<MedicalAuthScreen> createState() => _MedicalAuthScreenState();
}

class _MedicalAuthScreenState extends ConsumerState<MedicalAuthScreen> {
  bool _isLogin = true;
  bool _isLoading = false;

  void toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final templateColors = theme.extension<TemplateColors>();
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    final formData = _isLogin
        ? (widget.data['login_form'] ?? {})
        : (widget.data['signup_form'] ?? {});

    // Professional responsive dimensions
    final panelWidth = isMobile ? size.width * 0.95 : (size.width > 900 ? 600.0 : 560.0);
    // Use lower minHeights to prevent overflow on small screens while maintaining the hexagon look
    final panelMinHeight = isMobile ? 0.0 : (_isLogin ? 620.0 : 720.0);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  templateColors?.indicatorColor ??
                      colorScheme.secondary.withOpacity(0.5),
                  colorScheme.secondary,
                  colorScheme.primary,
                  templateColors?.brandAccent ?? colorScheme.primary,
                ],
              ),
            ),
          ),

          // Soft Animated Blobs
          ..._buildBackgroundBlobs(templateColors, colorScheme),

          // Centered Panel with ScrollView
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? 10.0 : 30.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top Avatar
                      const MedicalAvatarHexagon()
                          .animate()
                          .scale(duration: 600.ms, curve: Curves.easeOutBack)
                          .fadeIn(),

                      SizedBox(height: isMobile ? 8 : 20),

                      // Main Hexagonal Panel
                      MedicalHexagonalPanel(
                            width: panelWidth,
                            height: panelMinHeight,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 24 : 45,
                                vertical: isMobile ? 20 : 40, 
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: isMobile ? 30 : 40),
                                  Text(
                                        _isLogin ? "Sign In" : "Join Us",
                                        style: GoogleFonts.inter(
                                          color:
                                              templateColors?.brandAccent ??
                                              colorScheme.primary,
                                          fontSize: isMobile ? 28 : 34,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.5,
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(delay: 200.ms)
                                      .moveY(begin: 20, end: 0),

                                  SizedBox(height: isMobile ? 20 : 35),

                                    DynamicForm(
                                      fields: formData['fields'] ?? [],
                                      submitLabel:
                                          formData['submit_label'] ??
                                          (_isLogin ? 'Login' : 'Sign Up'),
                                      templateType: 'healthcare',
                                      socialLogins: List<String>.from(
                                        formData['social_logins'] ?? [],
                                      ),
                                      isLoading: _isLoading,
                                      onSubmit: (values) async {
                                        setState(() => _isLoading = true);
                                        try {
                                          final email = values['email'] ?? '';
                                          final password = values['password'] ?? '';
                                          
                                          if (_isLogin) {
                                            await ref.read(authServiceProvider).signIn(
                                                  email: email,
                                                  password: password,
                                                );
                                            if (mounted) context.go('/dashboard');
                                          } else {
                                            final name = values['name'];
                                            await ref.read(authServiceProvider).signUp(
                                                  email: email,
                                                  password: password,
                                                  name: name,
                                                );
                                            if (mounted) {
                                              toggleMode();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Registration successful! Please sign in.')),
                                              );
                                            }
                                          }
                                          }
                                        } on AuthException catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(e.message), backgroundColor: Colors.red),
                                            );
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('An unexpected error occurred'), backgroundColor: Colors.red),
                                            );
                                          }
                                        } finally {
                                          if (mounted) setState(() => _isLoading = false);
                                        }
                                      },
                                    ),

                                  const SizedBox(height: 15),

                                  // Bottom Links (only for login)
                                  if (_isLogin) ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              size: 14,
                                              color: colorScheme.onSurface
                                                  .withOpacity(0.9),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              "Remember me",
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "Forgot password?",
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: colorScheme.onSurface
                                                .withOpacity(0.8),
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                  ] else
                                    const SizedBox(height: 10),

                                  // Toggle Mode
                                  TextButton(
                                    onPressed: toggleMode,
                                    child: Text(
                                      _isLogin
                                          ? "Create an account"
                                          : "Back to Sign In",
                                      style: GoogleFonts.inter(
                                        color:
                                            templateColors?.brandAccent ??
                                            colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              ),
                            ),
                          )
                          .animate(key: ValueKey(_isLogin))
                          .fadeIn(duration: 400.ms)
                          .scale(
                            begin: const Offset(0.95, 0.95),
                            end: const Offset(1, 1),
                            curve: Curves.easeOut,
                          ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildBackgroundBlobs(
    TemplateColors? templateColors,
    ColorScheme colorScheme,
  ) {
    return [
      _buildBlob(
        Alignment.topLeft,
        300,
        (templateColors?.surfaceVariant ?? colorScheme.secondaryContainer)
            .withOpacity(0.4),
      ),
      _buildBlob(
        Alignment.bottomRight,
        400,
        (templateColors?.brandAccent ?? colorScheme.primary).withOpacity(0.2),
      ),
      _buildBlob(
        Alignment.centerLeft,
        250,
        (templateColors?.softOverlay ?? colorScheme.surfaceVariant).withOpacity(
          0.3,
        ),
      ),
    ];
  }

  Widget _buildBlob(Alignment alignment, double size, Color color) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child:
            Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .move(
                  begin: const Offset(-20, -20),
                  end: const Offset(20, 20),
                  duration: 5.seconds,
                  curve: Curves.easeInOut,
                ),
      ),
    );
  }
}
