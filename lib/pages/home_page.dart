import 'package:coincap_app/pages/details_page.dart';
import 'package:coincap_app/services/https_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  // call httpservice here

  HttpsServices? _httpsServices;

  String _selectedCoin =
      {"id": "bitcoin", "symbol": "btc", "name": "Bitcoin"}["id"] ?? "bitcoin";

  Future<void> _fetchCoinData(String coin) async {
    try {
      final data = await _httpsServices!.get(coin.toLowerCase());
      // Process the data as needed
      return data;
    } catch (e) {
      print("Error fetching data for $coin: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _httpsServices = GetIt.instance<HttpsServices>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [_selectedCoinDropdown(), _dataWidget()],
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropdown() {
    List<Map<String, dynamic>> coinList = [
      {"id": "bitcoin", "symbol": "btc", "name": "Bitcoin"},
      {"id": "ethereum", "symbol": "eth", "name": "Ethereum"},
      {"id": "litecoin", "symbol": "ltc", "name": "Litecoin"},
      {"id": "ripple", "symbol": "xrp", "name": "XRP"},
      {"id": "cardano", "symbol": "ada", "name": "Cardano"},
      {"id": "polkadot", "symbol": "dot", "name": "Polkadot"},
      {"id": "solana", "symbol": "sol", "name": "Solana"},
      {"id": "dogecoin", "symbol": "doge", "name": "Dogecoin"},
      {"id": "avalanche-2", "symbol": "avax", "name": "Avalanche"},
      {"id": "tron", "symbol": "trx", "name": "TRON"},
      {"id": "chainlink", "symbol": "link", "name": "Chainlink"},
      {"id": "uniswap", "symbol": "uni", "name": "Uniswap"},
      {"id": "binancecoin", "symbol": "bnb", "name": "BNB"},
      {"id": "stellar", "symbol": "xlm", "name": "Stellar"},
      {"id": "monero", "symbol": "xmr", "name": "Monero"},
      {"id": "tezos", "symbol": "xtz", "name": "Tezos"},
      {"id": "vechain", "symbol": "vet", "name": "VeChain"},
      {"id": "aave", "symbol": "aave", "name": "Aave"},
      {"id": "the-graph", "symbol": "grt", "name": "The Graph"},
      {"id": "shiba-inu", "symbol": "shib", "name": "Shiba Inu"},
    ];

    List<DropdownMenuItem<String>> items =
        coinList
            .map(
              (coin) => DropdownMenuItem(
                value: coin["id"].toString(),
                child: Text(
                  coin["name"].toString() ?? "Unknown Coin",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
            .toList();

    return Container(
      width: _deviceWidth! * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(83, 88, 206, 1.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCoin,
          items: items as List<DropdownMenuItem<String>>?,
          onChanged: (String? value) {
            _selectedCoin = value!;
            _fetchCoinData(value!);
            setState(() {});
          },
          isExpanded: true,
          dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
          iconEnabledColor: Colors.white,
        ),
      ),
    );
  }

  Widget _dataWidget() {
    return FutureBuilder(
      future: _fetchCoinData(_selectedCoin!),

      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: Colors.white);
        } else if (snapshot.hasError) {
          print("Error: ${snapshot.error}");
          return const Text(
            "Something went wrong",
            style: TextStyle(color: Colors.red),
          );
        } else if (snapshot.hasData) {
          Map<String, dynamic> _currentPrice =
              snapshot.data['market_data']['current_price'] ?? 0.0;
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                GestureDetector(
                  onDoubleTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => DetailsPage(
                              coinData:
                                  snapshot
                                      .data['market_data']['current_price'] ??
                                  {},
                            ),
                      ),
                    );
                  },
                  child: _coinImageWidget(
                    snapshot.data['image']['large'] ??
                        'https://via.placeholder.com/150',
                  ),
                ),
                _currentPriceWidget(
                  _currentPrice.toString() == '0.0'
                      ? 0.0
                      : double.parse(_currentPrice['usd'].toString()),
                ),
                _percentageChangeWidget(
                  double.parse(
                    snapshot.data['market_data']['price_change_percentage_24h']
                        .toString(),
                  ),
                ),

                _descriptionWidget(
                  snapshot.data['description']['en'] ??
                      'No description available',
                ),
              ],
            ),
          );
        } else {
          return const Text(
            "No data available",
            style: TextStyle(color: Colors.white),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(double price) {
    return Text(
      "\$${price.toStringAsFixed(2)}",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _percentageChangeWidget(double change) {
    return Text(
      "${change.toStringAsFixed(2)}%",
      style: TextStyle(
        color: change >= 0 ? Colors.green : Colors.red,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _coinImageWidget(String imageUrl) {
    return Container(
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      padding: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.02),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: NetworkImage(imageUrl)),
      ),
    );
  }

  Widget _descriptionWidget(String description) {
    return Container(
      width: _deviceWidth! * 0.90,
      height: _deviceHeight! * 0.45,
      margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.05),
      padding: EdgeInsets.symmetric(
        horizontal: _deviceWidth! * 0.01,
        vertical: _deviceHeight! * 0.01,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(83, 88, 206, 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Scrollbar(
        thumbVisibility: true,
        radius: const Radius.circular(8),
        thickness: 4.0,
        child: SingleChildScrollView(
          child: Text(
            description,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
