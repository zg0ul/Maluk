import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:maluk/src/features/quiz/presentation/controllers/quiz_providers.dart';
import 'package:maluk/src/features/quiz/presentation/widgets/resource_item.dart';
import 'package:maluk/src/utilities/app_spacer.dart';

/// Resources view showing financial wellness resources
class ResourcesView extends ConsumerWidget {
  final Function() onResourcesViewed;

  const ResourcesView({required this.onResourcesViewed, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizController = ref.read(quizStateProvider.notifier);
    final resources = quizController.getResources();

    // Notify that resources have been viewed (for achievements)
    WidgetsBinding.instance.addPostFrameCallback((_) => onResourcesViewed());

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Financial Wellness Resources',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            AppSpacer.height8,

            Text(
              'Explore these resources to enhance your financial knowledge',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            AppSpacer.height24,

            Expanded(
              child: ListView.builder(
                itemCount: resources.length,
                itemBuilder: (context, index) {
                  final resource = resources[index];
                  return ResourceItem(
                    title: resource['title'] as String,
                    description: resource['description'] as String,
                    icon: resource['icon'] as IconData,
                    index: index,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${resource['title']} resources coming soon!',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Additional information link
            Card(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              margin: EdgeInsets.zero,
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    AppSpacer.width16,
                    Expanded(
                      child: Text(
                        'Want to learn more about financial wellness? Take our full assessment to get personalized advice.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
