import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:flutter/material.dart';
import 'Config/settings.dart';

////////////////////////////////////////////
// Widget for all Theme related Settings (submenu)
////////////////////////////////////////////
class ThemeSettingsWidget extends StatefulWidget {
  final Function() onThemeChanged;

  const ThemeSettingsWidget({
    required Key key,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  ThemeSettingsWidgetState createState() => ThemeSettingsWidgetState();
}

class ThemeSettingsWidgetState extends State<ThemeSettingsWidget> {
  final double _textFontSize = 24;
  var _currentTheme = appCurrentTheme;
  late PageController _pageController;

  // Indicates what page the user is currently looking at
  var _currentPageIndex;

  // This indicates which Image Asset should be highlighted
  String? assetForSelectedThemeAndMode;

  // Bools to track Unlocks
  bool _blueJayThemeUnlocked = false;
  bool _bubblegumThemeUnlocked = false;
  bool _pumpkinThemeUnlocked = false;

  // Bools used to Filtering Functions
  late int _totalThemeCount;
  late int _unlockedThemeCount;
  bool _filterShowsAllThemes = true;
  late List<Widget> pages;

  void _updateAppTheme(String? theme) {
    if (theme != null) {
      if (themesPurchasedMap[theme] == true) {
        setState(() {
          _currentTheme = theme;
          appCurrentTheme = theme;
          setStringSetting('appTheme', theme);
          setupAppTheme(theme);
          widget.onThemeChanged();
          assetForSelectedThemeAndMode = _determineAssetForCurrentTheme();
          _filterShowsAllThemes ? initializeThemePages() : setThemePagesToUnlockedOnly();
        });
      } else {
        String productId = getProductIdFromTheme(theme);
        if (productId.isNotEmpty) {
          _launchStoreStuff(productId);
        } else {
          _showAppPurchaseNotification(context, "Something went wrong.");
        }
      }
    }
  }

  int _determineCurrentPageIndex() {
    if (_filterShowsAllThemes) {
      switch (appCurrentTheme){
        case 'Default':
          return 0;
        case 'BlueJay':
          return 1;
        case 'Bubblegum':
          return 2;
        case 'Pumpkin':
          return 3;
      }
    } else {
      // The user is filtering themes
      int index = 0;
      switch (appCurrentTheme){
        case 'Default':
          return index;
        case 'BlueJay':
          return index+1;
        case 'Bubblegum':
          _blueJayThemeUnlocked ? index++ : null;
          return index+1;
        case 'Pumpkin':
          _blueJayThemeUnlocked ? index++ : null;
          _bubblegumThemeUnlocked ? index++ : null;
          return index+1;
      }
    }

    return 0;
  }

  // This is called from the listener in main.dart
  void updateThemeUIAfterPurchaseCompleted(){
    setState(() {
      _blueJayThemeUnlocked = themesPurchasedMap['BlueJay']!;
      _bubblegumThemeUnlocked = themesPurchasedMap['Bubblegum']!;
      _pumpkinThemeUnlocked = themesPurchasedMap['Pumpkin']!;
      _unlockedThemeCount = 1 + (_blueJayThemeUnlocked ? 1 : 0)
          + (_bubblegumThemeUnlocked ? 1 : 0)
          + (_pumpkinThemeUnlocked ? 1 : 0);
      _filterShowsAllThemes ? initializeThemePages() : setThemePagesToUnlockedOnly();
    });
  }

  String _determineAssetForCurrentTheme() {
    switch (appCurrentTheme){
      case 'Default':
        if (appCurrentlyInDarkMode) {
          return 'assets/images/DefaultDark.png';
        }
        return 'assets/images/DefaultLight.png';
      case 'BlueJay':
        if (appCurrentlyInDarkMode) {
          return 'assets/images/BlueJayDark.png';
        }
        return 'assets/images/BlueJayLight.png';
      case 'Bubblegum':
        if (appCurrentlyInDarkMode) {
          return 'assets/images/BubbleGumDark.png';
        }
        return 'assets/images/BubbleGumLight.png';
      case 'Pumpkin':
        if (appCurrentlyInDarkMode) {
          return 'assets/images/PumpkinDark.png';
        }
        return 'assets/images/PumpkinLight.png';
    }
    return '';
  }

  // Used for In-App purchases
  void _showAppPurchaseNotification(BuildContext context, String content) {
    final snackBar = SnackBar(
      backgroundColor: primaryColor,
      content: Container(
          height: 33,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(content,
                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 13,
                      color: secondaryColor,
                    )
                ),
              ])
      ),

      duration: Duration(seconds: 2), // Set the duration for how long the SnackBar will be displayed
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Used for In-App purchases
  _launchStoreStuff(String productId) async {
    var storeAvailable = await inAppPurchase.isAvailable();

    if (storeAvailable) {
      if (availableProducts.length == 0) {
        // Products did not load on initial launch, try again.
        final ProductDetailsResponse productDetailsResponse = await inAppPurchase.queryProductDetails(productIds);
        if (productDetailsResponse.notFoundIDs.isNotEmpty) {
          // TODO Handle the error.
          _showAppPurchaseNotification(context, "No products found.");
          return;
        }
        if (productDetailsResponse.error == null) {
          // No errors found setup products from store
          setState(() {
            // This variable is set in settings.dart
            availableProducts = productDetailsResponse.productDetails;
          });
        }
      }

      _buyInAppProduct(productId);
    } else {
      // Store is Not available
      _showAppPurchaseNotification(context, "Store not currently available");
    }
  }

  // Used for In-App purchases
  _buyInAppProduct(String productId) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: availableProducts.firstWhere((element) => element.id == productId));
    bool isSuccess = await inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

