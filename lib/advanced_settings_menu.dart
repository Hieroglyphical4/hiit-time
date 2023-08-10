import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:hiit_time/plate_calculator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Config/settings.dart';
import 'logs_widget.dart';

// This is the Parent Widget from which other settings menus are opened
class AdvancedSettingsMenu extends StatefulWidget {
  const AdvancedSettingsMenu({
    required Key key,
  }) : super(key: key);

  @override
  AdvancedSettingsMenuState createState() => AdvancedSettingsMenuState();
}

class AdvancedSettingsMenuState extends State<AdvancedSettingsMenu> {
  final _formKey = GlobalKey<FormState>();
  final _themeWidgetKey = GlobalKey<ThemeSettingsWidgetState>();
  bool _displayAudioSettings = false;
  bool _displayThemesSettings = false;
  bool _displayLogs = false;
  bool _displayAboutThisApp = false;
  bool _displayTips = false;

  Future<bool> _confirmRestoreDefaults() async {
    bool confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm",
            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 16, height: 1.1),
          ),
          content: const Text("Are you sure you want to restore all settings to their default?",
            style: TextStyle(fontSize: 14, height: 1.1),
          ),
          actions: [
            ElevatedButton(
              child: const Text("Cancel",
                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            ElevatedButton(
              child: const Text("Confirm",
                style: TextStyle(fontFamily: 'AstroSpace', fontSize: 14, height: 1.1),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }

  // It was necessary to call this from the parent widget to make the
  // changes appear as soon as the user makes them
  void onThemeChanged() {
    setState(() {
      // update the state with the new color
      setupDarkOrLightMode(appCurrentlyInDarkMode);
    });
  }

  void updateUIAfterPurchase() {
    // This method will be called from the InAppPurchase listener in main.dart
        // after a purchase is made to update the UI to reflect it.
    _themeWidgetKey.currentState?.updateThemeUIAfterPurchaseCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: primaryAccentColor,
        centerTitle: true,
        title: Text('Advanced Settings', style: TextStyle(
            color: textColorOverwrite
                ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                : alternateColorOverwrite ? Colors.black
                : Colors.white
        ),
        ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColorOverwrite
            ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                : alternateColorOverwrite ? Colors.black
                : Colors.white),
          onPressed: () {
          Navigator.pop(context);
          },
          ),
        actions: [
          IconButton(
            icon: Icon(Icons.calculate_outlined, color: textColorOverwrite
                ? appCurrentlyInDarkMode ? Colors.black : Colors.white
                : alternateColorOverwrite ? Colors.black
                : Colors.white
            ),
            onPressed: () {
              /// Launch Plate Calculator
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: MaterialLocalizations.of(context)
                    .modalBarrierDismissLabel,
                barrierColor: Colors.black45,
                transitionDuration: const Duration(milliseconds: 200),

                // ANY Widget can be passed here
                pageBuilder: (BuildContext buildContext,
                    Animation animation,
                    Animation secondaryAnimation) {
                  return Center(
                    child: PlateCalculator(key: UniqueKey()),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              // direction: Axis.vertical,
              children: [
                // Body of Settings!

                SizedBox(height: 20),

                ///////////////////////////
                // Audio Settings Button
                ///////////////////////////
                SizedBox(
                  height: 60,
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () => setState(() {
                        if (_displayAudioSettings) {
                          _displayAudioSettings = false;
                        } else {
                          _displayAudioSettings = true;
                          _displayThemesSettings = false;
                          _displayLogs = false;
                          _displayAboutThisApp = false;
                          _displayTips = false;
                        }
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryAccentColor,
                        padding: const EdgeInsets.all(4),
                      ),
                      child: Row(children: [
                        SizedBox(width: 10),
                        Icon(Icons.music_note, color: _displayAudioSettings
                            ? primaryAccentColor
                            : getCorrectColorForComplicatedContext()),
                        SizedBox(width: 20),
                        Text(_displayAudioSettings
                            ? 'Audio Settings'
                            : 'Audio Settings    >',
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                                color: getCorrectColorForComplicatedContext()
                            ),
                            textAlign: TextAlign.center
                        ),
                        Text(_displayAudioSettings
                            ? '    -'
                            : '',
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                                color: primaryAccentColor, fontWeight: FontWeight.bold
                            ),
                        )
                      ])
                  )
                ),

                // Determine if Audio Settings Widget should show:
                _displayAudioSettings
                  ? AudioSettingsWidget(key: UniqueKey())
                  : Container(),

                const SizedBox(height: 20),

                ///////////////////////////
                // Theme Settings Button
                ///////////////////////////
                SizedBox(
                    height: 60,
                    width: 300,
                    child: ElevatedButton(
                        onPressed: () => setState(() {
                          if (_displayThemesSettings) {
                            _displayThemesSettings = false;
                          } else {
                            _displayThemesSettings = true;
                            _displayAudioSettings = false;
                            _displayLogs = false;
                            _displayAboutThisApp = false;
                            _displayTips = false;
                          }
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryAccentColor,
                          padding: const EdgeInsets.all(4),
                        ),
                        child: Row(children: [
                            SizedBox(width: 10),
                        Icon(Icons.format_paint, color: _displayThemesSettings
                            ? primaryAccentColor
                            : getCorrectColorForComplicatedContext()),
                        SizedBox(width: 20),
                        Text(_displayThemesSettings
                            ? '         Themes'
                            : 'Themes                  >',
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                                color: textColorOverwrite
                                    ? Colors.black
                                    : alternateColorOverwrite ? Colors.black
                                    : appCurrentlyInDarkMode ? Colors.white : Colors.black
                            ),
                            textAlign: TextAlign.center),
                        Text(_displayThemesSettings
                            ? '         -'
                            : '',
                          style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                              color: primaryAccentColor, fontWeight: FontWeight.bold
                          ),
                        )

                    ])
                    )
                ),

                // Determine if Themes Widget should show:
                _displayThemesSettings
                  ? ThemeSettingsWidget(key: _themeWidgetKey, onThemeChanged: onThemeChanged)
                    : Container(),

                SizedBox(height: 20),

                ///////////////////////////
                // Logs Button
                ///////////////////////////
                SizedBox(
                    height: 60,
                    width: 300,
                    child: ElevatedButton(
                        onPressed: () => setState(() {
                          if (_displayLogs) {
                            _displayLogs = false;
                          } else {
                            _displayLogs = true;
                            _displayAboutThisApp = false;
                            _displayTips = false;
                            _displayAudioSettings = false;
                            _displayThemesSettings = false;
                          }
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryAccentColor,
                          padding: const EdgeInsets.all(4),
                        ),
                        child: Row(children: [
                            SizedBox(width: 10),
                        Icon(Icons.note_alt_rounded, color: _displayLogs
                            ? primaryAccentColor
                            : getCorrectColorForComplicatedContext()),
                        SizedBox(width: 20),
                        Text(_displayLogs
                            ? '           Logs'
                            : 'Logs                        >',
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                                color: textColorOverwrite
                                    ? Colors.black
                                    : alternateColorOverwrite ? Colors.black
                                    : appCurrentlyInDarkMode ? Colors.white : Colors.black
                            ),
                            textAlign: TextAlign.center),
                          Text(_displayLogs
                              ? '             -'
                              : '',
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                                color: primaryAccentColor, fontWeight: FontWeight.bold
                            ),
                          )
                        ])
                    )
                ),

                // Determine if Logs Widget should show:
                _displayLogs
                    ? LogsWidget(key: UniqueKey())
                    : Container(),

                SizedBox(height: 20),

                ///////////////////////////
                // Tips Button
                ///////////////////////////
                SizedBox(
                    height: 60,
                    width: 300,
                    child: ElevatedButton(
                        onPressed: () => setState(() {
                          if (_displayTips) {
                            _displayTips = false;
                          } else {
                            _displayTips = true;
                            _displayLogs = false;
                            _displayAboutThisApp = false;
                            _displayAudioSettings = false;
                            _displayThemesSettings = false;
                          }
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryAccentColor,
                          padding: const EdgeInsets.all(4),
                        ),
                        child: Row(children: [
                            SizedBox(width: 10),
                        Icon(Icons.tips_and_updates, color: _displayTips
                            ? primaryAccentColor
                            : getCorrectColorForComplicatedContext()),
                        SizedBox(width: 20),
                        Text(_displayTips
                            ? '           Tips'
                            : 'Tips                         >',
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                                color: textColorOverwrite
                                    ? Colors.black
                                    : alternateColorOverwrite ? Colors.black
                                    : appCurrentlyInDarkMode ? Colors.white : Colors.black
                            ),
                            textAlign: TextAlign.center),
                          Text(_displayTips
                              ? '              -'
                              : '',
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                                color: primaryAccentColor, fontWeight: FontWeight.bold
                            ),
                          )
                        ])
                    )
                ),

                // Determine if Tip Widget should show:
                _displayTips
                    ? TipsWidget(key: UniqueKey())
                    : Container(),

                SizedBox(height: 20),

                ///////////////////////////
                // About This App Button
                ///////////////////////////
                SizedBox(
                    height: 60,
                    width: 300,
                    child: ElevatedButton(
                        onPressed: () => setState(() {
                          if (_displayAboutThisApp) {
                            _displayAboutThisApp = false;
                          } else {
                            _displayAboutThisApp = true;
                            _displayLogs = false;
                            _displayTips = false;
                            _displayAudioSettings = false;
                            _displayThemesSettings = false;
                          }
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryAccentColor,
                          padding: const EdgeInsets.all(4),
                        ),
                        child: Row(children: [
                            SizedBox(width: 10),
                        Icon(Icons.question_mark, color: _displayAboutThisApp
                            ? primaryAccentColor
                            : getCorrectColorForComplicatedContext()),
                        SizedBox(width: 20),
                        Text(_displayAboutThisApp
                            ? 'About This App'
                            : 'About This App   >',
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                                color: textColorOverwrite
                                    ? Colors.black
                                    : alternateColorOverwrite ? Colors.black
                                    : appCurrentlyInDarkMode ? Colors.white : Colors.black
                            ),
                            textAlign: TextAlign.center),
                          Text(_displayAboutThisApp
                              ? '   -'
                              : '',
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1,
                                color: primaryAccentColor, fontWeight: FontWeight.bold
                            ),
                          )
                    ])
                    )
                ),

                // Determine if About This App Widget should show:
                _displayAboutThisApp
                    ? AboutThisAppWidget(key: UniqueKey())
                    : Container(),

                // Spacer between Extras Button and Restore Defaults
                (!_displayAudioSettings && !_displayThemesSettings)
                    ? const SizedBox(height: 25)
                    : Container(),
                const SizedBox(height: 50),

                ///////////////////////////
                // Restore Defaults Button
                ///////////////////////////
                SizedBox(
                    height: 50,
                    width: 350,
                    child: ElevatedButton(
                        onPressed: () {
                          _confirmRestoreDefaults().then((confirmed) {
                            if (confirmed) {
                              // Call Settings.dart method to remove all stored variables
                              clearUserSettings();

                              // Close this menu and return true to tell the settings menu
                              // to also close and restart the timer, leaving the user
                              // at the main/timer screen with default settings
                              Navigator.pop(context, true);
                            }
                          });
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          // shape: Rectangle(),
                          padding: const EdgeInsets.all(4),
                        ),
                        child: const Text('Restore Defaults',
                            style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1),
                            textAlign: TextAlign.center)
                    )
                ),

                const SizedBox(height: 110),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//////////////////////////////////////////
// Widget for all Tips (sub-submenu)
//////////////////////////////////////////
class TipsWidget extends StatefulWidget {
  const TipsWidget({
    required Key key,
  }) : super(key: key);

  @override
  TipsWidgetState createState() => TipsWidgetState();
}

class TipsWidgetState extends State<TipsWidget> {
  late PageController _pageController;
  final List<String> _pages = ['Timer', 'Settings', 'Logs', 'BackgroundTimer'];

  // Indicates what page the user is currently looking at
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPageIndex);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
              child: Center(
                  child: Column(children: [
                    SizedBox(
                        height: 360,
                        width: 300,
                        /////////////////////////////////////////////////////
                        /// These are the individual pages that show Tips
                        /////////////////////////////////////////////////////
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPageIndex = index;
                            });
                          },
                          // Each of these Children represent a Page
                          children: [
                            /// Timer Tip Page
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 15),
                                  Text("Timer", style: TextStyle(fontSize: 30, color: textColorOverwrite ? Colors.black : Colors.white)),
                                  Divider(color: primaryColor),
                                  Spacer(),
                                  Text("Timer vs Interval Mode:",
                                      style: TextStyle(fontSize: 22, color: primaryAccentColor)
                                  ),
                                  SizedBox(height: 12),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Timer Mode: ',
                                      style: TextStyle(fontSize: 19, color: primaryAccentColor), // Change color here
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "Only uses 'Work Time' and ends at 0.",
                                          style: TextStyle(fontSize: 18, color: primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Interval Mode: ',
                                      style: TextStyle(fontSize: 19, color: primaryAccentColor), // Change color here
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "Uses both 'Work Time' and 'Rest Time' to continuously loop.",
                                          style: TextStyle(fontSize: 18, color: primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 5),
                                  Divider(color: primaryColor),

                                  Text("Time to Setup:", style: TextStyle(fontSize: 22, color: primaryAccentColor)),
                                  SizedBox(height: 5),
                                  Text("Use the +Time button after setting up your phone for extra time to get in position.",
                                      style: TextStyle(fontSize: 18, color: primaryColor)
                                  ),

                                  SizedBox(height: 25),
                                  Spacer(),
                                ]
                              )
                            ),

                            /// Settings Tip Page
                            Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 15),
                                      Text("Settings", style: TextStyle(fontSize: 30, color: textColorOverwrite ? Colors.black : Colors.white)),
                                      Divider(color: primaryColor),
                                      SizedBox(height: 5),
                                      Text("Quick Navigation:", style: TextStyle(fontSize: 22, color: primaryAccentColor)),
                                      SizedBox(height: 5),
                                      Text("Access 'Advanced Settings' from the Timer by clicking the 'HIIT Time' header.",
                                          style: TextStyle(fontSize: 18, color: primaryColor)
                                      ),

                                      SizedBox(height: 8),
                                      Divider(color: primaryColor),
                                      SizedBox(height: 8),

                                      Text("Unending Timer:", style: TextStyle(fontSize: 22, color: primaryAccentColor)),
                                      SizedBox(height: 5),
                                      Text("Create a single looping Timer in Interval Mode by setting the Rest Time to 0.",
                                          style: TextStyle(fontSize: 18, color: primaryColor)
                                      ),
                                      SizedBox(height: 25),
                                      Spacer(),
                                    ]
                                )
                            ),

                            /// Logs Tip Page
                            Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 15),
                                      Text("Logs", style: TextStyle(fontSize: 30, color: textColorOverwrite ? Colors.black : Colors.white)),
                                      Divider(color: primaryColor),
                                      SizedBox(height: 5),
                                      Text("Getting Started:", style: TextStyle(fontSize: 22, color: primaryAccentColor)),
                                      SizedBox(height: 5),
                                      Text("Before saving a New Log in the Logs menu, you must first add an Exercise.",
                                          style: TextStyle(fontSize: 18, color: primaryColor)
                                      ),

                                      Spacer(),
                                      Divider(color: primaryColor),
                                      SizedBox(height: 5),
                                      Text("Adding Exercises:", style: TextStyle(fontSize: 22, color: primaryAccentColor)),
                                      SizedBox(height: 5),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(fontSize: 18, color: primaryColor),
                                          children: [
                                            TextSpan(
                                              text: "To add a New Exercise, navigate to the Logs menu, open the New Log widget and click the ",
                                            ),
                                            WidgetSpan(
                                              child: Icon(
                                                Icons.add_circle_outline,
                                                color: primaryAccentColor,
                                                size: 22,
                                              ),
                                            ),
                                            TextSpan(
                                              text: " icon in the Exercise Dropdown Menu.",
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Spacer(),
                                    ]
                                )
                            ),

                            /// Background Timer Tip Page
                            Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 15),
                                      Text("Background Mode", style: TextStyle(fontSize: 30, color: textColorOverwrite ? Colors.black : Colors.white)),
                                      Divider(color: primaryColor),
                                      SizedBox(height: 5),
                                      Text("Timer Stopping:", style: TextStyle(fontSize: 22, color: primaryAccentColor)),
                                      SizedBox(height: 5),
                                      Text("If the timer stops while running in the background, try changing these settings on your phone: ",
                                          style: TextStyle(fontSize: 18, color: primaryColor)
                                      ),

                                      SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("1) Disable Power Saving.",
                                            style: TextStyle(fontSize: 18, color: primaryColor)
                                        ),
                                      ),

                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("2) Long Press App Icon \n     > App info \n     > Battery \n     > Set HIIT Time to Unrestricted.",
                                          style: TextStyle(fontSize: 18, color: primaryColor)
                                        ),
                                      ),
                                      SizedBox(height: 25),
                                      Spacer(),
                                    ]
                                )
                            ),

                          ],
                        )),
                    PageIndicator(
                      currentPageIndex: _currentPageIndex,
                      pages: _pages,
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

/////////////////////////////////////////////////
// Widget for About This App Info (sub-submenu)
/////////////////////////////////////////////////
class AboutThisAppWidget extends StatefulWidget {
  const AboutThisAppWidget({
    required Key key,
  }) : super(key: key);

  @override
  AboutThisAppWidgetState createState() => AboutThisAppWidgetState();
}

class AboutThisAppWidgetState extends State<AboutThisAppWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Divider(color: primaryColor),
              Text("Thank you for downloading my first app! ", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: primaryColor)),
              Divider(color: primaryColor),
              SizedBox(height: 10),

              Text("Origin: ", style: TextStyle(fontSize: 25, color: primaryAccentColor)),
              SizedBox(height: 4),

              Text("I created this app because I needed a timer that was easy to setup and interact with during workouts. "
                  "After failing to find a quality, Ad-Free option on the app store, I decided to create my own.",
                  style: TextStyle(fontSize: 19, color: primaryColor)
              ),
              SizedBox(height: 8),
              Text("Logs were eventually added so that (other than a music app) HIIT Time is the only app needed while at the gym.",
                  style: TextStyle(fontSize: 19, color: primaryColor)
              ),
              SizedBox(height: 10),

              Text("Support: ", style: TextStyle(fontSize: 25, color: primaryAccentColor)),
              SizedBox(height: 4),
              Text("I hope you're enjoying the ad-free experience. If you want to support my work, please consider purchasing a Theme!",
                  style: TextStyle(fontSize: 19, color: primaryColor)
              ),
              SizedBox(height: 8),

              Divider(color: primaryColor),
              Text("Please send any comments, issues, questions or feedback to the address below.", textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: primaryColor)),
              Divider(color: primaryColor),
              SizedBox(height: 15),

              Text("Email:", style: TextStyle(fontSize: 25, color: primaryAccentColor)),
              SizedBox(height: 4),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text("HiitTimeApp@gmail.com",
                    style: TextStyle(fontSize: 20, color: primaryColor),
                  ),
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: "HiitTimeApp@gmail.com"))
                        .then((_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to clipboard')));
                    });
                  },
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: secondaryAccentColor,
                  // ),
                ),
              ),

              SizedBox(height: 5),

              Divider(color: primaryColor),
            ]
        )
    );
  }
}

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
  String? _assetForSelectedThemeAndMode;

  // Bools to track Unlocks
  bool _bubblegumThemeUnlocked = false;
  bool _pumpkinThemeUnlocked = false;

  void _updateAppTheme(String? theme) {
    if (theme != null) {
      if (themesPurchasedMap[theme] == true) {
        setState(() {
          _currentTheme = theme;
          appCurrentTheme = theme;
          setStringSetting('appTheme', theme);
          setupAppTheme(theme);
          widget.onThemeChanged();
          _assetForSelectedThemeAndMode = _determineAssetForCurrentTheme();
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

  final List<String> _possibleThemes = appPossibleThemes;
  int _determineCurrentPageIndex() {
    switch (appCurrentTheme){
      case 'Default':
        return 0;
      case 'Bubblegum':
        return 1;
      case 'Pumpkin':
        return 2;
    }
    return 0;
  }

  void updateThemeUIAfterPurchaseCompleted(){
    setState(() {
      _bubblegumThemeUnlocked = themesPurchasedMap['Bubblegum']!;
      _pumpkinThemeUnlocked = themesPurchasedMap['Pumpkin']!;
    });
  }

  String _determineAssetForCurrentTheme() {
    switch (appCurrentTheme){
      case 'Default':
        if (appCurrentlyInDarkMode) {
          return 'assets/images/DefaultDark.png';
        }
        return 'assets/images/DefaultLight.png';
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
        _showAppPurchaseNotification(context, "Products were not set yet....");
        // Products did not load on initial launch, try again.
        final ProductDetailsResponse productDetailsResponse = await inAppPurchase.queryProductDetails(productIds);
        if (productDetailsResponse.notFoundIDs.isNotEmpty) {
          // TODO Handle the error.
          _showAppPurchaseNotification(context, "Products are empty...");
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
    _assetForSelectedThemeAndMode = _determineAssetForCurrentTheme();
    _pageController = PageController(initialPage: _currentPageIndex);
    _bubblegumThemeUnlocked = themesPurchasedMap['Bubblegum']!;
    _pumpkinThemeUnlocked = themesPurchasedMap['Pumpkin']!;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
          child: Center(
              child: Column(children: [
                SizedBox(height: 10),
        SizedBox(
            height: 325,
            width: 300,
            /////////////////////////////////////////////////////
            /// These are the individual pages that show themes
            /////////////////////////////////////////////////////
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              // Each of these Children represent a Page
              children: [
                ////////////////////////
                /// Default Theme Page
                ////////////////////////
                Center(
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
                                        color: _assetForSelectedThemeAndMode == 'assets/images/DefaultDark.png'
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
                                        color: _assetForSelectedThemeAndMode == 'assets/images/DefaultLight.png'
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
                                  _possibleThemes[0],
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
                                value: _possibleThemes[0],
                                groupValue: _currentTheme,
                                onChanged: _updateAppTheme,
                              )
                          )
                      )
                    ],
                  ),
                ),

                ///////////////////////////
                /// Bubblegum Theme Page
                ///////////////////////////
                Center(
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
                                    color: _assetForSelectedThemeAndMode == 'assets/images/BubbleGumDark.png'
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
                                    color: _assetForSelectedThemeAndMode == 'assets/images/BubbleGumLight.png'
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
                                  _possibleThemes[1],
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
                                value: _possibleThemes[1],
                                groupValue: _currentTheme,
                                onChanged: _updateAppTheme,
                              ))),
                    ],
                  ),
                ),

                ////////////////////////
                /// Pumpkin Theme Page
                ////////////////////////
                Center(
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
                                    color: _assetForSelectedThemeAndMode == 'assets/images/PumpkinDark.png'
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
                                    color: _assetForSelectedThemeAndMode == 'assets/images/PumpkinLight.png'
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
                                  _possibleThemes[2],
                                  style: TextStyle(
                                      color: appCurrentlyInDarkMode ? Colors.black : Colors.white,
                                      fontSize: _textFontSize),
                                ),
                                tileColor: appCurrentlyInDarkMode ?  Colors.deepOrangeAccent.shade200 : Colors.deepOrange.shade900,
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                value: _possibleThemes[2],
                                groupValue: _currentTheme,
                                onChanged: _updateAppTheme,
                              )
                          )
                      ),
                    ],
                  ),
                ),
              ],
            )),
        PageIndicator(
          currentPageIndex: _currentPageIndex,
          pages: _possibleThemes,
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
  final List<String> pages;
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
        for (int i = 0; i < pages.length; i++)
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

////////////////////////////////////////////
// Widget for all Audio related Settings (submenu)
////////////////////////////////////////////
class AudioSettingsWidget extends StatefulWidget {

  const AudioSettingsWidget({
    required Key key
  }) : super(key: key);

  @override
  AudioSettingsWidgetState createState() => AudioSettingsWidgetState();
}

class AudioSettingsWidgetState extends State<AudioSettingsWidget> {
  bool _displayTimerAudioSettings = false;
  bool _displayButtonAudioSettings = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 20),
        /////////////////////////
        // Timer Submenu Button
        /////////////////////////
        SizedBox(
          height: 45,
          width: 225,
          child: ElevatedButton(
              onPressed: () => setState(() {
                if (_displayTimerAudioSettings) {
                  _displayTimerAudioSettings = false;
                } else {
                  _displayTimerAudioSettings = true;
                }
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryAccentColor,
                padding: const EdgeInsets.all(4),
              ),
              child: Row(
                children: [
                  Spacer(flex: 1),

                  _displayTimerAudioSettings
                    ? Row(children: [
                        Text('-',style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1, color: getCorrectColorForComplicatedContext())),
                        SizedBox(width: 30)
                  ])
                    : Container(),

                  Icon(Icons.watch_later_outlined, color: getCorrectColorForComplicatedContext()),
                  SizedBox(width: 10),
                  Text('Timer', style: TextStyle(fontFamily: 'AstroSpace', fontSize: 18, height: 1.1, color: getCorrectColorForComplicatedContext())),

                  _displayTimerAudioSettings
                      ? Spacer(flex: 2)
                      : Spacer(flex: 5),

                  _displayTimerAudioSettings
                      ? Text('-', style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1, color: getCorrectColorForComplicatedContext()))
                      : Text('>', style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1, color: getCorrectColorForComplicatedContext())),

                  _displayTimerAudioSettings
                    ? Spacer(flex: 1)
                    : SizedBox(width: 25),
                ],
              ),
          )
        ),

        // Determine if Timer Audio Submenu Widget should show:
        _displayTimerAudioSettings
            ? TimerAudioSettingsWidget()
            : Container(),

        const SizedBox(height: 10),
        SizedBox(height: 1, width: 285, child: Container(color: Colors.grey)),
        const SizedBox(height: 10),

        ////////////////////////////
        // Buttons Submenu Button
        ////////////////////////////
        SizedBox(
          height: 45,
          width: 225,
          child: ElevatedButton(
              onPressed: () => setState(() {
                if (_displayButtonAudioSettings) {
                  _displayButtonAudioSettings = false;
                } else {
                  _displayButtonAudioSettings = true;
                }
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryAccentColor,
                padding: const EdgeInsets.all(4),
              ),
              child: Row(
                children: [
                  Spacer(flex: 1),

                  _displayButtonAudioSettings
                          ? Row(children: [
                              Text('-',style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1, color: getCorrectColorForComplicatedContext())),
                              SizedBox(width: 20),
                          ])
                          : Container(),

                  Icon(Icons.touch_app_outlined, color: getCorrectColorForComplicatedContext()),
                  SizedBox(width: 10),
                  Text('Buttons',style: TextStyle(fontFamily: 'AstroSpace', fontSize: 18, height: 1.1, color: getCorrectColorForComplicatedContext())),

                  _displayButtonAudioSettings
                      ? Spacer(flex: 3)
                      : Spacer(flex: 5),

                  _displayButtonAudioSettings
                      ? Text('-', style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1, color: getCorrectColorForComplicatedContext()))
                      : Text('>', style: TextStyle(fontFamily: 'AstroSpace', fontSize: 20, height: 1.1, color: getCorrectColorForComplicatedContext())),

                  _displayButtonAudioSettings
                      ? Spacer(flex: 1)
                      : SizedBox(width: 25),
                ],
              )
          )
        ),

        // Determine if Timer Audio Submenu Widget should show:
        _displayButtonAudioSettings
            ? const ButtonAudioSettingsWidget()
            : Container(),

        const SizedBox(height: 20),
        SizedBox(height: 1, child: Container(color: Colors.grey)),
      ],
    );
  }
}

