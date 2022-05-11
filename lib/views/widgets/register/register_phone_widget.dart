import 'package:carg/exceptions/custom_exception.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/styles/properties.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:provider/provider.dart';

class RegisterPhoneWidget extends StatefulWidget {
  final CredentialVerificationType credentialVerificationType;

  const RegisterPhoneWidget(
      {Key? key, required this.credentialVerificationType})
      : super(key: key);

  @override
  _RegisterPhoneWidgetState createState() => _RegisterPhoneWidgetState();
}

class _RegisterPhoneWidgetState extends State<RegisterPhoneWidget>
    with TickerProviderStateMixin {
  Future<CountryWithPhoneCode?> showCountriesDialog(
      Map<String, CountryWithPhoneCode> values) async {
    var _countries = List.of(values.values)
      ..sort((a, b) => a.countryName!.compareTo(b.countryName!));
    var countryList = CountryList(_countries);
    return showDialog<CountryWithPhoneCode>(
        context: context,
        builder: (BuildContext context) => ChangeNotifierProvider.value(
              value: countryList,
              child: Consumer<CountryList>(
                  builder: (context, countryListData, _) => SimpleDialog(
                          contentPadding: const EdgeInsets.all(24),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          children: <Widget>[
                            TextField(
                                autofillHints: const [
                                  AutofillHints.telephoneNumberNational
                                ],
                                onChanged: (value) {
                                  countryListData.filter(value);
                                },
                                decoration: const InputDecoration(
                                    labelText: 'Rechercher un pays'),
                                textInputAction: TextInputAction.search),
                            SizedBox(
                              height: 300,
                              width: 600,
                              child: ListView.builder(
                                  itemCount: countryListData.countries!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return TextButton(
                                      onPressed: () {
                                        Navigator.pop(context,
                                            countryListData.countries![index]);
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          text: countryListData
                                              .countries![index].countryName,
                                          style: TextStyle(
                                              fontFamily:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .fontFamily,
                                              fontSize:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .fontSize,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  DefaultTextStyle.of(context)
                                                      .style
                                                      .color),
                                          children: <TextSpan>[
                                              TextSpan(
                                                  text:
                                                      ' (${countryListData.countries![index].countryCode}',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style),
                                              TextSpan(
                                                  text:
                                                      ' +${countryListData.countries![index].phoneCode})',
                                                  style: DefaultTextStyle.of(
                                                          context)
                                                      .style)
                                            ])));
                                  }),
                            ),
                            Center(
                                child: Text(
                                    '${countryListData.countries!.length} pays',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontStyle: FontStyle.italic)))
                          ])),
            ));
  }

  Future _sendPinCode(PhoneRegistrationData phoneRegistrationData) async {
    try {
      phoneRegistrationData.sendingSms = true;
      var phoneNumber = await phoneRegistrationData.formatPhoneNumberToE164();
      await Provider.of<AuthService>(context, listen: false)
          .sendPhoneVerificationCode(
              phoneNumber, context, widget.credentialVerificationType);
    } on CustomException catch (e) {
      InfoSnackBar.showSnackBar(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: PhoneRegistrationData(),
        child: Consumer<PhoneRegistrationData>(
            builder: (context, phoneRegistrationData, _) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<Map<String, CountryWithPhoneCode>>(
                    future: phoneRegistrationData.getAllRegions(),
                    builder: (context, snapshot) {
                      return Column(children: [
                        Row(
                          children: [
                            AnimatedSize(
                              key: const ValueKey('placeholderPhoneContainer'),
                              curve: Curves.ease,
                              duration: const Duration(milliseconds: 500),
                              child: phoneRegistrationData.sendingSms
                                  ? const CircularProgressIndicator(
                                      strokeWidth: 5)
                                  : ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Theme.of(context).cardColor),
                                          foregroundColor: MaterialStateProperty.all<Color>(
                                              Theme.of(context).primaryColor),
                                          shape: MaterialStateProperty.all<OutlinedBorder>(
                                              RoundedRectangleBorder(
                                                  side: BorderSide(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            borderRadius: BorderRadius.circular(
                                                CustomProperties.borderRadius)))),
                                onPressed: snapshot.connectionState ==
                                    ConnectionState.done
                                    ? () async {
                                  phoneRegistrationData.country =
                                  await showCountriesDialog(
                                      snapshot.data!);
                                }
                                    : null,
                                child: AnimatedSize(
                                          curve: Curves.linear,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          child: Text(
                                            phoneRegistrationData.country !=
                                                    null
                                                ? phoneRegistrationData
                                                    .getCompactFormattedCountryName()
                                                : 'Pays',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ),
                            ),
                            const SizedBox(width: 15),
                            Flexible(
                              child: TextField(
                                textInputAction: TextInputAction.go,
                                enabled: phoneRegistrationData.country != null,
                                onSubmitted: (value) async {
                                  if (!phoneRegistrationData
                                      .isPhoneNumberEmpty()) {
                                    await _sendPinCode(phoneRegistrationData);
                                  }
                                },
                                onChanged: (value) {
                                  phoneRegistrationData.phoneNumber = value;
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelStyle: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  labelText: (phoneRegistrationData.country ==
                                          null
                                      ? ''
                                      : ' Exemple : ${phoneRegistrationData.country?.exampleNumberMobileNational}'),
                                  fillColor: Theme.of(context).primaryColor,
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        CustomProperties.borderRadius),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                      width: 2.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        CustomProperties.borderRadius),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        CustomProperties.borderRadius),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Un SMS de confirmation contenant un code à 6 chiffres '
                          'va vous être envoyé. Des frais standards d\'envoi '
                          'de messages et d\'échange de données s\'appliquent',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 13),
                        )
                      ]);
                    }))));
  }
}

