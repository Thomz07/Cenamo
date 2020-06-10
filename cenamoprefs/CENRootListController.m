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
							message:@"It seems like you have Multipla installed \nThere is an option in Multipla to enable the X style Dock"
							preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction* yes = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel
		handler:^(UIAlertAction * action) {
			[controller.navigationController popToRootViewControllerAnimated:YES];
			[controller setObjectInPreset:@NO forKey:@"XDock"];
		}];

		[alert addAction:yes];
		if([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Multipla.dylib"]){
			[controller presentViewController:alert animated:YES completion:nil];
		}
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
		NSArray *chosenLabels = @[@"rounderCornersRadius",@"XDock"];
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
}

-(void)setObjectInPreset:(id)value forKey:(NSString *)key {
	[[NSUserDefaults standardUserDefaults] setObject:value forKey:key inDomain:domain]; //literally useless except to make the following method look neater
}

-(void)respring:(id)sender {

	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Respring"
							message:@"Are you sure you want to Respring"
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

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	[super setPreferenceValue:value specifier:specifier];

	prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

	rounderCornersEnabled = [[prefs objectForKey:@"rounderCornersEnabled"] boolValue];

	if(!rounderCornersEnabled){
		[self removeContiguousSpecifiers:@[self.mySavedSpecifiers[@"rounderCornersRadius"]] animated:YES];
	} else if(rounderCornersEnabled && ![self containsSpecifier:self.mySavedSpecifiers[@"rounderCornersRadius"]]) {
		[self insertContiguousSpecifiers:@[self.mySavedSpecifiers[@"rounderCornersRadius"]] afterSpecifierID:@"Rounded Corners" animated:YES];
	}
}

-(void)removeSegments {

	detectNotch();

	prefs = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.thomz.cenamoprefs"];

	rounderCornersEnabled = [[prefs objectForKey:@"rounderCornersEnabled"] boolValue];

	if(!rounderCornersEnabled){
		[self removeContiguousSpecifiers:@[self.mySavedSpecifiers[@"rounderCornersRadius"]] animated:YES];
	}

	if(isNotchedDevice){
		[self removeContiguousSpecifiers:@[self.mySavedSpecifiers[@"XDock"]] animated:YES];
	}

}

-(void)reloadSpecifiers {
	[self removeSegments];
}

@end

@implementation CenamoHeaderCell // Header Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)reuseIdentifier specifier:(id)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
    
    packageNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,70,self.contentView.bounds.size.width+30,50)];
	[packageNameLabel setTextAlignment:NSTextAlignmentRight];
    [packageNameLabel setFont:[UIFont systemFontOfSize:50 weight: UIFontWeightSemibold] ];
    packageNameLabel.textColor = [UIColor whiteColor];
    packageNameLabel.text = @"Cenamo";
    
    developerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,30,self.contentView.bounds.size.width+30,50)];
	[developerLabel setTextAlignment:NSTextAlignmentRight];
    [developerLabel setFont:[UIFont systemFontOfSize:22.5 weight: UIFontWeightMedium] ];
    developerLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.85];
	developerLabel.alpha = 0.8;
    developerLabel.text = @"Thomz";
    
    
    versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,110,self.contentView.bounds.size.width+30,50)];
	[versionLabel setTextAlignment:NSTextAlignmentRight];
    [versionLabel setFont:[UIFont systemFontOfSize:22 weight: UIFontWeightMedium] ];
    versionLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.8];
	versionLabel.alpha = 0.8;
    versionLabel.text = @"eta s0n";
    
    bgView.backgroundColor = [UIColor colorWithRed:0.46 green:0.72 blue:0.84 alpha:1.0];
    
    [self addSubview:packageNameLabel];
    [self addSubview:developerLabel];
    [self addSubview:versionLabel];

    }
    	return self;

}

- (instancetype)initWithSpecifier:(PSSpecifier *)specifier {
	return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MultiplaHeaderCell" specifier:specifier];
}

- (void)setFrame:(CGRect)frame {
	frame.origin.x = 0;
	[super setFrame:frame];
}

- (CGFloat)preferredHeightForWidth:(CGFloat)arg1{
    return 200.0f;
}


-(void)layoutSubviews{
	[super layoutSubviews];

    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, 200)];

    UIColor *topColor = [UIColor colorWithRed: 0.99 green: 0.45 blue: 0.42 alpha: 1.00];
    UIColor *bottomColor = [UIColor colorWithRed: 1.00 green: 0.56 blue: 0.41 alpha: 1.00];

    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.startPoint = CGPointMake(0.5, 0.0);
    theViewGradient.endPoint = CGPointMake(0.5, 1.0);
    theViewGradient.frame = bgView.bounds;

    //Add gradient to view
    [bgView.layer insertSublayer:theViewGradient atIndex:0];
    [self insertSubview:bgView atIndex:0];

}


- (CGFloat)preferredHeightForWidth:(CGFloat)width inTableView:(id)tableView {
	return [self preferredHeightForWidth:width];
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