////////////////////////////////////////////////
// Widget for all Timer Audio related Settings (sub-submenu)
////////////////////////////////////////////////
class TimerAudioSettingsWidget extends StatefulWidget {

  const TimerAudioSettingsWidget({
    super.key,
  });

  @override
  TimerAudioSettingsWidgetState createState() => TimerAudioSettingsWidgetState();
}

class TimerAudioSettingsWidgetState extends State<TimerAudioSettingsWidget> {
  final double _textFontSize = 18;

  void _onTimerAlarmChanged(bool value) {
    setState(() {
      if (timerAlarmCurrentlyEnabled) {
        // Call settings.dart Setter
        setBooleanSetting('timerAlarmEnabled', false);
        timerAlarmCurrentlyEnabled = false;
      } else {
        // Call settings.dart Setter
        setBooleanSetting('timerAlarmEnabled', true);
        timerAlarmCurrentlyEnabled = true;
      }
    });
  }

  void _on321CountdownChanged(bool value) {
    setState(() {
      if (threeTwoOneCountdownCurrentlyEnabled) {
        setBooleanSetting('threeTwoOneCountdownEnabled', false);
        threeTwoOneCountdownCurrentlyEnabled = false;
      } else {
        setBooleanSetting('threeTwoOneCountdownEnabled', true);
        threeTwoOneCountdownCurrentlyEnabled = true;
      }
    });
  }

