class OnboardingStep {
  final String title;
  final String description;
  final String? image;

  OnboardingStep({
    required this.title,
    required this.description,
    this.image,
  });

  factory OnboardingStep.fromJson(Map<String, dynamic> json) {
    return OnboardingStep(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      image: json['image'] as String?,
    );
  }
}

class SplashConfig {
  final bool visible;
  final bool isFeatureTour;
  final String projectName;
  final String continueButtonLabel;
  final List<OnboardingStep> onboarding;

  SplashConfig({
    required this.visible,
    required this.isFeatureTour,
    required this.projectName,
    required this.continueButtonLabel,
    required this.onboarding,
  });

  factory SplashConfig.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final onboardingList = (data['onboarding'] as List<dynamic>?)
            ?.map((e) => OnboardingStep.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return SplashConfig(
      visible: json['visible'] as bool? ?? false,
      isFeatureTour: json['isFeatureTour'] as bool? ?? false,
      projectName: data['project_name'] as String? ?? 'RapidWeave',
      continueButtonLabel: data['continue_button_label'] as String? ?? 'Continue',
      onboarding: onboardingList,
    );
  }
}
