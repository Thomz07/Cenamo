#import "CENSubPageController.h"

NSDictionary *prefs;
UIView *defaultView;
UIColor *defaultColor;
UIView *chargingView;
UIColor *chargingColor;
UIView *lowBatteryView;
UIColor *lowBatteryColor;
UIView *lowPowerModeView;
UIColor *lowPowerModeColor;

@implementation CENDefaultListController

void defaultPreviewCellReload(){

    prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

    double defaultRedFactor = [([prefs objectForKey:@"defaultRedFactor"] ?: @(1)) doubleValue];
    double defaultGreenFactor = [([prefs objectForKey:@"defaultGreenFactor"] ?: @(1)) doubleValue];
    double defaultBlueFactor = [([prefs objectForKey:@"defaultBlueFactor"] ?: @(1)) doubleValue];
    float defaultRedFactor_float = (float) defaultRedFactor;
    float defaultGreenFactor_float = (float) defaultGreenFactor;
    float defaultBlueFactor_float = (float) defaultBlueFactor;

    defaultColor = [UIColor colorWithRed:defaultRedFactor_float green:defaultGreenFactor_float blue:defaultBlueFactor_float alpha:1.0];

    defaultView.backgroundColor = defaultColor;

}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Default" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {

	[super viewDidLoad];

    defaultPreviewCellReload();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)defaultPreviewCellReload, CFSTR("com.thomz.cenamoprefs/updateDefaultCellView"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

@end

@implementation CENChargingListController

void chargingPreviewCellReload(){

    prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

    double chargingRedFactor = [([prefs objectForKey:@"chargingRedFactor"] ?: @(0)) doubleValue];
    double chargingGreenFactor = [([prefs objectForKey:@"chargingGreenFactor"] ?: @(1)) doubleValue];
    double chargingBlueFactor = [([prefs objectForKey:@"chargingBlueFactor"] ?: @(0)) doubleValue];
    float chargingRedFactor_float = (float) chargingRedFactor;
    float chargingGreenFactor_float = (float) chargingGreenFactor;
    float chargingBlueFactor_float = (float) chargingBlueFactor;

    chargingColor = [UIColor colorWithRed:chargingRedFactor_float green:chargingGreenFactor_float blue:chargingBlueFactor_float alpha:1.0];

    chargingView.backgroundColor = chargingColor;

}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Charging" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {

	[super viewDidLoad];

    chargingPreviewCellReload();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)chargingPreviewCellReload, CFSTR("com.thomz.cenamoprefs/updateChargingCellView"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

@end

@implementation CENLowBatteryListController

void lowBatteryPreviewCellReload(){

    prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

    double lowBatteryRedFactor = [([prefs objectForKey:@"lowBatteryRedFactor"] ?: @(1)) doubleValue];
    double lowBatteryGreenFactor = [([prefs objectForKey:@"lowBatteryGreenFactor"] ?: @(0)) doubleValue];
    double lowBatteryBlueFactor = [([prefs objectForKey:@"lowBatteryBlueFactor"] ?: @(0)) doubleValue];
    float lowBatteryRedFactor_float = (float) lowBatteryRedFactor;
    float lowBatteryGreenFactor_float = (float) lowBatteryGreenFactor;
    float lowBatteryBlueFactor_float = (float) lowBatteryBlueFactor;

    lowBatteryColor = [UIColor colorWithRed:lowBatteryRedFactor_float green:lowBatteryGreenFactor_float blue:lowBatteryBlueFactor_float alpha:1.0];

    lowBatteryView.backgroundColor = lowBatteryColor;

}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"LowBattery" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {

	[super viewDidLoad];

    lowBatteryPreviewCellReload();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)lowBatteryPreviewCellReload, CFSTR("com.thomz.cenamoprefs/updateLowBatteryCellView"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

@end

@implementation CENLowPowerModeListController

void lowPowerModePreviewCellReload(){

    prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

    double lowPowerModeRedFactor = [([prefs objectForKey:@"lowPowerModeRedFactor"] ?: @(1)) doubleValue];
    double lowPowerModeGreenFactor = [([prefs objectForKey:@"lowPowerModeGreenFactor"] ?: @(1)) doubleValue];
    double lowPowerModeBlueFactor = [([prefs objectForKey:@"lowPowerModeBlueFactor"] ?: @(0)) doubleValue];
    float lowPowerModeRedFactor_float = (float) lowPowerModeRedFactor;
    float lowPowerModeGreenFactor_float = (float) lowPowerModeGreenFactor;
    float lowPowerModeBlueFactor_float = (float) lowPowerModeBlueFactor;

    lowPowerModeColor = [UIColor colorWithRed:lowPowerModeRedFactor_float green:lowPowerModeGreenFactor_float blue:lowPowerModeBlueFactor_float alpha:1.0];

    lowPowerModeView.backgroundColor = lowPowerModeColor;

}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"LowPower" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {

	[super viewDidLoad];

    lowPowerModePreviewCellReload();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)lowPowerModePreviewCellReload, CFSTR("com.thomz.cenamoprefs/updateLowPowerModeCellView"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

@end

// preview cells (yeah i know i'm lazy)

@implementation CENDefaultPreviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

        defaultPreviewCellReload();

	}
	
	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    defaultPreviewCellReload();

        defaultView = [[UIView alloc] init];
        defaultView.backgroundColor = defaultColor;
        defaultView.frame = CGRectMake(10, ((self.contentView.bounds.size.width) - (self.contentView.bounds.size.width - 20)) / 2, (self.contentView.bounds.size.width - 20), 70);
        defaultView.layer.masksToBounds = YES;
        defaultView.layer.cornerRadius = 15;

        [self addSubview:defaultView];
}

@end

@implementation CENChargingPreviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

        chargingPreviewCellReload();

	}
	
	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    chargingPreviewCellReload();

        chargingView = [[UIView alloc] init];
        chargingView.backgroundColor = chargingColor;
        chargingView.frame = CGRectMake(10, ((self.contentView.bounds.size.width) - (self.contentView.bounds.size.width - 20)) / 2, (self.contentView.bounds.size.width - 20), 70);
        chargingView.layer.masksToBounds = YES;
        chargingView.layer.cornerRadius = 15;

        [self addSubview:chargingView];
}

@end

@implementation CENLowBatteryPreviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

        lowBatteryPreviewCellReload();

	}
	
	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    lowBatteryPreviewCellReload();

        lowBatteryView = [[UIView alloc] init];
        lowBatteryView.backgroundColor = lowBatteryColor;
        lowBatteryView.frame = CGRectMake(10, ((self.contentView.bounds.size.width) - (self.contentView.bounds.size.width - 20)) / 2, (self.contentView.bounds.size.width - 20), 70);
        lowBatteryView.layer.masksToBounds = YES;
        lowBatteryView.layer.cornerRadius = 15;

        [self addSubview:lowBatteryView];
}

@end

@implementation CENLowPowerModePreviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

        lowPowerModePreviewCellReload();

	}
	
	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    lowPowerModePreviewCellReload();

        lowPowerModeView = [[UIView alloc] init];
        lowPowerModeView.backgroundColor = lowPowerModeColor;
        lowPowerModeView.frame = CGRectMake(10, ((self.contentView.bounds.size.width) - (self.contentView.bounds.size.width - 20)) / 2, (self.contentView.bounds.size.width - 20), 70);
        lowPowerModeView.layer.masksToBounds = YES;
        lowPowerModeView.layer.cornerRadius = 15;

        [self addSubview:lowPowerModeView];
}

@end