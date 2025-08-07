import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
import '../ui/theme.dart';
import '../models/enums.dart';
import 'dashboard.dart';

// Vista de prueba para transacciones
class TransactionsTestView extends StatelessWidget {
  const TransactionsTestView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todas las transacciones')),
      body: const Center(child: Text('Vista de prueba de transacciones')),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context, listen: false);

    return FutureBuilder<UserModel?>(
      future: auth.getCurrentUserModel(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con nombre real
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hola,', style: TextStyle(fontSize: 18, color: AppColors.textSecondary)),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.search, color: AppColors.textPrimary, size: 28),
                      const SizedBox(width: 10),
                      Icon(Icons.notifications_none, color: AppColors.textPrimary, size: 28),
                    ],
                  ),
                ],
              ),
            ),
            // Balance Card (usa valor seguro)
            _BalanceCard(balance: user.balance ?? 0),
            // Expanded area with scroll
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Próximos pagos
                    _SectionTitle(
                      title: "Próximos pagos",
                      onSeeAll: () {
                        // Solución recomendada: usa callback global definido en Dashboard
                        // (ver nota abajo)
                        if (Dashboard.changeTabExternal != null) {
                          Dashboard.changeTabExternal!(0); // Cambia al tab Balance
                        }
                      },
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _UpcomingPaymentCard(
                            color: AppColors.cardMain,
                            icon: Icons.subscriptions_rounded,
                            title: "Netflix",
                            amount: "\$179/mes",
                            daysLeft: "2 días restantes",
                          ),
                          const SizedBox(width: 14),
                          _UpcomingPaymentCard(
                            color: AppColors.cardSecondary,
                            icon: Icons.shopping_basket,
                            title: "CFE",
                            amount: "\$300",
                            daysLeft: "5 días restantes",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Transacciones recientes
                    _SectionTitle(
                      title: "Transacciones recientes",
                      onSeeAll: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TransactionsTestView()),
                        );
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textSecondary.withAlpha((0.07 * 255).toInt()),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _TransactionTile(
                            icon: Icons.shopping_cart,
                            title: "Amazon",
                            date: "21 Jul, 02:02 PM",
                            amount: "-\$250.00",
                            type: TransactionType.expense,
                          ),
                          Divider(height: 1),
                          _TransactionTile(
                            icon: Icons.restaurant,
                            title: "Restaurante",
                            date: "20 Jul, 01:22 PM",
                            amount: "-\$120.00",
                            type: TransactionType.expense,
                          ),
                          Divider(height: 1),
                          _TransactionTile(
                            icon: Icons.arrow_downward,
                            title: "Salario",
                            date: "20 Jul, 12:00 PM",
                            amount: "+\$8,000.00",
                            type: TransactionType.income,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
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
            child: Text("Ver todo", style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// --- Balance Card
class _BalanceCard extends StatelessWidget {
  final double balance;
  const _BalanceCard({required this.balance});

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
                Text("Saldo actual", style: TextStyle(fontSize: 15, color: Colors.white.withAlpha(225))),
                const SizedBox(height: 4),
                Text("\$${balance.toStringAsFixed(2)}", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
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

// --- Upcoming payment card (sin overflow)
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
    return SizedBox(
      width: 170,
      height: 110,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 30),
                const Spacer(),
                Icon(Icons.more_vert, color: Colors.white, size: 20),
              ],
            ),
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 15)),
            Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white.withAlpha(225), fontSize: 15)),
            Text(daysLeft, style: TextStyle(color: Colors.white.withAlpha(160), fontSize: 11)),
          ],
        ),
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
          color: isNegative ? const Color(0xFFE85050) : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
