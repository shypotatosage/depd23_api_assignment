part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Costs> costsData = [];

  ///
  dynamic selectedCourier;
  dynamic weight;
  bool isLoading = false;

  dynamic provinceDataOrigin;
  dynamic provinceIdOrigin;
  dynamic selectedProvinceOrigin;

  dynamic provinceDataDestination;
  dynamic provinceIdDestination;
  dynamic selectedProvinceDestination;

  Future<dynamic> getProvinces() async {
    await MasterDataService.getProvince().then((value) {
      setState(() {
        provinceDataOrigin = value;
        provinceDataDestination = value;

        isLoading = false;
      });
    });
  }

  dynamic cityDataOrigin;
  dynamic cityIdOrigin;
  dynamic selectedCityOrigin;

  dynamic cityDataDestination;
  dynamic cityIdDestination;
  dynamic selectedCityDestination;

  Future<List<City>> getCities(var provId) async {
    dynamic city;
    await MasterDataService.getCity(provId).then((value) {
      setState(() {
        city = value;
      });
    });

    return city;
  }

  Future<dynamic> getCosts(
      var originId, var destinationId, var weight, var courier) async {
    await MasterDataService.getCosts(originId, destinationId, weight, courier)
        .then((value) {
      setState(() {
        costsData = value;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    getProvinces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          "Hitung Ongkir",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: 20, right: 10, top: 20),
                                child: DropdownButton(
                                    isExpanded: true,
                                    value: selectedCourier,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 30,
                                    elevation: 4,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                    hint: selectedCourier == null
                                        ? Text('Pilih Kurir')
                                        : Text(selectedCourier),
                                    items: [
                                      DropdownMenuItem(
                                          value: "jne", child: Text('jne')),
                                      DropdownMenuItem(
                                          value: "pos", child: Text('pos')),
                                      DropdownMenuItem(
                                          value: "tiki", child: Text('tiki')),
                                    ],
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedCourier = newValue.toString();
                                      });
                                    })),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 20),
                              child: SizedBox(
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      height: 1,
                                      color: Colors.black),
                                  decoration: const InputDecoration(
                                    labelText: 'Berat (gr)',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      weight = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 10),
                          child: Text(
                            "Origin",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          )),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: Container(
                                padding: EdgeInsets.only(left: 20, right: 10),
                                child: provinceDataOrigin != null
                                    ? DropdownButton(
                                        isExpanded: true,
                                        value: selectedProvinceOrigin,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                        hint: selectedProvinceOrigin == null
                                            ? Text('Pilih Provinsi')
                                            : Text(selectedProvinceOrigin
                                                .province),
                                        items: provinceDataOrigin
                                            .map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.province.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedProvinceOrigin = newValue;
                                            provinceIdOrigin =
                                                selectedProvinceOrigin
                                                    .provinceId;
                                            selectedCityOrigin = null;
                                            cityIdOrigin = null;
                                            cityDataOrigin =
                                                getCities(provinceIdOrigin);
                                          });
                                        })
                                    : UiLoading.loadingSmall()),
                          ),
                          provinceIdOrigin != null
                              ? Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 20),
                                      child: FutureBuilder<List<City>>(
                                          future: cityDataOrigin,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState !=
                                                ConnectionState.done) {
                                              return UiLoading.loadingSmall();
                                            }
                                            if (snapshot.hasData) {
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value: selectedCityOrigin,
                                                  icon: Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 4,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                  hint: selectedCityOrigin ==
                                                          null
                                                      ? Text('Pilih Kota')
                                                      : Text(selectedCityOrigin
                                                          .cityName),
                                                  items: snapshot.data!.map<
                                                      DropdownMenuItem<
                                                          City>>((City value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value
                                                            .cityName
                                                            .toString()));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedCityOrigin =
                                                          newValue;
                                                      cityIdOrigin =
                                                          selectedCityOrigin
                                                              .cityId;
                                                    });
                                                  });
                                            } else if (snapshot.hasError) {
                                              return Text("Tidak ada data");
                                            }
                                            return UiLoading.loadingSmall();
                                          })),
                                )
                              : Container()
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: 20, right: 10),
                          child: Text(
                            "Destination",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          )),
                      Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            flex: 1,
                            child: Container(
                                padding: EdgeInsets.only(left: 20, right: 10),
                                child: provinceDataDestination != null
                                    ? DropdownButton(
                                        isExpanded: true,
                                        value: selectedProvinceDestination,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 30,
                                        elevation: 4,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                        hint: selectedProvinceDestination ==
                                                null
                                            ? Text('Pilih Provinsi')
                                            : Text(selectedProvinceDestination
                                                .province),
                                        items: provinceDataOrigin
                                            .map<DropdownMenuItem<Province>>(
                                                (Province value) {
                                          return DropdownMenuItem(
                                              value: value,
                                              child: Text(
                                                  value.province.toString()));
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            selectedCityDestination = null;
                                            cityIdDestination = null;
                                            cityDataDestination = null;
                                            selectedProvinceDestination =
                                                newValue;
                                            provinceIdDestination =
                                                selectedProvinceDestination
                                                    .provinceId;
                                            cityDataDestination = getCities(
                                                provinceIdDestination);
                                          });
                                        })
                                    : UiLoading.loadingSmall()),
                          ),
                          provinceIdDestination != null
                              ? Flexible(
                                  fit: FlexFit.tight,
                                  flex: 1,
                                  child: Container(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 20),
                                      child: FutureBuilder<List<City>>(
                                          future: cityDataDestination,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState !=
                                                ConnectionState.done) {
                                              return UiLoading.loadingSmall();
                                            }
                                            if (snapshot.hasData) {
                                              return DropdownButton(
                                                  isExpanded: true,
                                                  value:
                                                      selectedCityDestination,
                                                  icon: Icon(
                                                      Icons.arrow_drop_down),
                                                  iconSize: 30,
                                                  elevation: 4,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16),
                                                  hint: selectedCityDestination ==
                                                          null
                                                      ? Text('Pilih Kota')
                                                      : Text(
                                                          selectedCityDestination
                                                              .cityName),
                                                  items: snapshot.data!.map<
                                                      DropdownMenuItem<
                                                          City>>((City value) {
                                                    return DropdownMenuItem(
                                                        value: value,
                                                        child: Text(value
                                                            .cityName
                                                            .toString()));
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedCityDestination =
                                                          newValue;
                                                      cityIdDestination =
                                                          selectedCityDestination
                                                              .cityId;
                                                    });
                                                  });
                                            } else if (snapshot.hasError) {
                                              return Text("Tidak ada data");
                                            }
                                            return UiLoading.loadingSmall();
                                          })),
                                )
                              : Container()
                        ],
                      )
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle:
                        const TextStyle(fontSize: 16, color: Colors.white),
                    surfaceTintColor: Colors.white,
                    backgroundColor: (cityIdDestination != null &&
                            cityIdOrigin != null &&
                            selectedCourier != null &&
                            (weight != null && weight.toString() != "0"))
                        ? Color.fromARGB(255, 93, 45, 176)
                        : Color.fromARGB(255, 181, 149, 237)),
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    if (cityIdDestination != null &&
                        cityIdOrigin != null &&
                        selectedCourier != null &&
                        (weight != null && weight.toString() != "0")) {
                      getCosts(cityIdOrigin, cityIdDestination, weight,
                          selectedCourier);
                    }
                  });
                },
                child: const Text(
                  'Hitung Estimasi Harga',
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                flex: 5,
                child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: costsData.isEmpty
                        ? const Align(
                            alignment: Alignment.center,
                            child: Text("Tidak Ada Data"),
                          )
                        : ListView.builder(
                            itemCount: costsData.length,
                            itemBuilder: (context, index) {
                              return CardCosts(costsData[index]);
                            })),
              ),
            ],
          ),
          isLoading == true ? UiLoading.loadingBlock() : Container(),
        ],
      ),
    );
  }
}