  void _onTenSecondWarningChanged(bool value) {
    setState(() {
      if (tenSecondWarningCurrentlyEnabled) {
        setBooleanSetting('tenSecondWarningEnabled', false);
        tenSecondWarningCurrentlyEnabled = false;
      } else {
        setBooleanSetting('tenSecondWarningEnabled', true);
        tenSecondWarningCurrentlyEnabled = true;
      }
    });
  }

  void _onWorkModeAlertSwitchChanged(bool value) {
    setState(() {
      if (alertWorkModeStartedCurrentlyEnabled) {
        setBooleanSetting('alertWorkModeStartedEnabled', false);
        alertWorkModeStartedCurrentlyEnabled = false;
      } else {
        setBooleanSetting('alertWorkModeStartedEnabled', true);
        alertWorkModeStartedCurrentlyEnabled = true;
      }
    });
  }

  void _onRestModeAlertSwitchChanged(bool value) {
    setState(() {
      if (alertRestModeStartedCurrentlyEnabled) {
        setBooleanSetting('alertRestModeStartedEnabled', false);
        alertRestModeStartedCurrentlyEnabled = false;
      } else {
        setBooleanSetting('alertRestModeStartedEnabled', true);
        alertRestModeStartedCurrentlyEnabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          /////////////////////////////
          // Timer Alarm Settings
          /////////////////////////////
          Row(
            children: [
              const Spacer(flex: 4),
              Text('Timer Alarm',
                  style: TextStyle(
                      color: timerAlarmCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),
              SizedBox(width: 78),
              IconButton(
                iconSize: 35,
                color: timerAlarmCurrentlyEnabled
                    ? primaryColor
                    : Colors.grey,
                icon: const Icon(Icons.audio_file_outlined),
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Launch Audio Changer menu
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black45,
                    transitionDuration: const Duration(milliseconds: 200),

                    // ANY Widget can be passed here
                    pageBuilder: (BuildContext buildContext,
                        Animation animation,
                        Animation secondaryAnimation) {
                      return Center(
                        child: AudioChangerMenuWidget(
                          parentWidget: 'Timer Alarm',
                          options: timerAlarmAssetMap.values.toList(),
                        ),
                      );
                    },
                  ).then((restartRequired) {
                    setState(() {
                      //
                    });
                  });
                },
              ),
              const Spacer(flex: 1),
              SizedBox(width: 10),

              Switch(
                value: timerAlarmCurrentlyEnabled,
                onChanged: _onTimerAlarmChanged,
              ),
              const Spacer(flex: 3),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, width: 325, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),

          /////////////////////////////
          // 3-2-1 Countdown Settings
          /////////////////////////////
          Row(
            children: [
              const Spacer(flex: 4),
              Text('3-2-1 Countdown',
                  style: TextStyle(
                      color: threeTwoOneCountdownCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),
              SizedBox(width: 37),
              IconButton(
                iconSize: 35,
                color: threeTwoOneCountdownCurrentlyEnabled
                    ? primaryColor
                    : Colors.grey,
                icon: const Icon(Icons.audio_file_outlined),
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Launch Audio Changer menu
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black45,
                    transitionDuration: const Duration(milliseconds: 200),

                    // ANY Widget can be passed here
                    pageBuilder: (BuildContext buildContext,
                        Animation animation,
                        Animation secondaryAnimation) {
                      return Center(
                        child: AudioChangerMenuWidget(
                          parentWidget: '3-2-1           Countdown',
                          options: threeTwoOneCountdownAssetMap.values.toList(),
                        ),
                      );
                    },
                  ).then((restartRequired) {
                    setState(() {
                      //
                    });
                  });
                },
              ),
              const Spacer(flex: 1),
              const SizedBox(width: 8),

              Switch(
                value: threeTwoOneCountdownCurrentlyEnabled,
                onChanged: _on321CountdownChanged,
              ),
              const Spacer(flex: 3),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, width: 325,  child: Container(color: Colors.grey)),
          const SizedBox(height: 10),

          /////////////////////////////
          // 10 Second Warning Settings
          /////////////////////////////
          Row(
            children: [
              const Spacer(flex: 4),
              Text('10 Second Warning',
                  style: TextStyle(
                      color: tenSecondWarningCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),
              SizedBox(width: 20),
              IconButton(
                iconSize: 35,
                color: tenSecondWarningCurrentlyEnabled
                    ? primaryColor
                    : Colors.grey,
                icon: const Icon(Icons.audio_file_outlined),
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Launch Audio Changer menu
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black45,
                    transitionDuration: const Duration(milliseconds: 200),

                    // ANY Widget can be passed here
                    pageBuilder: (BuildContext buildContext,
                        Animation animation,
                        Animation secondaryAnimation) {
                      return Center(
                        child: AudioChangerMenuWidget(
                          parentWidget: '10 Second Warning',
                          options: tenSecondWarningAssetMap.values.toList(),
                        ),
                      );
                    },
                  ).then((restartRequired) {
                    setState(() {
                      //
                    });
                  });
                },
              ),
              const Spacer(flex: 1),
              SizedBox(width: 10),
              Switch(
                value: tenSecondWarningCurrentlyEnabled,
                onChanged: _onTenSecondWarningChanged,
              ),
              const Spacer(flex: 3),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, width: 325, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),
          ///////////////////////////////
          // Mode Switch Alert: Work Audio Settings
          //////////////////////////////
          Row(
            children: [
              const Spacer(flex: 4),
              Text('Alert for Work Mode',
                  style: TextStyle(
                      color: alertWorkModeStartedCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),
              SizedBox(width: 13),
              IconButton(
                iconSize: 35,
                color: alertWorkModeStartedCurrentlyEnabled
                    ? primaryColor
                    : Colors.grey,
                icon: const Icon(Icons.audio_file_outlined),
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Launch Audio Changer menu
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black45,
                    transitionDuration: const Duration(milliseconds: 200),

                    // ANY Widget can be passed here
                    pageBuilder: (BuildContext buildContext,
                        Animation animation,
                        Animation secondaryAnimation) {
                      return Center(
                        child: AudioChangerMenuWidget(
                          parentWidget: 'Alert for Work Mode',
                          options: alertWorkModeStartedAssetMap.values.toList(),
                        ),
                      );
                    },
                  ).then((restartRequired) {
                    setState(() {
                      //
                    });
                  });
                },
              ),
              const Spacer(flex: 1),
              SizedBox(width: 7),

              Switch(
                value: alertWorkModeStartedCurrentlyEnabled,
                onChanged: _onWorkModeAlertSwitchChanged,
              ),
              const Spacer(flex: 3),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, width: 325, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),

          ///////////////////////////////
          // Mode Switch Alert: Rest Audio Settings
          //////////////////////////////
          Row(
            children: [
              const Spacer(flex: 4),
              Text('Alert for Rest Mode',
                  style: TextStyle(
                      color: alertRestModeStartedCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(),
              SizedBox(width: 18),
              IconButton(
                iconSize: 35,
                color: alertRestModeStartedCurrentlyEnabled
                    ? primaryColor
                    : Colors.grey,
                icon: const Icon(Icons.audio_file_outlined),
                onPressed: () {
                  HapticFeedback.mediumImpact();

                  // Launch Audio Changer menu
                  showGeneralDialog(
                    context: context,
                    barrierDismissible: true,
                    barrierLabel: MaterialLocalizations.of(context)
                        .modalBarrierDismissLabel,
                    barrierColor: Colors.black45,
                    transitionDuration: const Duration(milliseconds: 200),

                    // ANY Widget can be passed here
                    pageBuilder: (BuildContext buildContext,
                        Animation animation,
                        Animation secondaryAnimation) {
                      return Center(
                        child: AudioChangerMenuWidget(
                          parentWidget: 'Alert for Rest Mode',
                          options: alertRestModeStartedAssetMap.values.toList(),
                        ),
                      );
                    },
                  ).then((restartRequired) {
                    setState(() {
                      //
                    });
                  });
                },
              ),
              const Spacer(flex: 1),
              SizedBox(width: 8),

              Switch(
                value: alertRestModeStartedCurrentlyEnabled,
                onChanged: _onRestModeAlertSwitchChanged,
              ),
              const Spacer(flex: 3),
            ],
          ),

        ]
    );
  }
}

////////////////////////////////////////////////
// Widget for all Button Audio related Settings (sub-submenu)
////////////////////////////////////////////////
class ButtonAudioSettingsWidget extends StatefulWidget {
  const ButtonAudioSettingsWidget({super.key});

  @override
  ButtonAudioSettingsWidgetState createState() => ButtonAudioSettingsWidgetState();
}

class ButtonAudioSettingsWidgetState extends State<ButtonAudioSettingsWidget> {
  final double _textFontSize = 18;


  void _onRestartButtonAudioChanged(bool value) {
    setState(() {
      if (restartButtonAudioCurrentlyEnabled) {
        setBooleanSetting('restartButtonAudioEnabled', false);
        restartButtonAudioCurrentlyEnabled = false;
      } else {
        setBooleanSetting('restartButtonAudioEnabled', true);
        restartButtonAudioCurrentlyEnabled = true;
      }
    });
  }

  void _onSaveButtonAudioChanged(bool value) {
    setState(() {
      if (saveButtonAudioCurrentlyEnabled) {
        setBooleanSetting('saveButtonAudioEnabled', false);
        saveButtonAudioCurrentlyEnabled = false;
      } else {
        setBooleanSetting('saveButtonAudioEnabled', true);
        saveButtonAudioCurrentlyEnabled = true;
      }
    });
  }

  void _onCancelButtonAudioChanged(bool value) {
    setState(() {
      if (cancelButtonAudioCurrentlyEnabled) {
        setBooleanSetting('cancelButtonAudioEnabled', false);
        cancelButtonAudioCurrentlyEnabled = false;
      } else {
        setBooleanSetting('cancelButtonAudioEnabled', true);
        cancelButtonAudioCurrentlyEnabled = true;
      }
    });
  }

  void _onSwitchButtonAudioChanged(bool value) {
    setState(() {
      if (switchButtonAudioCurrentlyEnabled) {
        setBooleanSetting('switchButtonAudioEnabled', false);
        switchButtonAudioCurrentlyEnabled = false;
      } else {
        setBooleanSetting('switchButtonAudioEnabled', true);
        switchButtonAudioCurrentlyEnabled = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          ////////////////////////
          // Restart Button Audio
          ////////////////////////
          Row(
            children: [
              const Spacer(flex: 4),
              Text('Restart Button Audio',
                  style: TextStyle(
                      color: restartButtonAudioCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(flex: 3),
              Switch(
                value: restartButtonAudioCurrentlyEnabled,
                onChanged: _onRestartButtonAudioChanged,
              ),
              const Spacer(flex: 3),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, width: 285, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),

          ///////////////////////
          // Save Button Audio
          ///////////////////////
          Row(
            children: [
              const Spacer(flex: 4),
              Text('Save Button Audio',
                  style: TextStyle(
                      color: saveButtonAudioCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(flex: 3),
              SizedBox(width: 20),

              Switch(
                value: saveButtonAudioCurrentlyEnabled,
                onChanged: _onSaveButtonAudioChanged,
              ),
              const Spacer(flex: 3),

            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, width: 285, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),

          /////////////////////////
          // Cancel Button Audio
          /////////////////////////
          Row(
            children: [
              const Spacer(flex: 4),
              Text('Cancel Button Audio',
                  style: TextStyle(
                      color: cancelButtonAudioCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(flex: 3),
              Switch(
                value: cancelButtonAudioCurrentlyEnabled,
                onChanged: _onCancelButtonAudioChanged,
              ),
              const Spacer(flex: 3),
            ],
          ),

          const SizedBox(height: 10),
          SizedBox(height: 1, width: 285, child: Container(color: Colors.grey)),
          const SizedBox(height: 10),

          /////////////////////////
          // Switch Button Audio
          /////////////////////////
          Row(
            children: [
              const Spacer(flex: 4),
              Text('Switch Button Audio',
                  style: TextStyle(
                      color: switchButtonAudioCurrentlyEnabled
                          ? primaryColor
                          : Colors.grey,
                      fontSize: _textFontSize,
                      height: 1.1),
                  textAlign: TextAlign.center),

              const Spacer(flex: 3),
              Switch(
                value: switchButtonAudioCurrentlyEnabled,
                onChanged: _onSwitchButtonAudioChanged,
              ),
              const Spacer(flex: 3),
            ],
          ),
        ]
    );
  }
}


////////////////////////////////////////////////
// Widget to handle Changing Audio Settings (Overlay menu)
////////////////////////////////////////////////
class AudioChangerMenuWidget extends StatefulWidget {
  final parentWidget;
  final List<String> options;

  const AudioChangerMenuWidget({
    super.key,
    required this.parentWidget,
    required this.options,
  });

  @override
  AudioChangerMenuWidgetState createState() => AudioChangerMenuWidgetState();
}

class AudioChangerMenuWidgetState extends State<AudioChangerMenuWidget> {
  late String _parentWidget = '';
  late List<String> _options;
  String? _selectedOption;
  final _audioPlayer = AudioPlayer();


  @override
  void initState() {
    super.initState();
    _parentWidget = widget.parentWidget;
    _options = widget.options;
    setupForParentWidget();
    _audioPlayer.setVolume(appCurrentVolume);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void setupForParentWidget() {
    switch (_parentWidget) {
      case 'Timer Alarm':
        _selectedOption = timerAlarmAssetMap[audioForTimerAlarm];
        break;
      case '3-2-1           Countdown':
        _selectedOption = threeTwoOneCountdownAssetMap[audioForAssembledCountdown];
        break;
      case '10 Second Warning':
        _selectedOption = tenSecondWarningAssetMap[audioForTimerCountdownAtTen];
        break;
      case 'Alert for Work Mode':
        _selectedOption = alertWorkModeStartedAssetMap[audioForAlertWorkModeStarted];
        break;
      case 'Alert for Rest Mode':
        _selectedOption = alertRestModeStartedAssetMap[audioForAlertRestModeStarted];
        break;
    }
  }

  String getAudioAssetFromMap() {
    switch (_parentWidget) {
      case 'Timer Alarm':
        for (var entry in timerAlarmAssetMap.entries) {
          if (entry.value == _selectedOption) {
            return entry.key;
          }
        }
        return '';

      case '3-2-1           Countdown':
        for (var entry in threeTwoOneCountdownAssetMap.entries) {
          if (entry.value == _selectedOption) {
            return entry.key;
          }
        }
        return '';

      case '10 Second Warning':
        for (var entry in tenSecondWarningAssetMap.entries) {
          if (entry.value == _selectedOption) {
            return entry.key;
          }
        }
        return '';

      case 'Alert for Work Mode':
        for (var entry in alertWorkModeStartedAssetMap.entries) {
          if (entry.value == _selectedOption) {
            return entry.key;
          }
        }
        return '';

      case 'Alert for Rest Mode':
        for (var entry in alertRestModeStartedAssetMap.entries) {
          if (entry.value == _selectedOption) {
            return entry.key;
          }
        }
        return '';

      default:
        throw Exception('Invalid Asset Provided');
    }
  }

  void setChosenAudioAsset(String desiredAsset) {
    switch (_parentWidget) {
      case 'Timer Alarm':
        audioForTimerAlarm = desiredAsset;
        setStringSetting('audioTimerAlarm', desiredAsset);
        break;
      case '3-2-1           Countdown':
        List<String> assetsSplit = desiredAsset.split(",");
        setStringSetting('audioTimerCountdownAtThree', assetsSplit[0]);
        setStringSetting('audioTimerCountdownAtTwo', assetsSplit[1]);
        setStringSetting('audioTimerCountdownAtOne', assetsSplit[2]);
        audioForAssembledCountdown = desiredAsset;
        setStringSetting('audioAssembledCountdown', desiredAsset);
        break;
      case '10 Second Warning':
        audioForTimerCountdownAtTen = desiredAsset;
        setStringSetting('audioTimerCountdownAtTen', desiredAsset);
        break;

      case 'Alert for Work Mode':
        audioForAlertWorkModeStarted = desiredAsset;
        setStringSetting('audioAlertWorkModeStarted', desiredAsset);
        break;

      case 'Alert for Rest Mode':
        audioForAlertRestModeStarted = desiredAsset;
        setStringSetting('audioAlertRestModeStarted', desiredAsset);
        break;
    }
  }

  void playAudioWithDelay(String desiredAsset) async {
    List<String> assetsSplit = desiredAsset.split(",");
    _audioPlayer.play(AssetSource(assetsSplit[0]));
    await Future.delayed(const Duration(seconds: 1));
    _audioPlayer.play(AssetSource(assetsSplit[1]));
    await Future.delayed(const Duration(seconds: 1));
    _audioPlayer.play(AssetSource(assetsSplit[2]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 360,
        width: 310,
        color: secondaryAccentColor,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(_parentWidget,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'AstroSpace', fontSize: 25, height: 1.1, color: primaryColor, decoration: TextDecoration.none)),
                const SizedBox(height: 10),
                Divider(color: primaryColor),
                const SizedBox(height: 10),

                ///////////////////////////
                // Dynamically create rows
                ///////////////////////////
                Expanded(
                    child: SizedBox(
                        width: 250,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _options.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: GestureDetector(
                                  // This is activated when the user clicks on the text field
                                  onTap: () {
                                    setState(() {

                                    });
                                  },
                                  child: ListTile(
                                      tileColor: primaryColor,
                                      title: Text(_options[index], style: TextStyle(color: secondaryAccentColor, fontSize: 18)),
                                      leading: Radio<String>(
                                        value: _options[index],
                                        groupValue: _selectedOption,
                                        onChanged: (String? value) {
                                          // This is activated when the user clicks on a new Radio Button
                                          setState(() {
                                            _selectedOption = value;
                                            var desiredAsset = getAudioAssetFromMap();
                                            setChosenAudioAsset(desiredAsset);

                                            if (_parentWidget == '3-2-1           Countdown') {
                                              // We need to break the desired asset down into 3 with spaces
                                              playAudioWithDelay(desiredAsset);
                                            } else {
                                              // There is only one asset to play:
                                              _audioPlayer.play(AssetSource(desiredAsset));
                                            }
                                          });
                                        },
                                      ),
                                    )
                                ),
                            );
                          },
                        )
                    ),
                  ),
                const SizedBox(height: 20),
              ],
        )
    )
    );
  }
}