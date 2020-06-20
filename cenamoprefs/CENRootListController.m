#include "CENRootListController.h"

NSDictionary *prefs;
BOOL rounderCornersEnabled;
BOOL isNotchedDevice;
CENRootListController *controller;
NSString *domain = @"/var/mobile/Library/Preferences/com.thomz.cenamoprefs.plist";

static void detectNotch() {
    NSString *modelName = [UIDevice.currentDevice _currentProduct];
    if([modelName isEqualToString:@"iPhone6,1"] || [modelName isEqualToString:@"iPhone6,2"] || [modelName isEqualToString:@"iPhone7,2"] || [modelName isEqualToString:@"iPhone7,1"] || [modelName isEqualToString:@"iPhone8,1"] || [modelName isEqualToString:@"iPhone8,2"] || [modelName isEqualToString:@"iPhone8,4"] || [modelName isEqualToString:@"iPhone9,1"] || [modelName isEqualToString:@"iPhone9,3"] || [modelName isEqualToString:@"iPhone9,2"] || [modelName isEqualToString:@"iPhone9,4"] || [modelName isEqualToString:@"iPhone10,1"] || [modelName isEqualToString:@"iPhone10,4"] || [modelName isEqualToString:@"iPhone10,2"] || [modelName isEqualToString:@"iPhone10,5"]) { isNotchedDevice = NO;} else { isNotchedDevice=YES;
    }
}

@implementation CENRootListController

void xdockCheck() { 

	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Oops"
							message:@"It seems like you have a tweak to change the Dock style already installed \nGo on this tweak settings (if it has settings) and enable this option"
							preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel
		handler:^(UIAlertAction * action) {
			[controller setObjectInPreset:@NO forKey:@"XDock"];
			[controller reloadSpecifiers];
			[controller reloadSpecifierID:@"Use iPhone X Dock" animated:YES];
		}];

		[alert addAction:yes];
		if([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Multipla.dylib"] ||[[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/DockX.dylib"] ||[[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/DockX13.dylib"] ||[[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/HomeGesture.dylib"]){
			[controller presentViewController:alert animated:YES completion:nil];
		}
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		NSArray *chosenLabels = @[@"XDock",@"secretSetting"];
		self.mySavedSpecifiers = (!self.mySavedSpecifiers) ? [[NSMutableDictionary alloc] init] : self.mySavedSpecifiers;
		for(PSSpecifier *specifier in [self specifiers]) {
			if([chosenLabels containsObject:[specifier propertyForKey:@"key"]]) {
			[self.mySavedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"key"]];
			}
		}
	}

	return _specifiers;
}

-(void)viewDidLoad {

	[super viewDidLoad];
	[self removeSegments];

	UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
    self.navigationItem.rightBarButtonItem = applyButton;

	controller = self;

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)xdockCheck, CFSTR("com.thomz.cenamoprefs/xdock"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[[UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]] setOnTintColor:[UIColor colorWithRed: 1.00 green: 0.56 blue: 0.41 alpha: 1.00]];
	[[UISlider appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:[UIColor colorWithRed: 1.00 green: 0.56 blue: 0.41 alpha: 1.00]];
	[[UIButton appearanceWhenContainedInInstancesOfClasses:@[self.class]] setTintColor:[UIColor colorWithRed: 1.00 green: 0.56 blue: 0.41 alpha: 1.00]];
}

-(void)setObjectInPreset:(id)value forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setObject:value forKey:key inDomain:domain]; //literally useless except to make the following method look neater
}

-(void)respring:(id)sender {

	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Respring"
							message:@"Are you sure you want to Respring ?"
							preferredStyle:UIAlertControllerStyleActionSheet];

		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel
		handler:^(UIAlertAction * action) {}];

		UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive
		handler:^(UIAlertAction * action) {
			NSTask *t = [[NSTask alloc] init];
			[t setLaunchPath:@"usr/bin/sbreload"];
			[t launch];
		}];

		[alert addAction:defaultAction];
		[alert addAction:yes];
		[self presentViewController:alert animated:YES completion:nil];
}

-(void)removeSegments {

	detectNotch();

	if(isNotchedDevice){
		[self removeContiguousSpecifiers:@[self.mySavedSpecifiers[@"XDock"]] animated:YES];
	}

	[self removeContiguousSpecifiers:@[self.mySavedSpecifiers[@"secretSetting"]] animated:YES];

}

-(void)reloadSpecifiers {
	[self removeSegments];
}

-(void)resetPrefs:(id)sender {
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Reset Preferences"
							message:@"Are you sure you want to Restore Preferences ? \nThis will Respring your device"
							preferredStyle:UIAlertControllerStyleActionSheet];

		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel
		handler:^(UIAlertAction * action) {}];

		UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Reset Preferences" style:UIAlertActionStyleDestructive
		handler:^(UIAlertAction * action) {
			NSTask *t = [[NSTask alloc] init];
			[t setLaunchPath:@"usr/bin/sbreload"];
			[t launch];
			NSUserDefaults *prefs = [[NSUserDefaults standardUserDefaults] init];
			[prefs removePersistentDomainForName:@"com.thomz.cenamoprefs"];
		}];

		[alert addAction:defaultAction];
		[alert addAction:yes];
		[self presentViewController:alert animated:YES completion:nil];
}

