#include "UIDevice+notchedDevice.h"
#import <LocalAuthentication/LocalAuthentication.h>

@implementation UIDevice (notchedDevice) 

-(BOOL)isNotched {
    
    if([self isAnIpod] || [self isAnIpad]) { // iPad and iPod are not notched devices
        return NO;
    }
    
    LAContext *context = [[LAContext alloc] init];
    
    [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
    return context.biometryType == LABiometryTypeFaceID; // only devices with FaceID are notched atm (also the latest iPad PRO so that's why i added an iPad check)
}

-(BOOL)isAnIpad {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

-(BOOL)isAnIpod {
    NSString const *model = [UIDevice.currentDevice model]; // get the device model
    
    return ([model isEqualToString:@"iPod"]);
} 

@end

// How to use this ? it's really simple
// Copy pasterinio these two files to your project, don't forget to include the .h file and then
// Just use these :
// [UIDevice.currentDevice isNotched]; This will return a BOOL that is equal to YES if the device is notched
// [UIDevice.currentDevice isAniPad]; This will return a BOOL that is equal to YES if the device is an iPad
// [UIDevice.currentDevice isAniPod]; This will return a BOOL that is equal to YES if the device is an iPod
//
// You can use those like this :
// BOOL isNotchedDevice = [UIDevice.currentDevice isNotched];
//
// This is pretty useless but you know
// https://wompampsupport.azureedge.net/fetchimage?siteId=7575&v=2&jpgQuality=100&width=700&url=https%3A%2F%2Fi.kym-cdn.com%2Fentries%2Ficons%2Ffacebook%2F000%2F028%2F021%2Fwork.jpg
