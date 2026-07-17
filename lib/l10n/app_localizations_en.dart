// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EL7OUT';

  @override
  String get guestModeBanner => 'Continue as guest';

  @override
  String get signInToContinue => 'Welcome back. Sign in to continue.';

  @override
  String get signInSubtitle =>
      'Your bag is saved. Sign in or create an account to complete your purchase.';

  @override
  String get completeYourOrder => 'Complete your order';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full name';

  @override
  String get signIn => 'Sign in';

  @override
  String get register => 'Register';

  @override
  String get createAccount => 'Create account';

  @override
  String get signInAndContinue => 'Sign in and continue';

  @override
  String get createAccountAction => 'Create account';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get home => 'Home';

  @override
  String get shop => 'Shop';

  @override
  String get saved => 'Saved';

  @override
  String get bag => 'Bag';

  @override
  String get account => 'Account';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get orders => 'Orders';

  @override
  String get wishlist => 'Wishlist';

  @override
  String get cart => 'Cart';

  @override
  String get checkout => 'Checkout';

  @override
  String get search => 'Search';

  @override
  String get newArrivals => 'New arrivals';

  @override
  String get exploreCollection => 'Explore collection';

  @override
  String get viewAll => 'View all';

  @override
  String get shopNow => 'Shop now';

  @override
  String get explore => 'Explore';

  @override
  String get myBag => 'My bag';

  @override
  String myBagCount(int count) {
    return 'My bag ($count)';
  }

  @override
  String get emptyWishlist => 'Your saved list is empty';

  @override
  String get emptyWishlistSubtitle => 'Save items you love for later.';

  @override
  String get emptyCart => 'Your bag is empty';

  @override
  String get emptyCartSubtitle => 'Add items to your bag to continue.';

  @override
  String get emptyNotifications => 'No notifications';

  @override
  String get emptyOrders => 'No orders yet';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get theme => 'Theme';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get system => 'System';

  @override
  String get currency => 'Currency';

  @override
  String get pushNotifications => 'Push notifications';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get selectCurrency => 'Select currency';

  @override
  String get selectTheme => 'Select theme';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get appearance => 'Appearance';

  @override
  String get preferences => 'Preferences';

  @override
  String get about => 'About';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get terms => 'Terms';

  @override
  String get termsOfService => 'Terms of service';

  @override
  String get contactUs => 'Contact us';

  @override
  String get version => 'Version';

  @override
  String get logout => 'Logout';

  @override
  String get signOut => 'Sign out';

  @override
  String get retry => 'Retry';

  @override
  String get required => 'Required';

  @override
  String get validEmail => 'Enter a valid email';

  @override
  String get passwordLength => 'Minimum 6 characters';

  @override
  String get nameLength => 'Enter your name';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get loading => 'Loading';

  @override
  String get networkError => 'Network error. Please try again.';

  @override
  String get orderSummary => 'Order summary';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get shipping => 'Shipping';

  @override
  String get total => 'Total';

  @override
  String get free => 'Free';

  @override
  String get secureCheckout => 'Secure checkout';

  @override
  String get proceedToCheckout => 'Proceed to checkout';

  @override
  String addForFreeShipping(String amount) {
    return 'Add $amount for free shipping';
  }

  @override
  String get continueShopping => 'Continue shopping';

  @override
  String get placeOrder => 'Place order';

  @override
  String get viewOrders => 'View orders';

  @override
  String get orderPlaced => 'Order placed!';

  @override
  String get orderPlacedMessage => 'Thank you! Your order has been confirmed.';

  @override
  String orderPlacedWithId(String id) {
    return 'Thank you! Your order #$id has been confirmed.';
  }

  @override
  String get startShopping => 'Start shopping';

  @override
  String get orderDetails => 'Order details';

  @override
  String get orderNotFound => 'Order not found.';

  @override
  String get items => 'Items';

  @override
  String get shippingTo => 'Shipping to';

  @override
  String get paymentSummary => 'Payment summary';

  @override
  String get orderCancelled => 'Order cancelled';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'No items',
    );
    return '$_temp0';
  }

  @override
  String get placed => 'Placed';

  @override
  String get pending => 'Pending';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get processing => 'Processing';

  @override
  String get shipped => 'Shipped';

  @override
  String get delivered => 'Delivered';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get addressLine1 => 'Address line 1';

  @override
  String get addressLine2 => 'Address line 2 (optional)';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get postalCode => 'Postal code';

  @override
  String get country => 'Country';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phoneNumberError => 'Enter a valid phone number';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get cashOnDelivery => 'Cash on delivery';

  @override
  String get card => 'Card';

  @override
  String get guestProfileTitle => 'You are browsing as a guest';

  @override
  String get guestProfileSubtitle =>
      'Sign in to access your orders, wishlist, and personalized recommendations.';

  @override
  String get myOrders => 'My orders';

  @override
  String get addresses => 'Addresses';

  @override
  String get paymentMethods => 'Payment methods';

  @override
  String get payment => 'Payment';

  @override
  String get memberBadge => 'EL7OUT member';

  @override
  String get trackAndManage => 'Track & manage';

  @override
  String get savedItems => 'Saved items';

  @override
  String get updatesAndOffers => 'Updates & offers';

  @override
  String get shippingInfo => 'Shipping info';

  @override
  String get cardsAndMethods => 'Cards & methods';

  @override
  String get appPreferences => 'App preferences';

  @override
  String get signInButton => 'Sign in';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get searchHint => 'Search brands, products, styles...';

  @override
  String get recentSearches => 'Recent searches';

  @override
  String get popularSearches => 'Popular searches';

  @override
  String get trendingSearches => 'Trending searches';

  @override
  String get noResults => 'No results found';

  @override
  String noResultsFor(String query) {
    return 'No results for \"$query\"';
  }

  @override
  String get tryDifferentKeywords =>
      'Try different keywords or browse our categories.';

  @override
  String get categories => 'Categories';

  @override
  String get productNotFound => 'Product not found.';

  @override
  String get addedToBag => 'Added to your bag';

  @override
  String get viewBag => 'View bag';

  @override
  String get color => 'Color';

  @override
  String get size => 'Size';

  @override
  String get outOfStock => 'Out of stock';

  @override
  String get addToBag => 'Add to bag';

  @override
  String get readMore => 'Read more';

  @override
  String get showLess => 'Show less';

  @override
  String get reviews => 'Reviews';

  @override
  String get sizeGuide => 'Size guide';

  @override
  String get freeReturns => 'Free returns';

  @override
  String get authentic => 'Authentic';

  @override
  String get securePay => 'Secure pay';

  @override
  String itemDetails(String size, String color, int quantity) {
    return '$size · $color · x$quantity';
  }

  @override
  String itemsLabel(int count) {
    return '$count items';
  }

  @override
  String get today => 'Today';

  @override
  String get justNow => 'Just now';

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }
}
