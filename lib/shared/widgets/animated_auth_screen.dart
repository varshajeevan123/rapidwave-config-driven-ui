import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/services/auth_service.dart';
import '../../templates/template_factory.dart';
import 'dynamic_form.dart';
import '../../templates/business/widgets/business_widgets.dart';

class AnimatedAuthScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> data;

  const AnimatedAuthScreen({super.key, required this.data});

  @override
  ConsumerState<AnimatedAuthScreen> createState() => _AnimatedAuthScreenState();
}

class _AnimatedAuthScreenState extends ConsumerState<AnimatedAuthScreen> {
  bool isLoginMode = true;
  bool isLoading = false;

  void toggleMode() {
    setState(() {
      isLoginMode = !isLoginMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final templatePath = 'assets/images/${TemplateFactory.activeTemplateId}';
    final bgImage = widget.data['bg_image'] ?? '$templatePath/bg_image.jpg';

    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE LAYER
          Positioned.fill(child: Image.asset(bgImage, fit: BoxFit.cover)),

          // 2. DARK OVERLAY/GRADIENT
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0F172A).withOpacity(0.85),
                    const Color(0xFF1E1B4B).withOpacity(0.9),
                    const Color(0xFF312E81).withOpacity(0.85),
                  ],
                ),
              ),
            ),
          ),

          // 3. PARALLAX DECORATIONS (CLOUDS)
          ..._buildBackgroundDecorations(),

          // 4. PERSISTENT BRANDING
          Positioned(top: 40, left: 40, child: _buildBranding()),

          // 5. MAIN LAYERED CONTENT
          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 900;

                if (isDesktop) {
                  return BusinessPanel(
                    width: constraints.maxWidth * 0.85,
                    height: constraints.maxHeight * 0.85,
                    child: LayoutBuilder(
                      builder: (context, panelConstraints) {
                        final panelWidth = panelConstraints.maxWidth;
                        final sectionWidth = panelWidth / 2;

                        return Stack(
                          children: [
                            // FORM SECTION
                            AnimatedPositioned(
                              duration: 800.ms,
                              curve: Curves.fastOutSlowIn,
                              left: isLoginMode ? sectionWidth : 0,
                              width: sectionWidth,
                              top: 0,
                              bottom: 0,
                              child: AnimatedContainer(
                                duration: 600.ms,
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF0F172A,
                                  ).withOpacity(0.6),
                                ),
                                child: Center(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(48),
                                    child: AnimatedSwitcher(
                                      duration: 600.ms,
                                      child: isLoginMode
                                          ? _buildLoginForm(
                                              key: const ValueKey('login'),
                                            )
                                          : _buildSignupForm(
                                              key: const ValueKey('signup'),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // HERO SECTION
                            AnimatedPositioned(
                              duration: 800.ms,
                              curve: Curves.fastOutSlowIn,
                              left: isLoginMode ? 0 : sectionWidth,
                              width: sectionWidth,
                              top: 0,
                              bottom: 0,
                              child: ClipRRect(
                                child: Stack(
                                  children: [
                                    // Decorative Background (Clouds)
                                    Positioned(
                                      top: -20,
                                      right: -30,
                                      child:
                                          Opacity(
                                                opacity: 0.07,
                                                child: Image.asset(
                                                  'assets/images/${TemplateFactory.activeTemplateId}/clouds.png',
                                                  width: 250,
                                                ),
                                              )
                                              .animate(
                                                onPlay: (c) =>
                                                    c.repeat(reverse: true),
                                              )
                                              .move(
                                                begin: const Offset(-20, -10),
                                                end: const Offset(20, 10),
                                                duration: 10.seconds,
                                              ),
                                    ),
                                    Positioned(
                                      bottom: 40,
                                      left: -40,
                                      child:
                                          Opacity(
                                                opacity: 0.05,
                                                child: Image.asset(
                                                  'assets/images/${TemplateFactory.activeTemplateId}/clouds.png',
                                                  width: 200,
                                                ),
                                              )
                                              .animate(
                                                onPlay: (c) =>
                                                    c.repeat(reverse: true),
                                              )
                                              .move(
                                                begin: const Offset(30, 15),
                                                end: const Offset(-30, -15),
                                                duration: 12.seconds,
                                              ),
                                    ),
                                    Positioned(
                                      top: 150,
                                      left: 20,
                                      child:
                                          Opacity(
                                                opacity: 0.03,
                                                child: Image.asset(
                                                  'assets/images/${TemplateFactory.activeTemplateId}/clouds.png',
                                                  width: 150,
                                                ),
                                              )
                                              .animate(
                                                onPlay: (c) =>
                                                    c.repeat(reverse: true),
                                              )
                                              .move(
                                                begin: const Offset(10, 0),
                                                end: const Offset(-10, 0),
                                                duration: 8.seconds,
                                              ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.all(48.0),
                                      child: _buildWelcomeSide(isLoginMode),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 80,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildWelcomeSide(isLoginMode, isMobile: true),
                        const SizedBox(height: 48),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: AnimatedSwitcher(
                              duration: 500.ms,
                              child: isLoginMode
                                  ? _buildLoginForm(
                                      key: const ValueKey('login_m'),
                                    )
                                  : _buildSignupForm(
                                      key: const ValueKey('signup_m'),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranding() {
    return Row(
      children: [
        const Icon(Icons.change_circle, color: Colors.cyanAccent, size: 32)
            .animate(onPlay: (controller) => controller.repeat())
            .rotate(duration: 4.seconds),
        const SizedBox(width: 12),
        Text(
          widget.data['project_name'] ?? 'RapidWave',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildBackgroundDecorations() {
    return [
      Positioned(
        top: 100,
        right: -100,
        child:
            Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/images/${TemplateFactory.activeTemplateId}/clouds.png',
                    width: 300,
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .moveX(begin: -50, end: 50, duration: 20.seconds),
      ),
      Positioned(
        bottom: -50,
        left: -100,
        child:
            Opacity(
                  opacity: 0.05,
                  child: Image.asset(
                    'assets/images/${TemplateFactory.activeTemplateId}/clouds.png',
                    width: 200,
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .moveX(begin: 50, end: -50, duration: 15.seconds),
      ),
    ];
  }

  Widget _buildWelcomeSide(bool isLogin, {bool isMobile = false}) {
    final welcomeData = isLogin
        ? (widget.data['welcome_card_login'] ?? {})
        : (widget.data['welcome_card_signup'] ?? {});

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: 600.ms,
          height: isMobile ? 180 : 320,
          child:
              Image.asset(
                    'assets/images/${TemplateFactory.activeTemplateId}/login_ad_image.png',
                    fit: BoxFit.contain,
                  )
                  .animate(key: ValueKey(isLogin))
                  .scale(duration: 600.ms, curve: Curves.easeOutBack)
                  .shake(duration: 1.seconds, hz: 0.5)
                  .fadeIn(),
        ),
        const SizedBox(height: 32),
        AnimatedSwitcher(
          duration: 400.ms,
          child: Text(
            welcomeData['title'] ?? 'Welcome Back',
            key: ValueKey(isLogin),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: 400.ms,
          child: Text(
            widget.data['platform_greeting'] ?? 'Welcome to our platform',
            key: ValueKey(isLogin),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.cyanAccent,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: 400.ms,
          child: Text(
            welcomeData['subtitle'] ?? 'Sign in to continue your journey.',
            key: ValueKey(isLogin),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withAlpha(180),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 48),

        // Mode Toggle Button (Liquid Style)
        BusinessLiquidButton(
          label: isLogin ? "Go to Sign Up" : "Go to Sign In",
          onTap: toggleMode,
          primaryColor: Colors.cyanAccent.withOpacity(0.6),
        ),
      ],
    );
  }

  Widget _buildLoginForm({Key? key}) {
    final formData = widget.data['login_form'] ?? {};
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Sign In",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 40),
        Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Colors.cyanAccent),
          ),
          child: DynamicForm(
            fields: formData['fields'] ?? [],
            submitLabel: formData['submit_label'] ?? 'Login',
            validationMode: formData['validation_mode'] ?? 'onUserInteraction',
            socialLogins: List<String>.from(formData['social_logins'] ?? []),
            isLoading: isLoading,
            onSubmit: (values) async {
              setState(() => isLoading = true);
              try {
                final email = values['email'] ?? '';
                final password = values['password'] ?? '';
                await ref.read(authServiceProvider).signIn(
                      email: email,
                      password: password,
                    );
                if (mounted) context.go('/dashboard');
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
                if (mounted) setState(() => isLoading = false);
              }
            },
            isLiquidButton: true,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account?",
              style: TextStyle(color: Colors.white70),
            ),
            TextButton(
              onPressed: toggleMode,
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSignupForm({Key? key}) {
    final formData = widget.data['signup_form'] ?? {};
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Create Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 40),
        Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: Colors.cyanAccent),
          ),
          child: Column(
            children: [
              DynamicForm(
                fields: formData['fields'] ?? [],
                submitLabel: formData['submit_label'] ?? 'Register',
                validationMode:
                    formData['validation_mode'] ?? 'onUserInteraction',
                socialLogins: List<String>.from(
                  formData['social_logins'] ?? [],
                ),
                isLoading: isLoading,
                onSubmit: (values) async {
                  setState(() => isLoading = true);
                  try {
                    final email = values['email'] ?? '';
                    final password = values['password'] ?? '';
                    final name = values['name'];
                    
                    await ref.read(authServiceProvider).signUp(
                          email: email,
                          password: password,
                          name: name,
                        );
                    if (mounted) {
                      toggleMode();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registration successful! Please check your email or sign in.')),
                      );
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
                    if (mounted) setState(() => isLoading = false);
                  }
                },
                isLiquidButton: true,
              ),
              const SizedBox(height: 24),
              _buildVerificationMock(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.white70),
                  ),
                  TextButton(
                    onPressed: toggleMode,
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationMock() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_user, color: Colors.cyanAccent),
          const SizedBox(width: 12),
          const Text(
            'Verification Required',
            style: TextStyle(color: Colors.white70),
          ),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white24),
        ],
      ),
    );
  }
}