-(void)whatsThat:(id)sender {
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=dQw4w9WgXcQ"]];

	// hehe ;)
}

-(void)openTwitterThomz:(id)sender {
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://twitter.com/Thomzi07"]];
}

-(void)openDepiction:(id)sender {
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://chariz.com/get/cenamo"]];
}

-(void)openGithub:(id)sender {
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://github.com/Thomz07/Cenamo"]];
}

@end

@implementation CenamoHeaderCell 
// I originaly stole a cell from Dave so i'll just link his twitter here : https://twitter.com/DaveWijk

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
    
    UILabel *tweakLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,30,self.contentView.bounds.size.width+30,50)];
	[tweakLabel setTextAlignment:NSTextAlignmentLeft];
    [tweakLabel setFont:[UIFont systemFontOfSize:50 weight: UIFontWeightRegular]];
    tweakLabel.text = @"Cenamo";
    
    UILabel *devLabel = [[UILabel alloc] initWithFrame:CGRectMake(25,70,self.contentView.bounds.size.width+30,50)];
	[devLabel setTextAlignment:NSTextAlignmentLeft];
    [devLabel setFont:[UIFont systemFontOfSize:22 weight: UIFontWeightMedium] ];
	devLabel.alpha = 0.8;
    devLabel.text = @"by Thomz";

	NSBundle *bundle = [[NSBundle alloc]initWithPath:@"/Library/PreferenceBundles/cenamoprefs.bundle"];
	UIImage *logo = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"iconFullSize" ofType:@"png"]];
	UIImageView *icon = [[UIImageView alloc]initWithImage:logo];
	icon.frame = CGRectMake(self.contentView.bounds.size.width-35,35,70,70);
	icon.layer.masksToBounds = YES;
	icon.layer.cornerRadius = 15;

	UITapGestureRecognizer *fiveTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secretSetting:)];
	fiveTap.delegate = (id<UIGestureRecognizerDelegate>)self;
	fiveTap.numberOfTapsRequired = 5;
    
    [self addSubview:tweakLabel];
    [self addSubview:devLabel];
	[self addSubview:icon];
	[self addGestureRecognizer:fiveTap];

    }
    	return self;

}

-(void)secretSetting:(UITapGestureRecognizer *)gesture {
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"What's that ?"
							message:@"You found the secret setting, enjoy :)"
							preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel
		handler:^(UIAlertAction * action) {
			[controller insertContiguousSpecifiers:@[controller.mySavedSpecifiers[@"secretSetting"]] afterSpecifierID:@"Enable" animated:YES];
		}];

		[alert addAction:defaultAction];
		[controller presentViewController:alert animated:YES completion:nil];
}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CenamoHeaderCell" specifier:specifier];
}

- (void)setFrame:(CGRect)frame {
	frame.origin.x = 0;
	[super setFrame:frame];
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1{
    return 140.0f;
}

@end

@implementation KRLabeledSliderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier 
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

    if (self)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15,15,300,20)];
        label.text = specifier.properties[@"label"];
        [self.contentView addSubview:label];
        [self.control setFrame:CGRectOffset(self.control.frame, 0, 15)];
		[self setBackgroundColor:[UIColor whiteColor]];
    }

    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.control setFrame:CGRectOffset(self.control.frame, 0, 15)];
}
@end

@implementation CENLinkDefaultPreviewCell // 1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

	}
	
	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

		prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

		double defaultRedFactor = [([prefs objectForKey:@"defaultRedFactor"] ?: @(1)) doubleValue];
		double defaultGreenFactor = [([prefs objectForKey:@"defaultGreenFactor"] ?: @(1)) doubleValue];
		double defaultBlueFactor = [([prefs objectForKey:@"defaultBlueFactor"] ?: @(1)) doubleValue];
		float defaultRedFactor_float = (float) defaultRedFactor;
		float defaultGreenFactor_float = (float) defaultGreenFactor;
		float defaultBlueFactor_float = (float) defaultBlueFactor;

		UIColor *color = [UIColor colorWithRed:defaultRedFactor_float green:defaultGreenFactor_float blue:defaultBlueFactor_float alpha:1.0];

		if(!self.defaultView){
			self.defaultView = [[UIView alloc] init];
			self.defaultView.frame = CGRectMake((self.contentView.bounds.size.width-60), 8, 50, 28.5);
			self.defaultView.layer.masksToBounds = NO;
			self.defaultView.layer.cornerRadius = 5;
			self.defaultView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
			self.defaultView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
			self.defaultView.layer.shadowOpacity = 0.5;
			self.defaultView.layer.shadowRadius = 2.0;

			[self addSubview:self.defaultView];
		}

		self.defaultView.backgroundColor = color;
}

