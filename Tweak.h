#import <UIKit/UIKit.h>

@interface SBDockView : UIView
@property (nonatomic, retain) UIView *percentageView;
@property (nonatomic, assign) float batteryPercentageWidth;
@property (nonatomic, assign) float batteryPercentage;
-(void)updateBatteryViewWidth:(NSNotification *)notification;
-(void)addPercentageBatteryView;
@end

@interface SBWallpaperEffectView : UIView
@end

@interface BCBatteryDevice : NSObject
@end

SBDockView *theDock;

// bools

BOOL enabled;
double alphaForBatteryView;
BOOL disableColoring;
BOOL rounderCornersEnabled;
double rounderCornersRadius;

#define PLIST_PATH @"/User/Library/Preferences/com.thomz.cenamo.plist"
#define kIdentifier @"com.thomz.cenamoprefs"
#define kSettingsChangedNotification (CFStringRef)@"com.thomz.cenamoprefs.plist/reload"
#define kSettingsPath @"/var/mobile/Library/Preferences/com.thomz.cenamoprefs.plist"

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

    // alpha 

    alphaForBatteryView = numberForValue(@"alphaForBatteryView", 1);

    // coloring

    disableColoring = boolValueForKey(@"disableColoring", NO);

    // corner radius

    rounderCornersEnabled = boolValueForKey(@"rounderCornersEnabled", NO);
    rounderCornersRadius = numberForValue(@"rounderCornersRadius", 30);
}