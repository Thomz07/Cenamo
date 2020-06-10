#import <Preferences/PSListController.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSliderTableCell.h>

@interface CENDefaultListController : PSListController
@end

@interface CENChargingListController : PSListController
@end

@interface CENLowBatteryListController : PSListController
@end

@interface CENLowPowerModeListController : PSListController
@end

/***********************************************************/

@interface CENDefaultPreviewCell : PSTableCell
@end

@interface CENChargingPreviewCell : PSTableCell
@end

@interface CENLowBatteryPreviewCell : PSTableCell
@end

@interface CENLowPowerModePreviewCell : PSTableCell
@end