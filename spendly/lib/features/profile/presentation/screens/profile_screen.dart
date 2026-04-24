import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../../../core/providers/firebase_providers.dart';
// removed
import '../../data/user_repository.dart';
import '../../../transactions/data/transaction_repository.dart';
import '../../../budget/data/budget_repository.dart';
import '../../../transactions/domain/models/transaction_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    
    if (userId == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0E1A),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF00D4AA),
          ),
        ),
      );
    }

    final userAsync = ref.watch(currentUserProvider);
    final selectedMonth = ref.watch(selectedMonthProvider);
    final transactionsAsync = ref.watch(monthlyTransactionsProvider(selectedMonth));
    final budgetsAsync = ref.watch(monthlyBudgetsProvider(selectedMonth));
    
    String name = 'Loading...';
    String email = '';
    String memberSince = 'Üyelik: ...';
    
    userAsync.whenData((user) {
      if (user != null) {
        name = (user.displayName?.isNotEmpty == true) ? user.displayName! : 'Spendly User';
        email = user.email;
        final months = ['Oca', 'Şub', 'Mar', 'Nis', 'May', 'Haz', 'Tem', 'Ağu', 'Eyl', 'Eki', 'Kas', 'Ara'];
        memberSince = 'Üyelik: ${months[user.createdAt.month - 1]} ${user.createdAt.year}';
      } else {
        name = 'Guest';
      }
    });

    final txCount = transactionsAsync.valueOrNull?.length ?? 0;
    
    double thisMonthTotal = 0;
    transactionsAsync.valueOrNull?.forEach((tx) {
      if (tx.type == TransactionType.expense) {
        thisMonthTotal += tx.amount;
      }
    });
    
    final budgetsCount = budgetsAsync.valueOrNull?.length ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: MeshBackgroundPainter(),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Header
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Text(
                  'Profil',
                  style: TextStyle(
                    fontFamily: 'ClashDisplay',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),

              // 2. Profile GlassCard
              GlassCard(
                margin: const EdgeInsets.only(top: 16.0),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFF1C2640), // elevated
                          child: Icon(Icons.person_rounded, size: 40, color: Color(0xFF00D4AA)),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xFF00D4AA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, size: 14, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'ClashDisplay',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (email.isNotEmpty)
                      Text(
                        email,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 14,
                          color: Color(0xFF94A3B8), // textSecondary
                        ),
                      ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0x1A00D4AA),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: const Color(0x4000D4AA)),
                      ),
                      child: Text(
                        memberSince,
                        style: const TextStyle(
                          fontFamily: 'DM Sans',
                          fontSize: 12,
                          color: Color(0xFF00D4AA),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 3. Stats Row GlassCard
              GlassCard(
                margin: const EdgeInsets.only(top: 12.0),
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        value: '$txCount',
                        label: 'İşlemler',
                      ),
                    ),
                    _buildVerticalDivider(),
                    Expanded(
                      child: _buildStatItem(
                        value: '₺${(thisMonthTotal / 1000).toStringAsFixed(1)}K',
                        label: 'Bu Ay',
                      ),
                    ),
                    _buildVerticalDivider(),
                    Expanded(
                      child: _buildStatItem(
                        value: '$budgetsCount',
                        label: 'Bütçeler',
                      ),
                    ),
                  ],
                ),
              ),

              // 4. Settings Sections
              const SizedBox(height: 16),
              
              _buildSectionTitle('Tercihler'),
              _SettingsTile(
                icon: Icons.attach_money_rounded,
                iconBg: const Color(0x1A00D4AA),
                iconColor: const Color(0xFF00D4AA),
                label: 'Para Birimi',
                subtitle: 'Türk Lirası (₺)',
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A5568)),
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.language_rounded,
                iconBg: const Color(0x1A4ECDC4),
                iconColor: const Color(0xFF4ECDC4),
                label: 'Dil',
                subtitle: 'Türkçe',
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A5568)),
                onTap: () {},
              ),

              const SizedBox(height: 8),
              _buildSectionTitle('Bildirimler'),
              _SettingsTile(
                icon: Icons.notifications_rounded,
                iconBg: const Color(0x1AFFB347),
                iconColor: const Color(0xFFFFB347), // secondary
                label: 'Bütçe Uyarıları',
                trailing: Switch(
                  value: true,
                  onChanged: (_) {},
                  activeThumbColor: const Color(0xFF00D4AA),
                ),
              ),
              _SettingsTile(
                icon: Icons.calendar_month_rounded,
                iconBg: const Color(0x1AFFB347),
                iconColor: const Color(0xFFFFB347),
                label: 'Aylık Rapor',
                trailing: Switch(
                  value: false,
                  onChanged: (_) {},
                  activeThumbColor: const Color(0xFF00D4AA),
                ),
              ),

              const SizedBox(height: 8),
              _buildSectionTitle('Veri'),
              _SettingsTile(
                icon: Icons.picture_as_pdf_rounded,
                iconBg: const Color(0x1AFF6B6B),
                iconColor: const Color(0xFFFF6B6B),
                label: 'PDF Olarak Dışa Aktar',
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A5568)),
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.table_chart_rounded,
                iconBg: const Color(0x1A4CAF50),
                iconColor: const Color(0xFF4CAF50), // success
                label: 'CSV Olarak Dışa Aktar',
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A5568)),
                onTap: () {},
              ),

              const SizedBox(height: 8),
              _buildSectionTitle('Hesap'),
              _SettingsTile(
                icon: Icons.lock_rounded,
                iconBg: const Color(0x1A94A3B8),
                iconColor: const Color(0xFF94A3B8), // textSecondary
                label: 'Şifre Değiştir',
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF4A5568)),
                onTap: () {},
              ),
              _SettingsTile(
                icon: Icons.logout_rounded,
                iconBg: const Color(0x1AFF4C4C),
                iconColor: const Color(0xFFFF4C4C), // error
                label: 'Çıkış Yap',
                trailing: const Icon(Icons.chevron_right, color: Color(0xFFFF4C4C)),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),

              // 5. Version text
              const Padding(
                padding: EdgeInsets.only(top: 24.0, bottom: 32.0),
                child: Text(
                  'Spendly v1.0.0',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 12,
                    color: Color(0xFF4A5568), // textMuted
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
      ),
    );
  }

  Widget _buildStatItem({required String value, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'ClashDisplay',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'DM Sans',
            fontSize: 12,
            color: Color(0xFF4A5568),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0xFF1E2D45), // border
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 12,
          color: Color(0xFF4A5568), // textMuted
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: iconColor),
      ),
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: 'DM Sans',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFFFFFFFF),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontFamily: 'DM Sans',
                fontSize: 12,
                color: Color(0xFF4A5568),
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
