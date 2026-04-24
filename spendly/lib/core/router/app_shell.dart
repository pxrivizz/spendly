import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// AppShell provides the persistent navigation shell with custom BottomNavBar + FAB.
///
/// Matches the Stitch AI design: frosted glass bottom bar with rounded top corners,
/// active tab with teal color + glow dot, centered FAB above the bar.
class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const Map<String, int> _routeToIndex = {
    '/': 0,
    '/analytics': 1,
    '/budget': 3,
    '/profile': 4,
  };

  static const List<String> _indexToRoute = [
    '/',
    '/analytics',
    '/add-transaction', // placeholder for FAB center
    '/budget',
    '/profile',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).uri.path;
    final newIndex = _routeToIndex[location];
    if (newIndex != null && newIndex != _selectedIndex) {
      setState(() => _selectedIndex = newIndex);
    }
  }

  void _onNavTap(int index) {
    if (index == 2) {
      // Center FAB index – navigate to add transaction
      context.push('/add-transaction');
      return;
    }
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    context.go(_indexToRoute[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: widget.child,
      extendBody: true,
      // Floating Action Button
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00D4AA).withValues(alpha: 0.4),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SizedBox(
          width: 56,
          height: 56,
          child: FloatingActionButton(
            onPressed: () => context.push('/add-transaction'),
            backgroundColor: const Color(0xFF00D4AA),
            elevation: 0,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: Color(0xFF00382B),
              size: 28,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppSpacing.bottomNavRadius),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          padding: EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.sm + 4,
            bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: const Color(0xCC161D2A),
            border: Border(
              top: BorderSide(
                color: const Color(0xFF00D4AA).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavBarItem(
                icon: Icons.home_rounded,
                label: 'ANA SAYFA',
                isActive: _selectedIndex == 0,
                onTap: () => _onNavTap(0),
              ),
              _NavBarItem(
                icon: Icons.insights_rounded,
                label: 'ANALİTİK',
                isActive: _selectedIndex == 1,
                onTap: () => _onNavTap(1),
              ),
              // Spacer for FAB
              const SizedBox(width: AppSpacing.xl),
              _NavBarItem(
                icon: Icons.account_balance_wallet_rounded,
                label: 'BÜTÇE',
                isActive: _selectedIndex == 3,
                onTap: () => _onNavTap(3),
              ),
              _NavBarItem(
                icon: Icons.person_rounded,
                label: 'PROFİL',
                isActive: _selectedIndex == 4,
                onTap: () => _onNavTap(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual navigation bar item with active glow dot
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.navInactive,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.labelCaps.copyWith(
                fontSize: 10,
                color: isActive ? AppColors.primary : AppColors.navInactive,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Active glow dot
            if (isActive)
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.8),
                      blurRadius: 8,
                    ),
                  ],
                ),
              )
            else
              const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
