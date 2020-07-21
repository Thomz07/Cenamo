#include "UIDevice+notchedDevice.h"

@implementation UIDevice (notchedDevice) // ty burrit0z for making this to work

-(BOOL)isNotched {
    NSString *modelName = [UIDevice.currentDevice _currentProduct]; // get the device Identifier

    if([modelName isEqualToString:@"iPhone6,1"] || [modelName isEqualToString:@"iPhone6,2"] || [modelName isEqualToString:@"iPhone7,2"] || [modelName isEqualToString:@"iPhone7,1"] || [modelName isEqualToString:@"iPhone8,1"] || [modelName isEqualToString:@"iPhone8,2"] || [modelName isEqualToString:@"iPhone8,4"] || [modelName isEqualToString:@"iPhone9,1"] || [modelName isEqualToString:@"iPhone9,3"] || [modelName isEqualToString:@"iPhone9,2"] || [modelName isEqualToString:@"iPhone9,4"] || [modelName isEqualToString:@"iPhone10,1"] || [modelName isEqualToString:@"iPhone10,4"] || [modelName isEqualToString:@"iPhone10,2"] || [modelName isEqualToString:@"iPhone10,5"] || [modelName isEqualToString:@"iPhone12,8"]) { 
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)isAnIpad {
    NSString *model = [UIDevice.currentDevice model]; // get the device model

    if([model isEqualToString:@"iPad"]){
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)isAnIpod {
    NSString *model = [UIDevice.currentDevice model]; // get the device model

    if([model isEqualToString:@"iPod"]){
        return YES;
    } else {
        return NO;
    }
} // yeah this is a copy pasta from the previous method shut up now :(

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