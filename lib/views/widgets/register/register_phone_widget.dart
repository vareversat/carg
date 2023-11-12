import 'dart:io' show Platform;

import 'package:carg/exceptions/custom_exception.dart';
import 'package:carg/services/auth/auth_service.dart';
import 'package:carg/styles/custom_properties.dart';
import 'package:carg/views/helpers/info_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:provider/provider.dart';

class RegisterPhoneWidget extends StatefulWidget {
  final CredentialVerificationType credentialVerificationType;

  const RegisterPhoneWidget({
    super.key,
    required this.credentialVerificationType,
  });

  @override
  State<StatefulWidget> createState() {
    return _RegisterPhoneWidgetState();
  }
}

class _RegisterPhoneWidgetState extends State<RegisterPhoneWidget>
    with TickerProviderStateMixin {
  Future<CountryWithPhoneCode?> showCountriesDialog(
    Map<String, CountryWithPhoneCode> values,
  ) async {
    var countryList = CountryList(
      List.of(
        values.values,
      ),
    );

    return showDialog<CountryWithPhoneCode>(
      context: context,
      builder: (BuildContext context) => ChangeNotifierProvider.value(
        value: countryList,
        child: Consumer<CountryList>(
          builder: (context, countryListData, _) => SimpleDialog(
            contentPadding: const EdgeInsets.all(24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            children: <Widget>[
              TextField(
                autofillHints: const [AutofillHints.telephoneNumberNational],
                onChanged: (value) {
                  countryListData.filter(value);
                },
                decoration: InputDecoration(
                  labelText: '${AppLocalizations.of(context)!.search}...',
                ),
                textInputAction: TextInputAction.search,
              ),
              SizedBox(
                height: 300,
                width: 600,
                child: ListView.builder(
                  itemCount: countryListData.countries!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          countryListData.countries![index],
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: countryListData.countries![index].countryName,
                          style: Theme.of(context).textTheme.bodyLarge,
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  ' (${countryListData.countries![index].countryCode}',
                            ),
                            TextSpan(
                              text:
                                  ' +${countryListData.countries![index].phoneCode})',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context)!
                      .country(countryListData.countries!.length),
                  style: const TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _sendPinCode(PhoneRegistrationData phoneRegistrationData) async {
    try {
      phoneRegistrationData.sendingSms = true;
      await phoneRegistrationData.formatPhoneNumberToE164().then(
            (phoneNumber) async =>
                await Provider.of<AuthService>(context, listen: false)
                    .sendPhoneVerificationCode(
              phoneNumber,
              context,
              widget.credentialVerificationType,
            ),
          );
    } on CustomException catch (e) {
      InfoSnackBar.showSnackBar(context, e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: PhoneRegistrationData(),
      child: Consumer<PhoneRegistrationData>(
        builder: (context, phoneRegistrationData, _) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<Map<String, CountryWithPhoneCode>>(
            future: phoneRegistrationData.getAllRegions(),
            builder: (context, snapshot) {
              return Column(
                children: [
                  Row(
                    children: [
                      AnimatedSize(
                        key: const ValueKey('placeholderPhoneContainer'),
                        curve: Curves.ease,
                        duration: const Duration(milliseconds: 500),
                        child: phoneRegistrationData.sendingSms
                            ? const CircularProgressIndicator(strokeWidth: 5)
                            : ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    Theme.of(context).cardColor,
                                  ),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                    primaryColor,
                                  ),
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 2,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        CustomProperties.borderRadius,
                                      ),
                                    ),
                                  ),
                                ),
                                //ignore: avoid-passing-async-when-sync-expected
                                onPressed: snapshot.connectionState ==
                                        ConnectionState.done
                                    ? () async {
                                        phoneRegistrationData.country =
                                            await showCountriesDialog(
                                          snapshot.data!,
                                        );
                                      }
                                    : null,
                                child: AnimatedSize(
                                  curve: Curves.linear,
                                  duration: const Duration(milliseconds: 300),
                                  child: Text(
                                    phoneRegistrationData.country != null
                                        ? phoneRegistrationData
                                            .getCompactFormattedCountryName()
                                        : AppLocalizations.of(context)!
                                            .country(0),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(width: 15),
                      Flexible(
                        child: TextField(
                          textInputAction: TextInputAction.go,
                          enabled: phoneRegistrationData.country != null,
                          onSubmitted: (value) {
                            if (!phoneRegistrationData.isPhoneNumberEmpty()) {
                              _sendPinCode(phoneRegistrationData);
                            }
                          },
                          onChanged: (value) {
                            phoneRegistrationData.phoneNumber = value;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.normal,
                            ),
                            labelText: (phoneRegistrationData.country == null
                                ? ''
                                : ' ${AppLocalizations.of(context)!.example} : ${phoneRegistrationData.country?.exampleNumberMobileNational}'),
                            fillColor: primaryColor,
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                CustomProperties.borderRadius,
                              ),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                CustomProperties.borderRadius,
                              ),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                CustomProperties.borderRadius,
                              ),
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.messageSmsInfo,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 13,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CountryList with ChangeNotifier {
  List<CountryWithPhoneCode>? _countries;
  late List<CountryWithPhoneCode> _suggestedCountries;
  List<CountryWithPhoneCode>? _initialCountries;

  CountryList(this._countries) {
    // Order countries
    _countries = _countries!
      ..sort((a, b) => a.countryName!.compareTo(b.countryName!));
    _suggestedCountries = _extractSuggestedCountry();
    if (_suggestedCountries.length == 1) {
      _countries?.remove(_suggestedCountries[0]);
      _countries?.insert(0, _suggestedCountries[0]);
    }
    _initialCountries = _countries;
  }

  List<CountryWithPhoneCode>? get countries => _countries;

  set countries(List<CountryWithPhoneCode>? value) {
    _countries = value;
    notifyListeners();
  }

  List<CountryWithPhoneCode> _extractSuggestedCountry() {
    String deviceCountry = Platform.localeName.substring(3, 5);

    return _countries!
        .where((element) => element.countryCode == deviceCountry)
        .toList();
  }

  void filter(String filter) {
    countries = _initialCountries;
    if (filter.isNotEmpty) {
      var filteredCountries = countries!
          .where((element) => element.countryName!.contains(filter))
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
    _phoneNumber = formatNumberSync(
      value!,
      country: country!,
      removeCountryCodeFromResult: false,
      phoneNumberFormat: PhoneNumberFormat.national,
    );
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
    await init();

    return getAllSupportedRegions();
  }

  Future<String> formatPhoneNumberToE164() async {
    try {
      var result = await parse(phoneNumber!, region: country!.countryCode);

      return result['e164'];
    } on PlatformException {
      throw CustomException('invalid-phone-number');
    }
  }
}
