import 'package:flutter/material.dart';

import '../../../core/models/property_model.dart';
import './location_tab_widget.dart';
import './overview_tab_widget.dart';
import './photos_tab_widget.dart';
import './reviews_tab_widget.dart';

/// Tabbed interface for property details content
class PropertyTabsWidget extends StatefulWidget {
  final Property property;

  const PropertyTabsWidget({Key? key, required this.property})
    : super(key: key);

  @override
  State<PropertyTabsWidget> createState() => _PropertyTabsWidgetState();
}

class _PropertyTabsWidgetState extends State<PropertyTabsWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
            indicatorWeight: 3,
            labelStyle: theme.textTheme.labelLarge,
            unselectedLabelStyle: theme.textTheme.labelMedium,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Photos'),
              Tab(text: 'Location'),
              Tab(text: 'Reviews'),
            ],
          ),
        ),

        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              OverviewTabWidget(property: widget.property),
              PhotosTabWidget(property: widget.property),
              LocationTabWidget(property: widget.property),
              ReviewsTabWidget(property: widget.property),
            ],
          ),
        ),
      ],
    );
  }
}