    if (isSuccess) {
      // Handle successful purchase
    } else {
      // Handle failed purchase
      _showAppPurchaseNotification(context, "Purchase was not successful");
    }
  }

  @override
  void initState() {
    super.initState();
    _currentPageIndex = _determineCurrentPageIndex();
    assetForSelectedThemeAndMode = _determineAssetForCurrentTheme();
    _pageController = PageController(initialPage: _currentPageIndex);
    _blueJayThemeUnlocked = themesPurchasedMap['BlueJay']!;
    _bubblegumThemeUnlocked = themesPurchasedMap['Bubblegum']!;
    _pumpkinThemeUnlocked = themesPurchasedMap['Pumpkin']!;
    _totalThemeCount = themesPurchasedMapDefault.length;
    _unlockedThemeCount = 1 + (_blueJayThemeUnlocked ? 1 : 0)
        + (_bubblegumThemeUnlocked ? 1 : 0)
        + (_pumpkinThemeUnlocked ? 1 : 0);
    initializeThemePages();
  }

  void initializeThemePages() {
    setState(() {
      pages = [
        getDefaultThemePage(),
        getBlueJayThemePage(),
        getBubblegumThemePage(),
        getPumpkinThemePage(),
      ];
    });
  }

  // Used to remove the filter on what Themes are shown
  void setThemePagesToAll() {
    initializeThemePages();
    setState(() {
      _currentPageIndex = _determineCurrentPageIndex();
    });

    _pageController.animateToPage(
      _currentPageIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Used to add a filter to the Themes widget, only showing unlocked/purchased Themes
  void setThemePagesToUnlockedOnly() {
    setState(() {
      pages = [
        getDefaultThemePage(),
      ];
      _blueJayThemeUnlocked ? pages.add(getBlueJayThemePage()) : null;
      _bubblegumThemeUnlocked ? pages.add(getBubblegumThemePage()) : null;
      _pumpkinThemeUnlocked ? pages.add(getPumpkinThemePage()) : null;
      _currentPageIndex = _determineCurrentPageIndex();

      _pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Widget getDefaultThemePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Default Dark
              GestureDetector(
                onTap: () {
                  setState((){
                    setBooleanSetting('appInDarkMode', true);
                    setupDarkOrLightMode(true);
                    _updateAppTheme('Default');
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: assetForSelectedThemeAndMode == 'assets/images/DefaultDark.png'
                                ? Colors.blue
                                : Colors.transparent
                        )
                    ),
                    child: Image.asset('assets/images/DefaultDark.png', width: 140, height: 240)
                ),
              ),

              // Default Light
              GestureDetector(
                onTap: () {
                  setState((){
                    setBooleanSetting('appInDarkMode', false);
                    setupDarkOrLightMode(false);
                    _updateAppTheme('Default');
                  });
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: assetForSelectedThemeAndMode == 'assets/images/DefaultLight.png'
                                ? Colors.blue
                                : Colors.transparent
                        )
                    ),
                    child: Image.asset('assets/images/DefaultLight.png', width: 140, height: 240)
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Radio Tile
          Container(
              width: 220,
              child: Material(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RadioListTile(
                    title: Text(
                      'Default',
                      style: TextStyle(
                          color: appCurrentlyInDarkMode
                              ? Colors.black
                              : Colors.white,
                          fontSize: _textFontSize),
                    ),
                    tileColor: Colors.blueGrey,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    value: 'Default',
                    groupValue: _currentTheme,
                    onChanged: _updateAppTheme,
                  )
              )
          )
        ],
      ),
    );
  }

  Widget getBlueJayThemePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [
            // BlueJay Dark
            GestureDetector(
              onTap: () {
                setState((){
                  if (_blueJayThemeUnlocked) {
                    setBooleanSetting('appInDarkMode', true);
                    setupDarkOrLightMode(true);
                    _updateAppTheme('BlueJay');
                  } else {
                    // Logic to launch store for In app Purchase
                    _launchStoreStuff('bluejay_theme');
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 4,
                        color: assetForSelectedThemeAndMode == 'assets/images/BlueJayDark.png'
                            ? Colors.blue
                            : Colors.transparent
                    )
                ),
                child: Image.asset('assets/images/BlueJayDark.png', width: 140, height: 240),
              ),
            ),

            // BlueJay Light
            GestureDetector(
              onTap: () {
                setState((){
                  if (_blueJayThemeUnlocked) {
                    setBooleanSetting('appInDarkMode', false);
                    setupDarkOrLightMode(false);
                    _updateAppTheme('BlueJay');
                  } else {
                    // Logic to launch store for In app Purchase
                    _launchStoreStuff('bluejay_theme');
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 4,
                        color: assetForSelectedThemeAndMode == 'assets/images/BlueJayLight.png'
                            ? Colors.blue
                            : Colors.transparent
                    )
                ),
                child: Image.asset('assets/images/BlueJayLight.png', width: 140, height: 240),
              ),
            ),

          ]),

          const SizedBox(height: 10),

          // Radio Tile
          Container(
              width: 220,
              child: Material(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RadioListTile(
                    secondary:  Icon(Icons.lock,
                        size: 30,
                        color: _blueJayThemeUnlocked ? Colors.transparent
                            : appCurrentlyInDarkMode ? Colors.black : Colors.white
                    ),
                    title: Text(
                      'BlueJay',
                      style: TextStyle(
                          color: appCurrentlyInDarkMode ? Colors.black : Colors.white,
                          fontSize: _textFontSize),
                    ),
                    tileColor: appCurrentlyInDarkMode
                        ? Colors.blue.shade200
                        : Colors.blue.shade600,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    value: 'BlueJay',
                    groupValue: _currentTheme,
                    onChanged: _updateAppTheme,
                  ))),
        ],
      ),
    );
  }

  Widget getBubblegumThemePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [
            // Bubblegum Dark
            GestureDetector(
              onTap: () {
                setState((){
                  if (_bubblegumThemeUnlocked) {
                    setBooleanSetting('appInDarkMode', true);
                    setupDarkOrLightMode(true);
                    _updateAppTheme('Bubblegum');
                  } else {
                    // Logic to launch store for In app Purchase
                    _launchStoreStuff('bubblegum_theme');
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 4,
                        color: assetForSelectedThemeAndMode == 'assets/images/BubbleGumDark.png'
                            ? Colors.blue
                            : Colors.transparent
                    )
                ),
                child: Image.asset('assets/images/BubbleGumDark.png', width: 140, height: 240),
              ),
            ),

            // Bubblegum Light
            GestureDetector(
              onTap: () {
                setState((){
                  if (_bubblegumThemeUnlocked) {
                    setBooleanSetting('appInDarkMode', false);
                    setupDarkOrLightMode(false);
                    _updateAppTheme('Bubblegum');
                  } else {
                    // Logic to launch store for In app Purchase
                    _launchStoreStuff('bubblegum_theme');
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 4,
                        color: assetForSelectedThemeAndMode == 'assets/images/BubbleGumLight.png'
                            ? Colors.blue
                            : Colors.transparent
                    )
                ),
                child: Image.asset('assets/images/BubbleGumLight.png', width: 140, height: 240),
              ),
            ),

          ]),

          const SizedBox(height: 10),

          // Radio Tile
          Container(
              width: 260,
              child: Material(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RadioListTile(
                    secondary:  Icon(Icons.lock,
                        size: 30,
                        color: _bubblegumThemeUnlocked ? Colors.transparent
                            : appCurrentlyInDarkMode ? Colors.black : Colors.white
                    ),
                    title: Text(
                      'Bubblegum',
                      style: TextStyle(
                          color: appCurrentlyInDarkMode ? Colors.black : Colors.white,
                          fontSize: _textFontSize),
                    ),
                    tileColor: appCurrentlyInDarkMode
                        ? Colors.pink.shade200
                        : Colors.pink.shade600,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    value: 'Bubblegum',
                    groupValue: _currentTheme,
                    onChanged: _updateAppTheme,
                  ))),
        ],
      ),
    );
  }

  Widget getPumpkinThemePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Row(children: [
            // Pumpkin Dark
            GestureDetector(
              onTap: () {
                setState((){
                  if (_pumpkinThemeUnlocked) {
                    setBooleanSetting('appInDarkMode', true);
                    setupDarkOrLightMode(true);
                    _updateAppTheme('Pumpkin');
                  } else {
                    // Logic to launch store for In app Purchase
                    _launchStoreStuff('pumpkin_theme');
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 4,
                        color: assetForSelectedThemeAndMode == 'assets/images/PumpkinDark.png'
                            ? Colors.blue
                            : Colors.transparent
                    )
                ),
                child: Image.asset('assets/images/PumpkinDark.png', width: 140, height: 240),
              ),
            ),

            // Pumpkin Light
            GestureDetector(
              onTap: () {
                setState((){
                  if (_pumpkinThemeUnlocked) {
                    setBooleanSetting('appInDarkMode', false);
                    setupDarkOrLightMode(false);
                    _updateAppTheme('Pumpkin');
                  } else {
                    // Logic to launch store for In app Purchase
                    _launchStoreStuff('pumpkin_theme');
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 4,
                        color: assetForSelectedThemeAndMode == 'assets/images/PumpkinLight.png'
                            ? Colors.blue
                            : Colors.transparent
                    )
                ),
                child: Image.asset('assets/images/PumpkinLight.png', width: 140, height: 240),
              ),
            ),
          ]),

          const SizedBox(height: 10),
          Container(
              width: 230,
              child: Material(
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RadioListTile(
                    secondary:  Icon(Icons.lock,
                        size: 30,
                        color: _pumpkinThemeUnlocked ? Colors.transparent
                            : appCurrentlyInDarkMode ? Colors.black : Colors.white
                    ),
                    title: Text(
                      'Pumpkin',
                      style: TextStyle(
                          color: appCurrentlyInDarkMode ? Colors.black : Colors.white,
                          fontSize: _textFontSize),
                    ),
                    tileColor: appCurrentlyInDarkMode ?  Colors.deepOrangeAccent.shade200 : Colors.deepOrange.shade900,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    value: 'Pumpkin',
                    groupValue: _currentTheme,
                    onChanged: _updateAppTheme,
                  )
              )
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
              child: Center(
                  child: Column(children: [
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _filterShowsAllThemes ? primaryAccentColor : secondaryColor,
                                  padding: const EdgeInsets.all(4),
                                ),
                                child: Text("All ($_totalThemeCount)",
                                  style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, color: getCorrectColorForComplicatedContext()),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _filterShowsAllThemes = true;
                                    setThemePagesToAll();
                                  });
                                },
                              ),
                          ),
                          SizedBox(width: 15),
                          SizedBox(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _filterShowsAllThemes ? secondaryColor : primaryAccentColor,
                                padding: const EdgeInsets.all(4),
                              ),
                              child: Text("Unlocked ($_unlockedThemeCount)",
                                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, color: getCorrectColorForComplicatedContext()),
                              ),
                              onPressed: () {
                                setState(() {
                                  _filterShowsAllThemes = false;
                                  setThemePagesToUnlockedOnly();
                                });
                              },
                            ),
                          )
                        ]),
                    SizedBox(
                        height: 325,
                        width: 300,
                        /////////////////////////////////////////////////////
                        /// These are the individual pages that show themes
                        /////////////////////////////////////////////////////
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: pages.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPageIndex = index;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return pages[index];
                          },
                        )),
                    PageIndicator(
                      currentPageIndex: _currentPageIndex,
                      pages: pages.length,
                      onPageSelected: (int pageIndex) {
                        _pageController.animateToPage(
                          pageIndex,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    SizedBox(height: 1, child: Container(color: Colors.grey)),
                    const SizedBox(height: 15),
                  ])));
        });
  }
}

///////////////////////////////////////////////////////////////////
// Helps navigate the pages used to display the different Themes
///////////////////////////////////////////////////////////////////
class PageIndicator extends StatelessWidget {
  final int currentPageIndex;
  final int pages;
  final ValueChanged<int> onPageSelected;

  PageIndicator({
    required this.currentPageIndex,
    required this.pages,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < pages; i++)
          GestureDetector(
            onTap: () => onPageSelected(i),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(
                i == currentPageIndex ? Icons.indeterminate_check_box : Icons.check_box_outline_blank,
                size: 30.0,
                color: i == currentPageIndex
                    ? Colors.blue
                    : appCurrentlyInDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
      ],
    );
  }
}