@end

@implementation CENLinkChargingPreviewCell // 2

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

	}
	
	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

		prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

		double chargingRedFactor = [([prefs objectForKey:@"chargingRedFactor"] ?: @(0)) doubleValue];
		double chargingGreenFactor = [([prefs objectForKey:@"chargingGreenFactor"] ?: @(1)) doubleValue];
		double chargingBlueFactor = [([prefs objectForKey:@"chargingBlueFactor"] ?: @(0)) doubleValue];
		float chargingRedFactor_float = (float) chargingRedFactor;
		float chargingGreenFactor_float = (float) chargingGreenFactor;
		float chargingBlueFactor_float = (float) chargingBlueFactor;

		UIColor *color = [UIColor colorWithRed:chargingRedFactor_float green:chargingGreenFactor_float blue:chargingBlueFactor_float alpha:1.0];

		if(!self.chargingView){
			self.chargingView = [[UIView alloc] init];
			self.chargingView.frame = CGRectMake((self.contentView.bounds.size.width-60), 8, 50, 28.5);
			self.chargingView.layer.masksToBounds = NO;
			self.chargingView.layer.cornerRadius = 5;
			self.chargingView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
			self.chargingView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
			self.chargingView.layer.shadowOpacity = 0.5;
			self.chargingView.layer.shadowRadius = 2.0;

			[self addSubview:self.chargingView];
		}

		self.chargingView.backgroundColor = color;
}

@end

@implementation CENLinkLowBatteryPreviewCell // 3

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

	}
	
	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

		prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

		double lowBatteryRedFactor = [([prefs objectForKey:@"lowBatteryRedFactor"] ?: @(1)) doubleValue];
		double lowBatteryGreenFactor = [([prefs objectForKey:@"lowBatteryGreenFactor"] ?: @(0)) doubleValue];
		double lowBatteryBlueFactor = [([prefs objectForKey:@"lowBatteryBlueFactor"] ?: @(0)) doubleValue];
		float lowBatteryRedFactor_float = (float) lowBatteryRedFactor;
		float lowBatteryGreenFactor_float = (float) lowBatteryGreenFactor;
		float lowBatteryBlueFactor_float = (float) lowBatteryBlueFactor;

		UIColor *color = [UIColor colorWithRed:lowBatteryRedFactor_float green:lowBatteryGreenFactor_float blue:lowBatteryBlueFactor_float alpha:1.0];

		if(!self.lowBatteryView){
			self.lowBatteryView = [[UIView alloc] init];
			self.lowBatteryView.frame = CGRectMake((self.contentView.bounds.size.width-60), 8, 50, 28.5);
			self.lowBatteryView.layer.masksToBounds = NO;
			self.lowBatteryView.layer.cornerRadius = 5;
			self.lowBatteryView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
			self.lowBatteryView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
			self.lowBatteryView.layer.shadowOpacity = 0.5;
			self.lowBatteryView.layer.shadowRadius = 2.0;

			[self addSubview:self.lowBatteryView];
		}

		self.lowBatteryView.backgroundColor = color;
}

@end

@implementation CENLinkLowPowerModePreviewCell // 4

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {

	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if(self){

	}
	
	return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

		prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

		double lowPowerModeRedFactor = [([prefs objectForKey:@"lowPowerModeRedFactor"] ?: @(1)) doubleValue];
		double lowPowerModeGreenFactor = [([prefs objectForKey:@"lowPowerModeGreenFactor"] ?: @(1)) doubleValue];
		double lowPowerModeBlueFactor = [([prefs objectForKey:@"lowPowerModeBlueFactor"] ?: @(0)) doubleValue];
		float lowPowerModeRedFactor_float = (float) lowPowerModeRedFactor;
		float lowPowerModeGreenFactor_float = (float) lowPowerModeGreenFactor;
		float lowPowerModeBlueFactor_float = (float) lowPowerModeBlueFactor;

		UIColor *color = [UIColor colorWithRed:lowPowerModeRedFactor_float green:lowPowerModeGreenFactor_float blue:lowPowerModeBlueFactor_float alpha:1.0];

		if(!self.lowPowerModeView){
			self.lowPowerModeView = [[UIView alloc] init];
			self.lowPowerModeView.frame = CGRectMake((self.contentView.bounds.size.width-60), 8, 50, 28.5);
			self.lowPowerModeView.layer.masksToBounds = NO;
			self.lowPowerModeView.layer.cornerRadius = 5;
			self.lowPowerModeView.layer.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5].CGColor;
			self.lowPowerModeView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
			self.lowPowerModeView.layer.shadowOpacity = 0.5;
			self.lowPowerModeView.layer.shadowRadius = 2.0;

			[self addSubview:self.lowPowerModeView];
		}

		self.lowPowerModeView.backgroundColor = color;
}

@end
