import 'package:flutter/material.dart';

import 'theme_helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodyLargeBlack900 => theme.textTheme.bodyLarge!.copyWith(
        color: appTheme.black900,
      );
  static get bodyLargePrimary => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get bodyLargeSecondaryContainer => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.secondaryContainer,
      );
  static get bodyLargeff083344 => theme.textTheme.bodyLarge!.copyWith(
        color: Color(0XFF083344),
        fontSize: 18,
      );
  static get bodyLargeff0e7490 => theme.textTheme.bodyLarge!.copyWith(
        color: Color(0XFF0E7490),
      );
  static get bodyLargeff454b60 => theme.textTheme.bodyLarge!.copyWith(
        color: Color(0XFF454B60),
      );
  static get bodyMediumBluegray400 => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray400,
      );
  static get bodyMediumPrimaryContainer => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
      );
  static get bodyMediumSecondaryContainer =>
      theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.secondaryContainer,
      );
  static get bodyMediumff083344 => theme.textTheme.bodyMedium!.copyWith(
        color: Color(0XFF083344),
      );
  static get bodyMediumff454b60 => theme.textTheme.bodyMedium!.copyWith(
        color: Color(0XFF454B60),
      );
  static get bodyMediumffea5b5b => theme.textTheme.bodyMedium!.copyWith(
        color: Color(0XFFEA5B5B),
      );
  static get bodySmall11 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 11,
      );
  static get bodySmall9 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 9,
      );
  static get bodySmallBlack900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900.withOpacity(0.2),
      );
  static get bodySmallBlack900_1 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.black900,
      );
  static get bodySmallGray500 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray500,
      );
  static get bodySmallGray5002 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray5002,
      );
  static get bodySmallGray600 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray600,
      );
  static get bodySmallOnError => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onError,
      );
  static get bodySmallPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get bodySmallPrimaryContainer => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
      );
  static get bodySmallRed400 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.red400,
      );
  static get bodySmallTeal900 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.teal900,
      );
  static get bodySmallff888888 => theme.textTheme.bodySmall!.copyWith(
        color: Color(0XFF888888),
      );
  // Label text style
  static get labelLargeBluegray400 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray400,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeBluegray400_1 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray400,
      );
  static get labelLargePrimary => theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
  static get labelLargePrimaryBold => theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );
  static get labelLargePrimaryContainer => theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
      );
  static get labelLargePrimary_1 => theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get labelLargeff888888 => theme.textTheme.labelLarge!.copyWith(
        color: Color(0XFF888888),
        fontWeight: FontWeight.w600,
      );
  // Title text style
  static get titleLarge22 => theme.textTheme.titleLarge!.copyWith(
        fontSize: 22,
      );
  static get titleLargePrimary => theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 22,
      );
  static get titleLargeRegular => theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w400,
      );
  static get titleLargeSecondaryContainer =>
      theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.secondaryContainer,
        fontWeight: FontWeight.w400,
      );
  static get titleLargeSecondaryContainer22 =>
      theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.secondaryContainer,
        fontSize: 22,
      );
  static get titleLargeff083344 => theme.textTheme.titleLarge!.copyWith(
        color: Color(0XFF083344),
        fontWeight: FontWeight.w400,
      );
  static get titleLargeff083344Bold => theme.textTheme.titleLarge!.copyWith(
        color: Color(0XFF083344),
        fontWeight: FontWeight.w700,
      );
  static get titleMedium18 => theme.textTheme.titleMedium!.copyWith(
        fontSize: 18,
      );
  static get titleMediumBlue50 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.blue50,
      );
  static get titleMediumGray5002 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray5002,
      );
  static get titleMediumMedium => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.w500,
      );
  static get titleMediumOnPrimaryContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 18,
      );
  static get titleMediumOnPrimaryContainer_1 =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );
  static get titleMediumPrimary => theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get titleMediumPrimaryContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
      );
  static get titleMediumRed400 => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.red400,
      );
  static get titleMediumff083344 => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF083344),
        fontWeight: FontWeight.w500,
      );
  static get titleMediumff083344_1 => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFF083344),
      );
  static get titleMediumffea5b5b => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFFEA5B5B),
        fontWeight: FontWeight.w500,
      );
  static get titleMediumffea5b5b_1 => theme.textTheme.titleMedium!.copyWith(
        color: Color(0XFFEA5B5B),
      );
  static get titleSmallBlue50 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.blue50,
      );
  static get titleSmallInterPrimaryContainer =>
      theme.textTheme.titleSmall!.inter.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
      );
  static get titleSmallOnPrimaryContainer =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
      );
  static get titleSmallPrimaryContainer => theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
      );
  static get titleSmallSemiBold => theme.textTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.w600,
      );
  static get titleSmallTeal900 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.teal900,
      );
  static get titleSmallff083344 => theme.textTheme.titleSmall!.copyWith(
        color: Color(0XFF083344),
      );
  static get titleSmallff0e7490 => theme.textTheme.titleSmall!.copyWith(
        color: Color(0XFF0E7490),
      );
  static get bodyMediumOnPrimary => theme.textTheme.bodyMedium!.copyWith(
        color: appTheme.blueGray400,
      );
  static get bodySmallOnPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimary,
      );
}

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }
}
