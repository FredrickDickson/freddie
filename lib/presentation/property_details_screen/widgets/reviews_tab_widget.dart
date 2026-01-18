import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../core/models/property_model.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Reviews tab displaying property ratings and user reviews
class ReviewsTabWidget extends StatelessWidget {
  final Property property;

  const ReviewsTabWidget({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reviews = property.reviews;
    final averageRating = property.averageRating;
    final totalReviews = reviews.length;

    if (reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'rate_review',
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: 2.h),
            Text(
              'No reviews yet',
              style: theme.textTheme.titleMedium,
            ),
            SizedBox(height: 1.h),
            Text(
              'Be the first to review this property!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating Summary
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    _buildStarRating(averageRating, theme),
                    SizedBox(height: 0.5.h),
                    Text(
                      '$totalReviews reviews',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 6.w),
                Expanded(child: _buildRatingBreakdown(theme)),
              ],
            ),
          ),
          SizedBox(height: 3.h),

          // Reviews List
          Text(
            'Reviews',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.5.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final review = reviews[index];
              return _buildReviewCard(review, theme);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return CustomIconWidget(
          iconName: index < rating.floor() ? 'star' : 'star_border',
          color: theme.colorScheme.primary,
          size: 16,
        );
      }),
    );
  }

  Widget _buildRatingBreakdown(ThemeData theme) {
    final breakdown = property.ratingBreakdown;

    return Column(
      children: [5, 4, 3, 2, 1].map((star) {
        final count = breakdown["$star"] ?? 0;
        final totalReviews = property.reviews.length;
        final percentage = totalReviews > 0 ? (count / totalReviews) * 100 : 0.0;

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 0.5.h),
          child: Row(
            children: [
              Text('$star', style: theme.textTheme.bodySmall),
              SizedBox(width: 1.w),
              CustomIconWidget(
                iconName: 'star',
                color: theme.colorScheme.primary,
                size: 12,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: theme.colorScheme.outline.withValues(
                    alpha: 0.2,
                  ),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Text('$count', style: theme.textTheme.bodySmall),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer Info
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: review["userAvatar"] != null
                    ? ClipOval(
                        child: CustomImageWidget(
                          imageUrl: review["userAvatar"] as String,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          semanticLabel: review["userName"] as String,
                        ),
                      )
                    : Text(
                        (review["userName"] as String)[0].toUpperCase(),
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review["userName"] as String,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      review["date"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStarRating((review["rating"] as num).toDouble(), theme),
            ],
          ),
          SizedBox(height: 1.5.h),

          // Review Text
          Text(
            review["comment"] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),

          // Helpful Button
          if (review["helpfulCount"] != null) ...[
            SizedBox(height: 1.5.h),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: CustomIconWidget(
                    iconName: 'thumb_up_outlined',
                    color: theme.colorScheme.primary,
                    size: 16,
                  ),
                  label: Text(
                    'Helpful (${review["helpfulCount"]})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
