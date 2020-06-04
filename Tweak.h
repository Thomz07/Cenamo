#import <UIKit/UIKit.h>

@interface SBDockView : UIView
@property (nonatomic, strong) UIView *percentageView;
@property (nonatomic, assign) float batteryPercentageWidth;
@property (nonatomic, assign) float batteryLevel;
@property (nonatomic, assign) float oldBatteryLevel;
-(void)checkBatteryLevel;
-(void)updateBatteryViewWidth;
@end

@interface SBWallpaperEffectView : UIView
@end

// bools

BOOL enabled;

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


/*static double numberForValue(NSString *key, double defaultValue) {
	return (prefs && [prefs objectForKey:key] ? [[prefs objectForKey:key] doubleValue] : defaultValue);
}*/

static void preferencesChanged() {
    CFPreferencesAppSynchronize((CFStringRef)kIdentifier);
    reloadPrefs();

    // global

    enabled = boolValueForKey(@"enabled", YES);
}