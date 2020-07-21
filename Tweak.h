#import <UIKit/UIKit.h>
#import "UIColor+colorFromHexCode.h"
#import "UIDevice+notchedDevice.h"

@interface SBDockView : UIView
@property (nonatomic, retain) UIView *percentageView;
@property (nonatomic, assign) float batteryPercentageWidth;
@property (nonatomic, assign) float batteryPercentage;
-(void)updateBatteryViewWidth:(NSNotification *)notification;
-(void)addPercentageBatteryView;
@end

@interface SBFloatingDockPlatterView : UIView
@property (nonatomic,retain) UIView * backgroundView;
@property (nonatomic, retain) UIView *percentageView;
@property (nonatomic, assign) float batteryPercentageWidth;
@property (nonatomic, assign) float batteryPercentage;
-(void)updateBatteryViewWidth:(NSNotification *)notification;
-(void)addPercentageBatteryView;
@end

@interface SBWallpaperEffectView : UIView
@property (nonatomic,retain) UIView *blurView;
@end

@interface MTMaterialView : UIView
@property (assign,nonatomic) double weighting;
@end

@interface BCBatteryDevice : NSObject
@end

@interface SBIconListPageControl : UIView
@end

@interface UIDevice (Cenamo)
-(id)_currentProduct;
@end

SBFloatingDockPlatterView *floatingDock;
SBDockView *theDock;
UIView *backgroundView;

// tweak prefs

BOOL isNotchedDevice = [UIDevice.currentDevice isNotched];
BOOL isNotchedDeviceYES;
BOOL floatingDockEnabled;

BOOL enabled;
double alphaForBatteryView;
BOOL disableColoring;
double rounderCornersRadius;
BOOL XDock;
int percentageOrTint;
BOOL customPercentEnabled;
double customPercent;
BOOL transparentHundred;
BOOL hideBgView;

double defaultRedFactor;
double defaultGreenFactor;
double defaultBlueFactor;

double chargingRedFactor;
double chargingGreenFactor;
double chargingBlueFactor;

double lowBatteryRedFactor;
double lowBatteryGreenFactor;
double lowBatteryBlueFactor;

double lowPowerModeRedFactor;
double lowPowerModeGreenFactor;
double lowPowerModeBlueFactor;

NSString *defaultHexCode;
NSString *chargingHexCode;
NSString *lowBatteryHexCode;
NSString *lowPowerModeHexCode;

// other tweak prefs

BOOL HomeGestureInstalled;
BOOL DockX13Installed;
BOOL DockXInstalled;
BOOL MultiplaInstalled;

NSMutableDictionary *multiplaPrefs;
NSMutableDictionary *dockXIprefs;

BOOL MultiplaXDock;
BOOL DockXIXDock;

#define PLIST_PATH @"/User/Library/Preferences/com.thomz.cenamo.plist"
#define kIdentifier @"com.thomz.cenamoprefs"
#define kSettingsChangedNotification (CFStringRef)@"com.thomz.cenamoprefs/reload"
#define kSettingsPath @"/var/mobile/Library/Preferences/com.thomz.cenamoprefs.plist"

static void detectNotch() {
    NSString *modelName = [UIDevice.currentDevice _currentProduct];

    if([modelName isEqualToString:@"iPhone6,1"] || [modelName isEqualToString:@"iPhone6,2"] || [modelName isEqualToString:@"iPhone7,2"] || [modelName isEqualToString:@"iPhone7,1"] || [modelName isEqualToString:@"iPhone8,1"] || [modelName isEqualToString:@"iPhone8,2"] || [modelName isEqualToString:@"iPhone8,4"] || [modelName isEqualToString:@"iPhone9,1"] || [modelName isEqualToString:@"iPhone9,3"] || [modelName isEqualToString:@"iPhone9,2"] || [modelName isEqualToString:@"iPhone9,4"] || [modelName isEqualToString:@"iPhone10,1"] || [modelName isEqualToString:@"iPhone10,4"] || [modelName isEqualToString:@"iPhone10,2"] || [modelName isEqualToString:@"iPhone10,5"] || [modelName isEqualToString:@"iPhone12,8"]) { 
        isNotchedDeviceYES = NO;
    } else {
        isNotchedDeviceYES = YES;
    }
}

