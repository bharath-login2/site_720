import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/routes.dart';
import '../../../core/widgets/connectivity_dialog.dart';
import '../cubit/site_visit_history_cubit.dart';
import '../cubit/site_visit_history_state.dart';
import 'package:site_720/core/widgets/appbar.dart';
import '../../../data/models/site_visit_history/site_visit_history_model.dart';

class SiteVisitHistoryPage extends StatelessWidget {
  final String id;
  const SiteVisitHistoryPage({super.key, required this.id});

  /// Pull-to-refresh: reloads silently so the list stays on screen.
  Future<void> _refresh(BuildContext context) async {
    final ok = await context
        .read<SiteVisitHistoryCubit>()
        .fetchVisits(id, silent: true);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not refresh. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Tap on a visit card -> details screen. It returns true when the visit
  /// was saved or a file was deleted, so the list reloads from page 1.
  Future<void> _openDetails(BuildContext context, VisitTask item) async {
    connStatus = true;
    final cubit = context.read<SiteVisitHistoryCubit>();

    final changed = await Navigator.pushNamed(
      context,
      AppRoutes.siteVisitDetails,
      arguments: item.toJson(),
    );

    if (changed == true && context.mounted) {
      cubit.fetchVisits(id, silent: true); // keeps the list + active filter
    }
  }

  /// Tap on Total / Done / Pending in the header.
  Future<void> _onFilter(BuildContext context, VisitFilter filter) async {
    final ok =
        await context.read<SiteVisitHistoryCubit>().setFilter(id, filter);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not apply the filter. Please try again.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: simpleAppbar(context, "Site Visit History", true),
      body: BlocBuilder<SiteVisitHistoryCubit, SiteVisitHistoryState>(
        builder: (context, state) {
          if (state is SiteVisitHistoryLoading ||
              state is SiteVisitHistoryInitial) {
            return const _HistorySkeleton();
          }

          if (state is SiteVisitHistoryError) {
            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: _ScrollableMessage(
                icon: Icons.cloud_off_rounded,
                color: Colors.red.shade400,
                title: 'Something went wrong',
                subtitle: state.message,
                actionLabel: 'Retry',
                onAction: () =>
                    context.read<SiteVisitHistoryCubit>().fetchVisits(id),
              ),
            );
          }

          final s = state as SiteVisitHistoryLoaded;
          final cubit = context.read<SiteVisitHistoryCubit>();

          // No visits at all (still scrollable so pull-to-refresh works)
          if (s.items.isEmpty &&
              s.filter == VisitFilter.all &&
              !s.isFilterLoading) {
            return RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: const _ScrollableMessage(
                icon: Icons.event_busy_rounded,
                color: Colors.blueGrey,
                title: 'No site visits yet',
                subtitle:
                    'Visits scheduled for this project will appear here.\nPull down to refresh.',
              ),
            );
          }

          // header + (spinner | empty message | items + footer)
          final bodyCount =
              (s.isFilterLoading || s.items.isEmpty) ? 1 : s.items.length + 1;

          return RefreshIndicator(
            onRefresh: () => _refresh(context),
            child: NotificationListener<ScrollNotification>(
              // Pagination: load the next page when near the bottom
              onNotification: (n) {
                if (n.metrics.axis == Axis.vertical &&
                    n.metrics.pixels >= n.metrics.maxScrollExtent - 250) {
                  cubit.loadMore(id);
                }
                return false;
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics()),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                itemCount: 1 + bodyCount,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: _SummaryHeader(
                        data: s,
                        onFilter: (f) => _onFilter(context, f),
                      ),
                    );
                  }
                  if (s.isFilterLoading) return const _ListSkeleton();
                  if (s.items.isEmpty) {
                    return _InlineEmpty(filter: s.filter);
                  }
                  if (index == s.items.length + 1) {
                    return _ListFooter(
                      state: s,
                      onRetry: () => cubit.loadMore(id),
                    );
                  }
                  final i = index - 1;
                  return _TimelineItem(
                    task: s.items[i],
                    isFirst: i == 0,
                    isLast: i == s.items.length - 1 &&
                        !s.hasMore &&
                        !s.loadMoreFailed,
                    onTap: () => _openDetails(context, s.items[i]),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

// ───────────────────────── Helpers ─────────────────────────

bool _isCompleted(String status) => status.toLowerCase().contains('complet');

Color _statusColor(String status) {
  final s = status.toLowerCase();
  if (s.contains('complet')) return const Color(0xFF2E9E5B);
  if (s.contains('pend')) return const Color(0xFFF08C1A);
  return Colors.grey;
}

// ───────────────────────── Summary header (tap to filter) ─────────────────────────

class _SummaryHeader extends StatelessWidget {
  final SiteVisitHistoryLoaded data;
  final ValueChanged<VisitFilter> onFilter;
  const _SummaryHeader({required this.data, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final total = data.totalCount;
    final progress = total == 0 ? 0.0 : data.completedCount / total;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primary, primary.withOpacity(.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(.25),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timeline_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text('Visit progress',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${(progress * 100).round()}%',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation(Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatPill(
                label: 'Total',
                value: total,
                icon: Icons.list_alt,
                selected: data.filter == VisitFilter.all,
                activeColor: primary,
                onTap: () => onFilter(VisitFilter.all),
              ),
              const SizedBox(width: 8),
              _StatPill(
                label: 'Completed',
                value: data.completedCount,
                icon: Icons.check_circle_outline,
                selected: data.filter == VisitFilter.completed,
                activeColor: primary,
                onTap: () => onFilter(VisitFilter.completed),
              ),
              const SizedBox(width: 8),
              _StatPill(
                label: 'Pending',
                value: data.pendingCount,
                icon: Icons.schedule,
                selected: data.filter == VisitFilter.pending,
                activeColor: primary,
                onTap: () => onFilter(VisitFilter.pending),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final bool selected;
  final Color activeColor;
  final VoidCallback onTap;
  const _StatPill({
    required this.label,
    required this.value,
    required this.icon,
    required this.selected,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = selected ? activeColor : Colors.white;
    final fgSub = selected ? activeColor.withOpacity(.7) : Colors.white70;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.white.withOpacity(.18),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(icon, color: fg, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '$value',
                    style: TextStyle(
                      color: fg,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: fgSub, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Timeline ─────────────────────────

class _TimelineItem extends StatelessWidget {
  final VisitTask task;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;
  const _TimelineItem({
    required this.task,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(task.status);
    final done = _isCompleted(task.status);
    final lineColor = Colors.grey.shade300;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Rail: line – dot – line
          SizedBox(
            width: 36,
            child: Column(
              children: [
                SizedBox(
                  height: 18,
                  child: Container(
                    width: 2,
                    color: isFirst ? Colors.transparent : lineColor,
                  ),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                          color: color.withOpacity(.4),
                          blurRadius: 6,
                          spreadRadius: 1),
                    ],
                  ),
                  child: Icon(
                    done ? Icons.check : Icons.schedule,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : lineColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Card
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16, top: 4),
              child: _VisitCard(task: task, color: color, onTap: onTap),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisitCard extends StatelessWidget {
  final VisitTask task;
  final Color color;
  final VoidCallback onTap;
  const _VisitCard(
      {required this.task, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final initial =
        task.staffName.isNotEmpty ? task.staffName[0].toUpperCase() : '?';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 4, color: color), // status accent bar
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  task.taskTitle,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _Chip(
                                text: task.status,
                                color: color,
                                filled: true,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            task.projectName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12.5, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _Chip(
                                text: task.stageName,
                                color: Colors.indigo,
                                icon: Icons.layers_outlined,
                              ),
                              _Chip(
                                text: '${task.fromDate}  →  ${task.toDate}',
                                color: Colors.blueGrey,
                                icon: Icons.calendar_today_outlined,
                              ),
                            ],
                          ),
                          if (task.description.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              task.description,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey.shade800),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Divider(height: 1, color: Colors.grey.shade200),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 13,
                                backgroundColor: color.withOpacity(.15),
                                child: Text(initial,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: color)),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Assigned by: ",
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.grey.shade600),
                                      ),
                                      TextSpan(
                                        text: task.staffName,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Icon(Icons.chevron_right,
                                  size: 20, color: Colors.grey.shade400),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  final bool filled;
  const _Chip({
    required this.text,
    required this.color,
    this.icon,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? color.withOpacity(.15) : color.withOpacity(.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 11.5, fontWeight: FontWeight.w600, color: color),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Pagination footer ─────────────────────────

class _ListFooter extends StatelessWidget {
  final SiteVisitHistoryLoaded state;
  final VoidCallback onRetry;
  const _ListFooter({required this.state, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        ),
      );
    }

    if (state.loadMoreFailed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Couldn\'t load more. Tap to retry'),
          ),
        ),
      );
    }

    if (!state.hasMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline,
                size: 16, color: Colors.grey.shade500),
            const SizedBox(width: 6),
            Text("You're all caught up",
                style: TextStyle(fontSize: 12.5, color: Colors.grey.shade500)),
          ],
        ),
      );
    }

    return const SizedBox(height: 40);
  }
}

// ───────────────────────── Inline states (header stays visible) ─────────────────────────

class _InlineEmpty extends StatelessWidget {
  final VisitFilter filter;
  const _InlineEmpty({required this.filter});

  @override
  Widget build(BuildContext context) {
    final isDone = filter == VisitFilter.completed;
    final color = isDone ? const Color(0xFF2E9E5B) : const Color(0xFFF08C1A);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone ? Icons.task_alt_rounded : Icons.hourglass_empty_rounded,
              size: 44,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text('No ${filter.label.toLowerCase()} visits',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Tap "Total" above to see all visits.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

// ───────────────────────── Empty / error ─────────────────────────

/// Centered message that stays scrollable, so pull-to-refresh still works.
class _ScrollableMessage extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _ScrollableMessage({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: color.withOpacity(.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 56, color: color),
                  ),
                  const SizedBox(height: 20),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13.5, color: Colors.grey.shade600)),
                  if (actionLabel != null) ...[
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: onAction,
                      icon: const Icon(Icons.refresh),
                      label: Text(actionLabel!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── Skeleton loading ─────────────────────────

/// Builds one grey placeholder block. Its colour pulses with the animation.
typedef _Bone = Widget Function({
  double? width,
  required double height,
  double radius,
});

/// Runs one shared pulse animation and hands a [_Bone] factory to [builder].
class _Pulse extends StatefulWidget {
  final Widget Function(BuildContext context, _Bone bone) builder;
  const _Pulse({required this.builder});

  @override
  State<_Pulse> createState() => _PulseState();
}

class _PulseState extends State<_Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = Curves.easeInOut.transform(_c.value);
        final color =
            Color.lerp(const Color(0xFFE3E6ED), const Color(0xFFF2F4F8), t)!;

        Widget bone(
            {double? width, required double height, double radius = 8}) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(radius),
            ),
          );
        }

        return widget.builder(context, bone);
      },
    );
  }
}

/// One placeholder timeline row: dot + line on the left, card on the right.
Widget _timelineItem(_Bone bone, {bool isLast = false}) {
  return IntrinsicHeight(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 36,
          child: Column(
            children: [
              const SizedBox(height: 18),
              bone(width: 28, height: 28, radius: 14),
              Expanded(
                child: Container(
                  width: 2,
                  color: isLast ? Colors.transparent : Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4, bottom: isLast ? 0 : 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title + status chip
                  Row(
                    children: [
                      Expanded(child: bone(height: 16, radius: 6)),
                      const SizedBox(width: 40),
                      bone(width: 70, height: 22, radius: 20),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // project name
                  bone(width: 190, height: 12, radius: 6),
                  const SizedBox(height: 14),
                  // stage + date chips
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      bone(width: 80, height: 24, radius: 20),
                      bone(width: 140, height: 24, radius: 20),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(height: 1, color: Colors.grey.shade200),
                  const SizedBox(height: 10),
                  // staff row
                  Row(
                    children: [
                      bone(width: 26, height: 26, radius: 13),
                      const SizedBox(width: 8),
                      bone(width: 110, height: 12, radius: 6),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Full-page skeleton (header + timeline). Use for the first load.
class _HistorySkeleton extends StatelessWidget {
  const _HistorySkeleton();

  @override
  Widget build(BuildContext context) {
    return _Pulse(
      builder: (context, bone) => ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          bone(height: 170, radius: 18), // header card
          const SizedBox(height: 20),
          _timelineItem(bone),
          _timelineItem(bone),
          _timelineItem(bone, isLast: true),
        ],
      ),
    );
  }
}

/// Timeline-only skeleton. Use while a filter loads (header stays visible).
class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    return _Pulse(
      builder: (context, bone) => Column(
        children: [
          _timelineItem(bone),
          _timelineItem(bone),
          _timelineItem(bone, isLast: true),
        ],
      ),
    );
  }
}
