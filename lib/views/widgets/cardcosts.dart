part of 'widgets.dart';

class CardCosts extends StatefulWidget {
  final Costs costs;
  const CardCosts(this.costs, {super.key});

  @override
  State<CardCosts> createState() => _CardCostsState();
}

class _CardCostsState extends State<CardCosts> {
  @override
  Widget build(BuildContext context) {
    Costs c = widget.costs;
    final formatter = NumberFormat.simpleCurrency(locale: 'id_ID');
    return Card(
      color: const Color(0xFFFFFFFF),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        title: Text("${c.description} (${c.service})"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Biaya: ${formatter.format(c.cost![0].value)}"),
            Text("Estimasi Sampai: ${c.cost![0].etd}"),
          ],
        ),
      ),
    );
  }
}