static void detectFloatingDock() {
    if(([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatyDock.dylib"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatingDockPlus13.dylib"]) || ([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatingDock.dylib"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatingDockPlus.dylib"])){
        floatingDockEnabled = YES;
    } else {
        floatingDockEnabled = NO;
    }
}

NSDictionary *prefs;

static void reloadPrefs() {
    if ([NSHomeDirectory() isEqualToString:@"/var/mobile"]) {
        CFArrayRef keyList = CFPreferencesCopyKeyList((CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

        if (keyList) {
            prefs = (NSDictionary *)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, (CFStringRef)kIdentifier, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));

            if (!prefs) {
                prefs = [NSDictionary new];
            }
            CFRelease(keyList);
        }
    } else {
        prefs = [NSDictionary dictionaryWithContentsOfFile:kSettingsPath];
    }
}

static BOOL boolValueForKey(NSString *key, BOOL defaultValue) {
    return (prefs && [prefs objectForKey:key] ? [[prefs objectForKey:key] boolValue] : defaultValue);
}


static double numberForValue(NSString *key, double defaultValue) {
	return (prefs && [prefs objectForKey:key] ? [[prefs objectForKey:key] doubleValue] : defaultValue);
}

static void preferencesChanged() {
    CFPreferencesAppSynchronize((CFStringRef)kIdentifier);
    reloadPrefs();

    // global

    enabled = boolValueForKey(@"enabled", YES);
    percentageOrTint = [([prefs objectForKey:@"percentageOrTint"] ?: @(0)) intValue];
    customPercentEnabled = boolValueForKey(@"customPercentEnabled", NO);
    customPercent = numberForValue(@"customPercent", 100);
    transparentHundred = boolValueForKey(@"transparentHundred", NO);
    hideBgView = boolValueForKey(@"hideBgView", NO);

    // alpha 

    alphaForBatteryView = numberForValue(@"alphaForBatteryView", 0.8);

    // coloring

    disableColoring = boolValueForKey(@"disableColoring", NO);

    // corner radius

    rounderCornersRadius = numberForValue(@"rounderCornersRadius", 0);

    // XDock

    XDock = boolValueForKey(@"XDock", NO);

    // Coloring

    defaultRedFactor = numberForValue(@"defaultRedFactor",1);
    defaultGreenFactor = numberForValue(@"defaultGreenFactor",1);
    defaultBlueFactor = numberForValue(@"defaultBlueFactor",1);

    chargingRedFactor = numberForValue(@"chargingRedFactor",0.4);
    chargingGreenFactor = numberForValue(@"chargingGreenFactor",1);
    chargingBlueFactor = numberForValue(@"chargingBlueFactor",0.4);

    lowBatteryRedFactor = numberForValue(@"lowBatteryRedFactor",1);
    lowBatteryGreenFactor = numberForValue(@"lowBatteryGreenFactor",0.4);
    lowBatteryBlueFactor = numberForValue(@"lowBatteryBlueFactor",0.4);

    lowPowerModeRedFactor = numberForValue(@"lowPowerModeRedFactor",1);
    lowPowerModeGreenFactor = numberForValue(@"lowPowerModeGreenFactor",1);
    lowPowerModeBlueFactor = numberForValue(@"lowPowerModeBlueFactor",0.4);

    defaultHexCode = [([prefs valueForKey:@"defaultHexCode"] ?: @"") stringValue];
    chargingHexCode = [([prefs valueForKey:@"chargingHexCode"] ?: @"") stringValue];
    lowBatteryHexCode = [([prefs valueForKey:@"lowBatteryHexCode"] ?: @"") stringValue];
    lowPowerModeHexCode = [([prefs valueForKey:@"lowPowerModeHexCode"] ?: @"") stringValue];
}

static void otherTweakPrefs() {
    HomeGestureInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/HomeGesture.dylib"]) ? YES : NO);
    DockX13Installed = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/DockX13.dylib"]) ? YES : NO);
    DockXInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/DockXI.dylib"]) ? YES : NO);
    MultiplaInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Multipla.dylib"]) ? YES : NO);

    multiplaPrefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/xyz.thomz.burritoz.multiplaprefs.plist"];
    dockXIprefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.xcxiao.dockxi.plist"];

    MultiplaXDock = [[multiplaPrefs objectForKey:@"XDock"] boolValue];
    DockXIXDock = [[dockXIprefs objectForKey:@"enableDXI"] boolValue];
}