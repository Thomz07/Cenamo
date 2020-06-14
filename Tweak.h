#import <UIKit/UIKit.h>

@interface SBDockView : UIView
@property (nonatomic, retain) UIView *percentageView;
@property (nonatomic, assign) float batteryPercentageWidth;
@property (nonatomic, assign) float batteryPercentage;
-(void)updateBatteryViewWidth:(NSNotification *)notification;
-(void)addPercentageBatteryView;
-(void)replaceBackgroundView;
@end

@interface SBFloatingDockView : UIView
@property (nonatomic,retain) UIView * backgroundView;
@property (nonatomic, retain) UIView *percentageView;
@property (nonatomic, assign) float batteryPercentageWidth;
@property (nonatomic, assign) float batteryPercentage;
-(void)updateBatteryViewWidth:(NSNotification *)notification;
-(void)addPercentageBatteryView;
@end

@interface SBWallpaperEffectView : UIView
@end

@interface SBIconListView : UIView
@end

@interface SBDockIconListView : SBIconListView
@end

@interface BCBatteryDevice : NSObject
@end

@interface SBIconListPageControl : UIView
@end

@interface UIDevice (Cenamo)
-(id)_currentProduct;
@end

SBFloatingDockView *floatingDock;
SBDockView *theDock;

// bools

BOOL isNotchedDevice;

BOOL enabled;
double alphaForBatteryView;
BOOL disableColoring;
double rounderCornersRadius;
BOOL XDock;
int percentageOrTint;

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

#define PLIST_PATH @"/User/Library/Preferences/com.thomz.cenamo.plist"
#define kIdentifier @"com.thomz.cenamoprefs"
#define kSettingsChangedNotification (CFStringRef)@"com.thomz.cenamoprefs.plist/reload"
#define kSettingsPath @"/var/mobile/Library/Preferences/com.thomz.cenamoprefs.plist"

static void detectNotch() {
    NSString *modelName = [UIDevice.currentDevice _currentProduct];

    if([modelName isEqualToString:@"iPhone6,1"] || [modelName isEqualToString:@"iPhone6,2"] || [modelName isEqualToString:@"iPhone7,2"] || [modelName isEqualToString:@"iPhone7,1"] || [modelName isEqualToString:@"iPhone8,1"] || [modelName isEqualToString:@"iPhone8,2"] || [modelName isEqualToString:@"iPhone8,4"] || [modelName isEqualToString:@"iPhone9,1"] || [modelName isEqualToString:@"iPhone9,3"] || [modelName isEqualToString:@"iPhone9,2"] || [modelName isEqualToString:@"iPhone9,4"] || [modelName isEqualToString:@"iPhone10,1"] || [modelName isEqualToString:@"iPhone10,4"] || [modelName isEqualToString:@"iPhone10,2"] || [modelName isEqualToString:@"iPhone10,5"]) { 
        isNotchedDevice = NO;
    } else {
        isNotchedDevice=YES;
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
    percentageOrTint = [([prefs objectForKey:@"percentageOrTint"] ?: @(1)) intValue];

    // alpha 

    alphaForBatteryView = numberForValue(@"alphaForBatteryView", 1);

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

    chargingRedFactor = numberForValue(@"chargingRedFactor",0);
    chargingGreenFactor = numberForValue(@"chargingGreenFactor",1);
    chargingBlueFactor = numberForValue(@"chargingBlueFactor",0);

    lowBatteryRedFactor = numberForValue(@"lowBatteryRedFactor",1);
    lowBatteryGreenFactor = numberForValue(@"lowBatteryGreenFactor",0);
    lowBatteryBlueFactor = numberForValue(@"lowBatteryBlueFactor",0);

    lowPowerModeRedFactor = numberForValue(@"lowPowerModeRedFactor",1);
    lowPowerModeGreenFactor = numberForValue(@"lowPowerModeGreenFactor",1);
    lowPowerModeBlueFactor = numberForValue(@"lowPowerModeBlueFactor",0);
}