class CountryList with ChangeNotifier {
  List<CountryWithPhoneCode>? _countries;
  List<CountryWithPhoneCode>? _initialCountries;

  CountryList(this._countries) {
    _initialCountries = _countries;
  }

  List<CountryWithPhoneCode>? get countries => _countries;

  set countries(List<CountryWithPhoneCode>? value) {
    _countries = value;
    notifyListeners();
  }

  void filter(String filter) {
    countries = _initialCountries;
    if (filter.isNotEmpty) {
      var filteredCountries = countries!
          .where(
              (element) => element.countryName!.toLowerCase().contains(filter))
          .toList();
      countries = filteredCountries;
    }
  }
}

class PhoneRegistrationData with ChangeNotifier {
  String? _phoneNumber;
  CountryWithPhoneCode? _country;
  bool _sendingSms = false;

  String? get phoneNumber => _phoneNumber;

  set phoneNumber(String? value) {
    _phoneNumber = FlutterLibphonenumber().formatNumberSync(value!,
        country: country!,
        removeCountryCodeFromResult: false,
        phoneNumberFormat: PhoneNumberFormat.national);
    notifyListeners();
  }

  CountryWithPhoneCode? get country => _country;

  set country(CountryWithPhoneCode? value) {
    _country = value;
    notifyListeners();
  }

  bool get sendingSms => _sendingSms;

  set sendingSms(bool value) {
    _sendingSms = value;
    notifyListeners();
  }

  bool isPhoneNumberEmpty() {
    return _phoneNumber == null || _phoneNumber == '';
  }

  String getFormattedCountryName() {
    return '${country?.countryName} (+${country?.phoneCode})';
  }

  String getCompactFormattedCountryName() {
    return '${country?.countryCode} (+${country?.phoneCode})';
  }

  Future<Map<String, CountryWithPhoneCode>> getAllRegions() async {
    await FlutterLibphonenumber().init();
    return FlutterLibphonenumber().getAllSupportedRegions();
  }

  Future<String> formatPhoneNumberToE164() async {
    try {
      var result = await FlutterLibphonenumber()
          .parse(phoneNumber!, region: country!.countryCode);
      return result['e164'];
    } on PlatformException {
      throw CustomException('invalid-phone-number');
    }
  }
}
