part of '../../boxes.dart';

extension GeneralSettings on SettingsBox {

  bool get hasFinishedOnboarding {
    return box.get(
      BoxKeys.hasFinishedOnboarding,
      defaultValue: false,
    );
  }

  set hasFinishedOnboarding(bool value) {
    box.put(BoxKeys.hasFinishedOnboarding, value);
  }

  bool? get isDarkTheme {
    return box.get(
      BoxKeys.isDarkTheme,
    );
  }

  set isDarkTheme(bool? value) {
    if (value == null) {
      box.delete(BoxKeys.isDarkTheme);
      return;
    }
    box.put(BoxKeys.isDarkTheme, value);
  }

  int get popupBannerLastUpdatedTime {
    return box.get(
      BoxKeys.popupBannerLastUpdatedTime,
      defaultValue: 0,
    );
  }

  set popupBannerLastUpdatedTime(int value) {
    box.put(BoxKeys.popupBannerLastUpdatedTime, value);
  }
  ///address
  List<Address>? get addresses {
    final rawData = box.get(
      BoxKeys.addresses,
      defaultValue: null,
    );
    // return rawData != null && rawData is List<Map>
    return rawData != null && rawData is List
        ? List<Address>.from(
      rawData.map((e) => Address.fromLocalJson(e)),
    )
        : null;
  }

  set addresses(List<Address>? value) {
    if (value == null) {
      box.delete(BoxKeys.addresses);
      return;
    }
    final rawData = value.map((e) => e.toJsonEncodable()).toList();
    box.put(BoxKeys.addresses, rawData);
  }
}
