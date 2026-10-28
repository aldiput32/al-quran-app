import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class DonasiScreen extends StatelessWidget {
  const DonasiScreen({super.key});

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label berhasil disalin ke clipboard!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donasi Perpanjang Server'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
        children: [
          // Banner Card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F766E), Color(0xFF047857)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.volunteer_activism_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wakaf & Infaq Server',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Jaga Al-Qur\'an App Tetap Beroperasi',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Aplikasi Al-Qur\'an Indonesia beroperasi 100% tanpa iklan komersial. Donasi Anda digunakan sepenuhnya untuk biaya perpanjangan server cloud, bandwidth streaming audio murottal 114 surat, dan pemeliharaan API jadwal sholat.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    height: 1.6,
                    color: Colors.white.withOpacity(0.95),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Server Status Transparency Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.cloud_done_rounded,
                        color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Status Server & Operasional',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Online',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                _buildServerStatRow(
                  'Kapasitas Server',
                  '114 Surat Full Murottal (High-Speed CDN)',
                  isDark,
                ),
                const SizedBox(height: 8),
                _buildServerStatRow(
                  'Database Terjemahan',
                  'Kemenag RI + Tafsir Lengkap',
                  isDark,
                ),
                const SizedBox(height: 8),
                _buildServerStatRow(
                  'Target Operasional',
                  'Perpanjangan Sewa Server Cloud Tahunan',
                  isDark,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Payment Methods Header
          Text(
            'PILIHAN METODE DONASI (E-WALLET)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),

          // 1. GoPay Card
          _buildEWalletCard(
            context,
            walletName: 'GoPay',
            accountNo: '085691430408',
            formattedAccountNo: '0856-9143-0408',
            accountHolder: 'Ahmad Aldi Putera',
            badgeColor: const Color(0xFF00AED6),
            icon: Icons.account_balance_wallet_rounded,
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // 2. ShopeePay Card
          _buildEWalletCard(
            context,
            walletName: 'ShopeePay',
            accountNo: '085691430408',
            formattedAccountNo: '0856-9143-0408',
            accountHolder: 'Ahmad Aldi Putera',
            badgeColor: const Color(0xFFEE4D2D),
            icon: Icons.shopping_bag_outlined,
            isDark: isDark,
          ),
          const SizedBox(height: 14),

          // Quick Transfer Guide
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Petunjuk Transfer E-Wallet:',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '1. Buka aplikasi GoPay atau Shopee.\n2. Pilih menu Transfer / Kirim ke Nomor HP.\n3. Masukkan 085691430408 dan pastikan nama penerima tertulis Ahmad Aldi Putera.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          height: 1.5,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // WhatsApp Confirmation Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(isDark ? 0.12 : 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.green.withOpacity(0.4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline_rounded,
                        color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Konfirmasi Donasi WhatsApp',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Kirim bukti transfer atau konfirmasi donasi ke nomor pengembang:\n0856-9143-0408 (Ahmad Aldi Putera)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    height: 1.5,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    label: const Text('Salin Format Konfirmasi WhatsApp'),
                    onPressed: () {
                      _copyToClipboard(
                        context,
                        'Assalamu\'alaikum Mas Ahmad Aldi Putera, saya telah mengirimkan donasi untuk perpanjangan server Al-Qur\'an Indonesia. Semoga bermanfaat untuk umat. Terima kasih.',
                        'Format konfirmasi WhatsApp',
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Hadith / Virtue Box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.format_quote_rounded,
                  size: 32,
                  color: AppColors.accentGold,
                ),
                const SizedBox(height: 6),
                Text(
                  'إِذَا مَاتَ الْإِنْسَانُ انْقَطَعَ عَمَلُهُ إِلَّا مِنْ ثَلَاثَةٍ: صَدَقَةٍ جَارِيَةٍ، أَوْ عِلْمٍ يُنْتَفَعُ بِهِ، أَوْ وَلَدٍ صَالِحٍ يَدْعُو لَهُ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amiri(
                    fontSize: 18,
                    height: 1.8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '"Jika seseorang meninggal dunia, maka terputuslah amalannya kecuali tiga perkara: sedekah jariyah, ilmu yang dimanfaatkan, atau doa anak yang sholeh."',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '(HR. Muslim no. 1631)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.accentGold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildEWalletCard(
    BuildContext context, {
    required String walletName,
    required String accountNo,
    required String formattedAccountNo,
    required String accountHolder,
    required Color badgeColor,
    required IconData icon,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: badgeColor, width: 1.2),
            ),
            child: Icon(icon, color: badgeColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      walletName,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'E-Wallet',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  formattedAccountNo,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: isDark ? AppColors.primaryLight : AppColors.primary,
                  ),
                ),
                Text(
                  'a.n. $accountHolder',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.copy_rounded, size: 14),
            label: const Text('Salin', style: TextStyle(fontSize: 12)),
            onPressed: () {
              _copyToClipboard(context, accountNo, 'Nomor $walletName');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServerStatRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• $label: ',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        ),
      ],
    );
  }
}
