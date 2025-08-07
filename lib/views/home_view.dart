import 'package:flutter/material.dart';
import '../ui/theme.dart';
import '../models/enums.dart'; // enum TransactionType

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardTop,
      bottomNavigationBar: _BottomNavBar(),
      floatingActionButton: _FloatingMiddleButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Hello,', style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                      Text('Siyam Ahmed!',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: AppColors.textPrimary)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.search, color: AppColors.textPrimary, size: 28),
                      SizedBox(width: 10),
                      Icon(Icons.notifications_none, color: AppColors.textPrimary, size: 28),
                    ],
                  ),
                ],
              ),
            ),
            // Balance Card
            _BalanceCard(),

            // Expanded area with scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Upcoming payments
                    _SectionTitle(title: "Upcoming payment", onSeeAll: () {}),
                    SizedBox(
                      height: 124,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _UpcomingPaymentCard(
                            color: AppColors.cardMain,
                            icon: Icons.subscriptions_rounded,
                            title: "Adobe Premium",
                            amount: "\$30/month",
                            daysLeft: "2 days left",
                          ),
                          const SizedBox(width: 14),
                          _UpcomingPaymentCard(
                            color: AppColors.cardSecondary,
                            icon: Icons.apple_rounded,
                            title: "Apple Premium",
                            amount: "\$30/month",
                            daysLeft: "5 days left",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Recent Transactions
                    _SectionTitle(title: "Recent Transactions", onSeeAll: () {}),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textSecondary.withOpacity(0.07),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _TransactionTile(
                            icon: Icons.apple,
                            title: "Apple Inc.",
                            date: "21 Sep, 03:02 PM",
                            amount: "-\$230.50",
                            type: TransactionType.expense,
                          ),
                          Divider(height: 1),
                          _TransactionTile(
                            icon: Icons.subscriptions,
                            title: "Adobe",
                            date: "21 Sep, 02:22 PM",
                            amount: "-\$130.50",
                            type: TransactionType.expense,
                          ),
                          Divider(height: 1),
                          _TransactionTile(
                            icon: Icons.shopping_cart,
                            title: "Amazon",
                            date: "21 Sep, 02:02 PM",
                            amount: "-\$20.50",
                            type: TransactionType.expense,
                          ),
                        ],
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

// --- Section title
class _SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;
  const _SectionTitle({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 6, right: 4, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          TextButton(
            onPressed: onSeeAll,
            child: Text("See all", style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// --- Balance Card
class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            AppColors.gradientStart,
            AppColors.gradientEnd,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.gradientEnd.withAlpha(22),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withAlpha(30),
            ),
            child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Current Balance", style: TextStyle(fontSize: 15, color: Colors.white.withAlpha(225))),
                const SizedBox(height: 4),
                Text("\$4,570.80", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: const Padding(
                padding: EdgeInsets.all(9.0),
                child: Icon(Icons.add_circle, color: Colors.white, size: 32),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Upcoming payment card
class _UpcomingPaymentCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String amount;
  final String daysLeft;

  const _UpcomingPaymentCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.amount,
    required this.daysLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(36),
            blurRadius: 7,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 34),
              const Spacer(),
              Icon(Icons.more_vert, color: Colors.white, size: 24),
            ],
          ),
          const SizedBox(height: 14),
          Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 15)),
          const SizedBox(height: 2),
          Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white.withAlpha(225), fontSize: 18)),
          const SizedBox(height: 2),
          Text(daysLeft, style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 12)),
        ],
      ),
    );
  }
}

// --- Transaction item
class _TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final TransactionType type;

  const _TransactionTile({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final isNegative = type == TransactionType.expense;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.gradientEnd.withAlpha(25),
        child: Icon(icon, color: AppColors.gradientEnd, size: 24),
      ),
      title: Text(title, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(date, style: TextStyle(color: AppColors.textSecondary.withAlpha(178), fontSize: 13)),
      trailing: Text(
        amount,
        style: TextStyle(
          color: isNegative ? Color(0xFFE85050) : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

// --- Floating middle button (FAB central)
class _FloatingMiddleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: AppColors.cardMain,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Icon(Icons.qr_code_scanner, color: Colors.white, size: 34),
      onPressed: () {},
    );
  }
}

// --- Bottom Navigation Bar
class _BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.home_rounded), onPressed: () {}, color: AppColors.cardMain),
            Spacer(),
            IconButton(icon: Icon(Icons.pie_chart_rounded), onPressed: () {}, color: AppColors.textSecondary),
            Spacer(),
            SizedBox(width: 50), // espacio para el botón flotante central
            Spacer(),
            IconButton(icon: Icon(Icons.notifications_none), onPressed: () {}, color: AppColors.textSecondary),
            Spacer(),
            IconButton(icon: Icon(Icons.person_outline), onPressed: () {}, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
