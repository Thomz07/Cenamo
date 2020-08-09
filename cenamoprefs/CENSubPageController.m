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

UIView *defaultViewDark;
UIColor *defaultColorDark;
UIView *chargingViewDark;
UIColor *chargingColorDark;
UIView *lowBatteryViewDark;
UIColor *lowBatteryColorDark;
UIView *lowPowerModeViewDark;
UIColor *lowPowerModeColorDark;

@implementation CENDefaultListController // 1

void defaultPreviewCellReload(){

    CENDefaultListController *controller = [[CENDefaultListController alloc]init];

    prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

    double defaultRedFactor = [([prefs objectForKey:@"defaultRedFactor"] ?: @(1)) doubleValue];
    double defaultGreenFactor = [([prefs objectForKey:@"defaultGreenFactor"] ?: @(1)) doubleValue];
    double defaultBlueFactor = [([prefs objectForKey:@"defaultBlueFactor"] ?: @(1)) doubleValue];
    float defaultRedFactor_float = (float) defaultRedFactor;
    float defaultGreenFactor_float = (float) defaultGreenFactor;
    float defaultBlueFactor_float = (float) defaultBlueFactor;
    NSString *defaultHexCode = [([prefs valueForKey:@"defaultHexCode"] ?: @"") stringValue];

    if([defaultHexCode isEqualToString:@""]){
        defaultColor = [UIColor colorWithRed:defaultRedFactor_float green:defaultGreenFactor_float blue:defaultBlueFactor_float alpha:1.0];
    } else {
        defaultColor = [controller colorFromHexCode:defaultHexCode];
    }

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[UISlider appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:[UIColor colorWithRed: 1.00 green: 0.56 blue: 0.41 alpha: 1.00]];
}

