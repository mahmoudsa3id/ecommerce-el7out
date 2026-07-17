// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'EL7OUT';

  @override
  String get guestModeBanner => 'المتابعة كضيف';

  @override
  String get signInToContinue => 'مرحبًا بعودتك. سجل الدخول للمتابعة.';

  @override
  String get signInSubtitle =>
      'حقيبتك محفوظة. سجل الدخول أو أنشئ حسابًا لإكمال الشراء.';

  @override
  String get completeYourOrder => 'أكمل طلبك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get fullName => 'الاسم بالكامل';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get register => 'إنشاء حساب';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get signInAndContinue => 'تسجيل الدخول والمتابعة';

  @override
  String get createAccountAction => 'إنشاء حساب';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get home => 'الرئيسية';

  @override
  String get shop => 'المتجر';

  @override
  String get saved => 'المحفوظات';

  @override
  String get bag => 'الحقيبة';

  @override
  String get account => 'الحساب';

  @override
  String get settings => 'الإعدادات';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get orders => 'الطلبات';

  @override
  String get wishlist => 'المفضلة';

  @override
  String get cart => 'السلة';

  @override
  String get checkout => 'إتمام الطلب';

  @override
  String get search => 'بحث';

  @override
  String get newArrivals => 'وصل حديثًا';

  @override
  String get exploreCollection => 'استكشف المجموعة';

  @override
  String get viewAll => 'عرض الكل';

  @override
  String get shopNow => 'تسوق الآن';

  @override
  String get explore => 'استكشف';

  @override
  String get myBag => 'حقيبتي';

  @override
  String myBagCount(int count) {
    return 'حقيبتي ($count)';
  }

  @override
  String get emptyWishlist => 'قائمة المحفوظات فارغة';

  @override
  String get emptyWishlistSubtitle => 'احفظ المنتجات التي تحبها لوقت لاحق.';

  @override
  String get emptyCart => 'حقيبتك فارغة';

  @override
  String get emptyCartSubtitle => 'أضف منتجات إلى حقيبتك للمتابعة.';

  @override
  String get emptyNotifications => 'لا توجد إشعارات';

  @override
  String get emptyOrders => 'لا توجد طلبات بعد';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get theme => 'المظهر';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get system => 'النظام';

  @override
  String get currency => 'العملة';

  @override
  String get pushNotifications => 'الإشعارات';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get selectCurrency => 'اختر العملة';

  @override
  String get selectTheme => 'اختر المظهر';

  @override
  String get arabic => 'العربية';

  @override
  String get english => 'الإنجليزية';

  @override
  String get appearance => 'المظهر';

  @override
  String get preferences => 'التفضيلات';

  @override
  String get about => 'حول التطبيق';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get terms => 'الشروط';

  @override
  String get termsOfService => 'شروط الخدمة';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get version => 'الإصدار';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get required => 'مطلوب';

  @override
  String get validEmail => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get passwordLength => 'الحد الأدنى 6 أحرف';

  @override
  String get nameLength => 'أدخل اسمك';

  @override
  String get close => 'إغلاق';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get ok => 'موافق';

  @override
  String get loading => 'جاري التحميل';

  @override
  String get networkError => 'حدث خطأ في الاتصال. حاول مرة أخرى.';

  @override
  String get orderSummary => 'ملخص الطلب';

  @override
  String get subtotal => 'المجموع الفرعي';

  @override
  String get shipping => 'الشحن';

  @override
  String get total => 'الإجمالي';

  @override
  String get free => 'مجاني';

  @override
  String get secureCheckout => 'دفع آمن';

  @override
  String get proceedToCheckout => 'المتابعة للدفع';

  @override
  String addForFreeShipping(String amount) {
    return 'أضف $amount للحصول على شحن مجاني';
  }

  @override
  String get continueShopping => 'متابعة التسوق';

  @override
  String get placeOrder => 'تأكيد الطلب';

  @override
  String get viewOrders => 'عرض الطلبات';

  @override
  String get orderPlaced => 'تم تأكيد الطلب!';

  @override
  String get orderPlacedMessage => 'شكرًا لك! تم تأكيد طلبك.';

  @override
  String orderPlacedWithId(String id) {
    return 'شكرًا لك! تم تأكيد طلبك رقم $id.';
  }

  @override
  String get startShopping => 'ابدأ التسوق';

  @override
  String get orderDetails => 'تفاصيل الطلب';

  @override
  String get orderNotFound => 'لم يتم العثور على الطلب.';

  @override
  String get items => 'المنتجات';

  @override
  String get shippingTo => 'الشحن إلى';

  @override
  String get paymentSummary => 'ملخص الدفع';

  @override
  String get orderCancelled => 'تم إلغاء الطلب';

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count منتج',
      many: '$count منتجًا',
      few: '$count منتجات',
      two: 'منتجان',
      one: 'منتج واحد',
      zero: 'لا توجد منتجات',
    );
    return '$_temp0';
  }

  @override
  String get placed => 'تم الطلب';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get confirmed => 'تم التأكيد';

  @override
  String get processing => 'قيد التجهيز';

  @override
  String get shipped => 'تم الشحن';

  @override
  String get delivered => 'تم التسليم';

  @override
  String get cancelled => 'ملغي';

  @override
  String get addressLine1 => 'العنوان الأول';

  @override
  String get addressLine2 => 'العنوان الثاني (اختياري)';

  @override
  String get city => 'المدينة';

  @override
  String get state => 'المحافظة';

  @override
  String get postalCode => 'الرمز البريدي';

  @override
  String get country => 'الدولة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get phoneNumberError => 'أدخل رقم هاتف صحيح';

  @override
  String get paymentMethod => 'طريقة الدفع';

  @override
  String get cashOnDelivery => 'الدفع عند الاستلام';

  @override
  String get card => 'بطاقة';

  @override
  String get guestProfileTitle => 'أنت تتصفح كضيف';

  @override
  String get guestProfileSubtitle =>
      'سجل الدخول للوصول إلى طلباتك والمفضلة والتوصيات الشخصية.';

  @override
  String get myOrders => 'طلباتي';

  @override
  String get addresses => 'العناوين';

  @override
  String get paymentMethods => 'طرق الدفع';

  @override
  String get payment => 'الدفع';

  @override
  String get memberBadge => 'عضو EL7OUT';

  @override
  String get trackAndManage => 'تتبع وإدارة';

  @override
  String get savedItems => 'العناصر المحفوظة';

  @override
  String get updatesAndOffers => 'تحديثات وعروض';

  @override
  String get shippingInfo => 'بيانات الشحن';

  @override
  String get cardsAndMethods => 'البطاقات والطرق';

  @override
  String get appPreferences => 'تفضيلات التطبيق';

  @override
  String get signInButton => 'تسجيل الدخول';

  @override
  String get createAccountButton => 'إنشاء حساب';

  @override
  String get searchHint => 'ابحث عن ماركات أو منتجات أو ستايلات...';

  @override
  String get recentSearches => 'عمليات البحث الأخيرة';

  @override
  String get popularSearches => 'الأكثر بحثًا';

  @override
  String get trendingSearches => 'عمليات البحث الرائجة';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String noResultsFor(String query) {
    return 'لا توجد نتائج لـ \"$query\"';
  }

  @override
  String get tryDifferentKeywords => 'جرّب كلمات مختلفة أو تصفح الأقسام.';

  @override
  String get categories => 'الأقسام';

  @override
  String get productNotFound => 'لم يتم العثور على المنتج.';

  @override
  String get addedToBag => 'تمت الإضافة إلى الحقيبة';

  @override
  String get viewBag => 'عرض الحقيبة';

  @override
  String get color => 'اللون';

  @override
  String get size => 'المقاس';

  @override
  String get outOfStock => 'غير متوفر';

  @override
  String get addToBag => 'أضف إلى الحقيبة';

  @override
  String get readMore => 'اقرأ المزيد';

  @override
  String get showLess => 'عرض أقل';

  @override
  String get reviews => 'التقييمات';

  @override
  String get sizeGuide => 'دليل المقاسات';

  @override
  String get freeReturns => 'إرجاع مجاني';

  @override
  String get authentic => 'أصلي';

  @override
  String get securePay => 'دفع آمن';

  @override
  String itemDetails(String size, String color, int quantity) {
    return '$size · $color · ×$quantity';
  }

  @override
  String itemsLabel(int count) {
    return '$count منتج';
  }

  @override
  String get today => 'اليوم';

  @override
  String get justNow => 'الآن';

  @override
  String daysAgo(int count) {
    return 'منذ $count يوم';
  }

  @override
  String hoursAgo(int count) {
    return 'منذ $count ساعة';
  }

  @override
  String minutesAgo(int count) {
    return 'منذ $count دقيقة';
  }
}
