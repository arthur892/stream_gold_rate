import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stream_gold_rate/src/features/gold/data/fake_gold_api.dart';

class GoldScreen extends StatelessWidget {
  const GoldScreen({super.key});
  @override
  Widget build(BuildContext context) {
    /// Platzhalter für den Goldpreis
    /// soll durch den Stream `getGoldPriceStream()` ersetzt werden
    //const double goldPrice = 69.22;

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              Text('Live Kurs:',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 20),
              // TODO: Verwende einen StreamBuilder, um den Goldpreis live anzuzeigen
              // statt des konstanten Platzhalters
              StreamBuilder(
                  stream: getGoldPriceStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } //else if (!snapshot.hasData || snapshot.data!.isEmpty)
                    else if (!snapshot.hasData) {
                      return const Center(child: Text('Keine Daten'));
                    }
                    try {
                      final goldPrice = snapshot.data;
                      return showGoldPrice(goldPrice: goldPrice!);
                    } catch (e) {
                      return const Text(
                          "Something went wrong in getting goldprice");
                    }
                  }),
              //const showGoldPrice(goldPrice: goldPrice),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Image(
          image: AssetImage('assets/bars.png'),
          width: 100,
        ),
        Text('Gold', style: Theme.of(context).textTheme.headlineLarge),
      ],
    );
  }
}

class showGoldPrice extends StatelessWidget {
  const showGoldPrice({
    super.key,
    required this.goldPrice,
  });

  final double goldPrice;

  @override
  Widget build(BuildContext context) {
    return Text(
      NumberFormat.simpleCurrency(locale: 'de_DE').format(goldPrice),
      style: Theme.of(context)
          .textTheme
          .headlineLarge!
          .copyWith(color: Theme.of(context).colorScheme.primary),
    );
  }
}