-(UIColor *)colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                        [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                        [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                        [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

@implementation CENChargingListController // 2

void chargingPreviewCellReload(){

    CENChargingListController *controller = [[CENChargingListController alloc]init];

    prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

    double chargingRedFactor = [([prefs objectForKey:@"chargingRedFactor"] ?: @(0.4)) doubleValue];
    double chargingGreenFactor = [([prefs objectForKey:@"chargingGreenFactor"] ?: @(1)) doubleValue];
    double chargingBlueFactor = [([prefs objectForKey:@"chargingBlueFactor"] ?: @(0.4)) doubleValue];
    float chargingRedFactor_float = (float) chargingRedFactor;
    float chargingGreenFactor_float = (float) chargingGreenFactor;
    float chargingBlueFactor_float = (float) chargingBlueFactor;
    NSString *chargingHexCode = [([prefs valueForKey:@"chargingHexCode"] ?: @"") stringValue];

    if([chargingHexCode isEqualToString:@""]){
        chargingColor = [UIColor colorWithRed:chargingRedFactor_float green:chargingGreenFactor_float blue:chargingBlueFactor_float alpha:1.0];
    } else {
        chargingColor = [controller colorFromHexCode:chargingHexCode];
    }

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[UISlider appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:[UIColor colorWithRed: 1.00 green: 0.56 blue: 0.41 alpha: 1.00]];
}

-(UIColor *)colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                        [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                        [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                        [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

@implementation CENLowBatteryListController // 3

void lowBatteryPreviewCellReload(){

    CENLowBatteryListController *controller = [[CENLowBatteryListController alloc]init];

    prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

    double lowBatteryRedFactor = [([prefs objectForKey:@"lowBatteryRedFactor"] ?: @(1)) doubleValue];
    double lowBatteryGreenFactor = [([prefs objectForKey:@"lowBatteryGreenFactor"] ?: @(0.4)) doubleValue];
    double lowBatteryBlueFactor = [([prefs objectForKey:@"lowBatteryBlueFactor"] ?: @(0.4)) doubleValue];
    float lowBatteryRedFactor_float = (float) lowBatteryRedFactor;
    float lowBatteryGreenFactor_float = (float) lowBatteryGreenFactor;
    float lowBatteryBlueFactor_float = (float) lowBatteryBlueFactor;
    NSString *lowBatteryHexCode = [([prefs valueForKey:@"lowBatteryHexCode"] ?: @"") stringValue];

    if([lowBatteryHexCode isEqualToString:@""]){
        lowBatteryColor = [UIColor colorWithRed:lowBatteryRedFactor_float green:lowBatteryGreenFactor_float blue:lowBatteryBlueFactor_float alpha:1.0];
    } else {
        lowBatteryColor = [controller colorFromHexCode:lowBatteryHexCode];
    }

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[UISlider appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:[UIColor colorWithRed: 1.00 green: 0.56 blue: 0.41 alpha: 1.00]];
}

-(UIColor *)colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                        [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                        [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                        [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

@implementation CENLowPowerModeListController //4

void lowPowerModePreviewCellReload(){

    CENLowPowerModeListController *controller = [[CENLowPowerModeListController alloc]init];

    prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

    double lowPowerModeRedFactor = [([prefs objectForKey:@"lowPowerModeRedFactor"] ?: @(1)) doubleValue];
    double lowPowerModeGreenFactor = [([prefs objectForKey:@"lowPowerModeGreenFactor"] ?: @(1)) doubleValue];
    double lowPowerModeBlueFactor = [([prefs objectForKey:@"lowPowerModeBlueFactor"] ?: @(0.4)) doubleValue];
    float lowPowerModeRedFactor_float = (float) lowPowerModeRedFactor;
    float lowPowerModeGreenFactor_float = (float) lowPowerModeGreenFactor;
    float lowPowerModeBlueFactor_float = (float) lowPowerModeBlueFactor;
    NSString *lowPowerModeHexCode = [([prefs valueForKey:@"lowPowerModeHexCode"] ?: @"") stringValue];

    if([lowPowerModeHexCode isEqualToString:@""]){
        lowPowerModeColor = [UIColor colorWithRed:lowPowerModeRedFactor_float green:lowPowerModeGreenFactor_float blue:lowPowerModeBlueFactor_float alpha:1.0];
    } else {
        lowPowerModeColor = [controller colorFromHexCode:lowPowerModeHexCode];
    }

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

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[UISlider appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:[UIColor colorWithRed: 1.00 green: 0.56 blue: 0.41 alpha: 1.00]];
}

-(UIColor *)colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                        [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                        [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                        [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

/***********************************************************/

@implementation CENDefaultPreviewCell // 1

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
        defaultView.layer.masksToBounds = NO;
        defaultView.layer.cornerRadius = 15;
        defaultView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
        defaultView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        defaultView.layer.shadowOpacity = 0.5;
        defaultView.layer.shadowRadius = 3.0;

        [self addSubview:defaultView];
}

@end

@implementation CENChargingPreviewCell // 2

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
        chargingView.layer.masksToBounds = NO;
        chargingView.layer.cornerRadius = 15;
        chargingView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
        chargingView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        chargingView.layer.shadowOpacity = 0.5;
        chargingView.layer.shadowRadius = 3.0;

        [self addSubview:chargingView];
}

@end

@implementation CENLowBatteryPreviewCell // 3

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
        lowBatteryView.layer.masksToBounds = NO;
        lowBatteryView.layer.cornerRadius = 15;
        lowBatteryView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
        lowBatteryView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        lowBatteryView.layer.shadowOpacity = 0.5;
        lowBatteryView.layer.shadowRadius = 3.0;

        [self addSubview:lowBatteryView];
}

@end

@implementation CENLowPowerModePreviewCell // 4

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
        lowPowerModeView.layer.masksToBounds = NO;
        lowPowerModeView.layer.cornerRadius = 15;
        lowPowerModeView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
        lowPowerModeView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        lowPowerModeView.layer.shadowOpacity = 0.5;
        lowPowerModeView.layer.shadowRadius = 3.0;

        [self addSubview:lowPowerModeView];
}

@end

/***********************************************************/

@implementation CENDefaultListControllerDark // 1

void defaultPreviewCellReloadDark(){

    CENDefaultListControllerDark *controller = [[CENDefaultListControllerDark alloc]init];

    prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

    double defaultRedFactorDark = [([prefs objectForKey:@"defaultRedFactorDark"] ?: @(1)) doubleValue];
    double defaultGreenFactorDark = [([prefs objectForKey:@"defaultGreenFactorDark"] ?: @(1)) doubleValue];
    double defaultBlueFactorDark = [([prefs objectForKey:@"defaultBlueFactorDark"] ?: @(1)) doubleValue];
    float defaultRedFactorDark_float = (float) defaultRedFactorDark;
    float defaultGreenFactorDark_float = (float) defaultGreenFactorDark;
    float defaultBlueFactorDark_float = (float) defaultBlueFactorDark;
    NSString *defaultHexCodeDark = [([prefs valueForKey:@"defaultHexCodeDark"] ?: @"") stringValue];

    if([defaultHexCodeDark isEqualToString:@""]){
        defaultColorDark = [UIColor colorWithRed:defaultRedFactorDark_float green:defaultGreenFactorDark_float blue:defaultBlueFactorDark_float alpha:1.0];
    } else {
        defaultColorDark = [controller colorFromHexCode:defaultHexCodeDark];
    }

    defaultViewDark.backgroundColor = defaultColorDark;

}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"DefaultDark" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {

	[super viewDidLoad];

    defaultPreviewCellReloadDark();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)defaultPreviewCellReloadDark, CFSTR("com.thomz.cenamoprefs/updateDefaultCellViewDark"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[UISlider appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:[UIColor colorWithRed: 1.00 green: 0.56 blue: 0.41 alpha: 1.00]];
}

-(UIColor *)colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                        [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                        [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                        [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

@implementation CENChargingListControllerDark // 2

void chargingPreviewCellReloadDark(){

    CENChargingListControllerDark *controller = [[CENChargingListControllerDark alloc]init];

    prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

    double chargingRedFactorDark = [([prefs objectForKey:@"chargingRedFactorDark"] ?: @(0.4)) doubleValue];
    double chargingGreenFactorDark = [([prefs objectForKey:@"chargingGreenFactorDark"] ?: @(1)) doubleValue];
    double chargingBlueFactorDark = [([prefs objectForKey:@"chargingBlueFactorDark"] ?: @(0.4)) doubleValue];
    float chargingRedFactorDark_float = (float) chargingRedFactorDark;
    float chargingGreenFactorDark_float = (float) chargingGreenFactorDark;
    float chargingBlueFactorDark_float = (float) chargingBlueFactorDark;
    NSString *chargingHexCodeDark = [([prefs valueForKey:@"chargingHexCodeDark"] ?: @"") stringValue];

    if([chargingHexCodeDark isEqualToString:@""]){
        chargingColorDark = [UIColor colorWithRed:chargingRedFactorDark_float green:chargingGreenFactorDark_float blue:chargingBlueFactorDark_float alpha:1.0];
    } else {
        chargingColorDark = [controller colorFromHexCode:chargingHexCodeDark];
    }

    chargingViewDark.backgroundColor = chargingColorDark;

}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"ChargingDark" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {

	[super viewDidLoad];

    chargingPreviewCellReloadDark();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)chargingPreviewCellReloadDark, CFSTR("com.thomz.cenamoprefs/updateChargingCellViewDark"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[UISlider appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:[UIColor colorWithRed: 1.00 green: 0.56 blue: 0.41 alpha: 1.00]];
}

-(UIColor *)colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                        [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                        [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                        [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

@implementation CENLowBatteryListControllerDark // 3

void lowBatteryPreviewCellReloadDark(){

    CENLowBatteryListControllerDark *controller = [[CENLowBatteryListControllerDark alloc]init];

    prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

    double lowBatteryRedFactorDark = [([prefs objectForKey:@"lowBatteryRedFactorDark"] ?: @(1)) doubleValue];
    double lowBatteryGreenFactorDark = [([prefs objectForKey:@"lowBatteryGreenFactorDark"] ?: @(0.4)) doubleValue];
    double lowBatteryBlueFactorDark = [([prefs objectForKey:@"lowBatteryBlueFactorDark"] ?: @(0.4)) doubleValue];
    float lowBatteryRedFactorDark_float = (float) lowBatteryRedFactorDark;
    float lowBatteryGreenFactorDark_float = (float) lowBatteryGreenFactorDark;
    float lowBatteryBlueFactorDark_float = (float) lowBatteryBlueFactorDark;
    NSString *lowBatteryHexCodeDark = [([prefs valueForKey:@"lowBatteryHexCodeDark"] ?: @"") stringValue];

    if([lowBatteryHexCodeDark isEqualToString:@""]){
        lowBatteryColorDark = [UIColor colorWithRed:lowBatteryRedFactorDark_float green:lowBatteryGreenFactorDark_float blue:lowBatteryBlueFactorDark_float alpha:1.0];
    } else {
        lowBatteryColorDark = [controller colorFromHexCode:lowBatteryHexCodeDark];
    }

    lowBatteryViewDark.backgroundColor = lowBatteryColorDark;

}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"LowBatteryDark" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {

	[super viewDidLoad];

    lowBatteryPreviewCellReloadDark();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)lowBatteryPreviewCellReloadDark, CFSTR("com.thomz.cenamoprefs/updateLowBatteryCellViewDark"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[UISlider appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:[UIColor colorWithRed: 1.00 green: 0.56 blue: 0.41 alpha: 1.00]];
}

-(UIColor *)colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                        [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                        [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                        [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

@implementation CENLowPowerModeListControllerDark //4

void lowPowerModePreviewCellReloadDark(){

    CENLowPowerModeListControllerDark *controller = [[CENLowPowerModeListControllerDark alloc]init];

    prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

    double lowPowerModeRedFactorDark = [([prefs objectForKey:@"lowPowerModeRedFactorDark"] ?: @(1)) doubleValue];
    double lowPowerModeGreenFactorDark = [([prefs objectForKey:@"lowPowerModeGreenFactorDark"] ?: @(1)) doubleValue];
    double lowPowerModeBlueFactorDark = [([prefs objectForKey:@"lowPowerModeBlueFactorDark"] ?: @(0.4)) doubleValue];
    float lowPowerModeRedFactorDark_float = (float) lowPowerModeRedFactorDark;
    float lowPowerModeGreenFactorDark_float = (float) lowPowerModeGreenFactorDark;
    float lowPowerModeBlueFactorDark_float = (float) lowPowerModeBlueFactorDark;
    NSString *lowPowerModeHexCodeDark = [([prefs valueForKey:@"lowPowerModeHexCodeDark"] ?: @"") stringValue];

    if([lowPowerModeHexCodeDark isEqualToString:@""]){
        lowPowerModeColorDark = [UIColor colorWithRed:lowPowerModeRedFactorDark_float green:lowPowerModeGreenFactorDark_float blue:lowPowerModeBlueFactorDark_float alpha:1.0];
    } else {
        lowPowerModeColorDark = [controller colorFromHexCode:lowPowerModeHexCodeDark];
    }

    lowPowerModeViewDark.backgroundColor = lowPowerModeColorDark;

}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"LowPowerDark" target:self];
	}

	return _specifiers;
}

-(void)viewDidLoad {

	[super viewDidLoad];

    lowPowerModePreviewCellReloadDark();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)lowPowerModePreviewCellReloadDark, CFSTR("com.thomz.cenamoprefs/updateLowPowerModeCellViewDark"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[UISlider appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:[UIColor colorWithRed: 1.00 green: 0.56 blue: 0.41 alpha: 1.00]];
}

-(UIColor *)colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                        [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                        [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                        [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

/***********************************************************/

@implementation CENDefaultPreviewCellDark // 1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

        defaultPreviewCellReloadDark();

	}
	
	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    defaultPreviewCellReloadDark();

        defaultViewDark = [[UIView alloc] init];
        defaultViewDark.backgroundColor = defaultColorDark;
        defaultViewDark.frame = CGRectMake(10, ((self.contentView.bounds.size.width) - (self.contentView.bounds.size.width - 20)) / 2, (self.contentView.bounds.size.width - 20), 70);
        defaultViewDark.layer.masksToBounds = NO;
        defaultViewDark.layer.cornerRadius = 15;
        defaultViewDark.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
        defaultViewDark.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        defaultViewDark.layer.shadowOpacity = 0.5;
        defaultViewDark.layer.shadowRadius = 3.0;

        [self addSubview:defaultViewDark];
}

@end

@implementation CENChargingPreviewCellDark // 2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

        chargingPreviewCellReloadDark();

	}
	
	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    chargingPreviewCellReloadDark();

        chargingViewDark = [[UIView alloc] init];
        chargingViewDark.backgroundColor = chargingColorDark;
        chargingViewDark.frame = CGRectMake(10, ((self.contentView.bounds.size.width) - (self.contentView.bounds.size.width - 20)) / 2, (self.contentView.bounds.size.width - 20), 70);
        chargingViewDark.layer.masksToBounds = NO;
        chargingViewDark.layer.cornerRadius = 15;
        chargingViewDark.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
        chargingViewDark.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        chargingViewDark.layer.shadowOpacity = 0.5;
        chargingViewDark.layer.shadowRadius = 3.0;

        [self addSubview:chargingViewDark];
}

@end

@implementation CENLowBatteryPreviewCellDark // 3

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

        lowBatteryPreviewCellReloadDark();

	}
	
	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    lowBatteryPreviewCellReloadDark();

        lowBatteryViewDark = [[UIView alloc] init];
        lowBatteryViewDark.backgroundColor = lowBatteryColorDark;
        lowBatteryViewDark.frame = CGRectMake(10, ((self.contentView.bounds.size.width) - (self.contentView.bounds.size.width - 20)) / 2, (self.contentView.bounds.size.width - 20), 70);
        lowBatteryViewDark.layer.masksToBounds = NO;
        lowBatteryViewDark.layer.cornerRadius = 15;
        lowBatteryViewDark.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
        lowBatteryViewDark.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        lowBatteryViewDark.layer.shadowOpacity = 0.5;
        lowBatteryViewDark.layer.shadowRadius = 3.0;

        [self addSubview:lowBatteryViewDark];
}

@end

@implementation CENLowPowerModePreviewCellDark // 4

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

        lowPowerModePreviewCellReloadDark();

	}
	
	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    lowPowerModePreviewCellReloadDark();

        lowPowerModeViewDark = [[UIView alloc] init];
        lowPowerModeViewDark.backgroundColor = lowPowerModeColorDark;
        lowPowerModeViewDark.frame = CGRectMake(10, ((self.contentView.bounds.size.width) - (self.contentView.bounds.size.width - 20)) / 2, (self.contentView.bounds.size.width - 20), 70);
        lowPowerModeViewDark.layer.masksToBounds = NO;
        lowPowerModeViewDark.layer.cornerRadius = 15;
        lowPowerModeViewDark.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
        lowPowerModeViewDark.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        lowPowerModeViewDark.layer.shadowOpacity = 0.5;
        lowPowerModeViewDark.layer.shadowRadius = 3.0;

        [self addSubview:lowPowerModeViewDark];
}

@end