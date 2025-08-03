import 'package:flutter/material.dart';
import '../utils/app_header.dart';    // Tu header personalizado
import '../ui/theme.dart';              // Importa tu archivo de colores

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // final w = MediaQuery.of(context).size.width;  // Quita si no usas
    return Column(
      children: [
        const AppHeader(showHome: false),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance Card
                _BalanceCard(),

                const SizedBox(height: 20),

                // Upcoming payments
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Próximos pagos",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Ver todos",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _UpcomingPaymentCard(
                        color: AppColors.cardMain,
                        icon: Icons.subscriptions_rounded,
                        title: "Adobe Premium",
                        amount: "\$30/mes",
                        daysLeft: "2 días restantes",
                      ),
                      const SizedBox(width: 14),
                      _UpcomingPaymentCard(
                        color: AppColors.cardSecondary,
                        icon: Icons.apple_rounded,
                        title: "Apple Premium",
                        amount: "\$30/mes",
                        daysLeft: "5 días restantes",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Recent Transactions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Transacciones recientes",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Ver todas",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _TransactionTile(
                      icon: Icons.apple,
                      title: "Apple Inc.",
                      date: "21 Sep, 03:02 PM",
                      amount: "-\$230.50",
                      isNegative: true,
                    ),
                    _TransactionTile(
                      icon: Icons.subscriptions,
                      title: "Adobe",
                      date: "21 Sep, 02:22 PM",
                      amount: "-\$130.50",
                      isNegative: true,
                    ),
                    _TransactionTile(
                      icon: Icons.shopping_cart,
                      title: "Amazon",
                      date: "21 Sep, 02:02 PM",
                      amount: "-\$20.50",
                      isNegative: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
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
            color: AppColors.gradientEnd.withAlpha(25), // 0.10*255=25
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
              color: Colors.white.withAlpha(25), // 0.10*255=25
            ),
            child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Balance actual",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withAlpha(242), // 0.95*255=242
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$4,570.80",
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
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
            color: color.withAlpha(31), // 0.12*255=31
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
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 15),
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white.withAlpha(230), fontSize: 18), // 0.9*255=230
          ),
          const SizedBox(height: 2),
          Text(
            daysLeft,
            style: TextStyle(color: Colors.white.withAlpha(178), fontSize: 12), // 0.7*255=178
          ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String amount;
  final bool isNegative;

  const _TransactionTile({
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 0),
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: AppColors.gradientEnd.withAlpha(20),
        child: Icon(icon, color: AppColors.gradientEnd, size: 24),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        date,
        style: TextStyle(
          color: AppColors.textSecondary.withAlpha(178), // 0.7*255=178
          fontSize: 13,
        ),
      ),
      trailing: Text(
        amount,
        style: TextStyle(
          color: isNegative ? const Color(0xFFE85050) : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
