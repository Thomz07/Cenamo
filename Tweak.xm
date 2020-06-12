#import "Tweak.h"

%group SBDockView

%hook SBDockView
%property (nonatomic, retain) UIView *percentageView;

%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float batteryPercentage;

-(id)initWithDockListView:(id)arg1 forSnapshot:(BOOL)arg2 {
	return %orig;
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

	BOOL HomeGestureInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/HomeGesture.dylib"]) ? YES : NO);
	BOOL DockX13Installed = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/DockX13.dylib"]) ? YES : NO);
	BOOL DockXInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/DockXI.dylib"]) ? YES : NO);
    BOOL MultiplaInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Multipla.dylib"]) ? YES : NO);

	if(HomeGestureInstalled ||DockX13Installed ||DockXInstalled ||MultiplaInstalled){
		XDock = NO;
	}
}

-(void)layoutSubviews {

	%orig;

		[self addPercentageBatteryView];
		[self updateBatteryViewWidth:nil];

}

%new 
-(void)updateBatteryViewWidth:(NSNotification *)notification {

	detectNotch();

	SBWallpaperEffectView *backgroundView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");

	BOOL HomeGestureInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/HomeGesture.dylib"]) ? YES : NO);
	BOOL DockX13Installed = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/DockX13.dylib"]) ? YES : NO);
	BOOL DockXInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/DockXI.dylib"]) ? YES : NO);
    BOOL MultiplaInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Multipla.dylib"]) ? YES : NO);

    NSMutableDictionary *multiplaPrefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/xyz.thomz.burritoz.multiplaprefs.plist"];
	NSMutableDictionary *dockXIprefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.xcxiao.dockxi.plist"];
	// still need to add DockX13 prefs but i can't find the bundle id 

    BOOL MultiplaXDock = [[multiplaPrefs objectForKey:@"XDock"] boolValue];
	BOOL DockXIXDock = [[dockXIprefs objectForKey:@"enableDXI"] boolValue];

	float percentageViewHeight = (isNotchedDevice ||(XDock && !isNotchedDevice) ||HomeGestureInstalled ||(DockXInstalled && DockXIXDock) ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)) ? backgroundView.bounds.size.height : self.bounds.size.height - 4;
	float percentageViewY = (isNotchedDevice ||(XDock && !isNotchedDevice) ||HomeGestureInstalled ||(DockXInstalled && DockXIXDock) ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)) ? 0 : 4;

	self.batteryPercentage = [[UIDevice currentDevice] batteryLevel] * 100;
	if(isNotchedDevice || (XDock && !isNotchedDevice) ||HomeGestureInstalled ||DockXInstalled ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)){
		self.batteryPercentageWidth = (self.batteryPercentage * (backgroundView.bounds.size.width)) / 100;
	} else {
		self.batteryPercentageWidth = (self.batteryPercentage * (self.bounds.size.width)) / 100;
	}
	
	self.percentageView.frame = CGRectMake(0,percentageViewY,self.batteryPercentageWidth,percentageViewHeight);

	if(!disableColoring){
		if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
			self.percentageView.backgroundColor = [UIColor colorWithRed:lowPowerModeRedFactor green:lowPowerModeGreenFactor blue:lowPowerModeBlueFactor alpha:1.0];
		} else if([[UIDevice currentDevice] batteryState] == 2){
			self.percentageView.backgroundColor = [UIColor colorWithRed:chargingRedFactor green:chargingGreenFactor blue:chargingBlueFactor alpha:1.0];
		} else if(self.batteryPercentage <= 20){
			self.percentageView.backgroundColor = [UIColor colorWithRed:lowBatteryRedFactor green:lowBatteryGreenFactor blue:lowBatteryBlueFactor alpha:1.0];
		} else {
			self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
		}
	} else {
		self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
	}

	NSLog(@"[Cenamo] : Battery info changed, battery level is %f", self.batteryPercentage);

}

%new
-(void)addPercentageBatteryView {

	detectNotch();

	SBWallpaperEffectView *backgroundView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");
	SBDockIconListView* iconListView = MSHookIvar<SBDockIconListView *>(self, "_iconListView");

	BOOL HomeGestureInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/HomeGesture.dylib"]) ? YES : NO);
	BOOL DockX13Installed = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/DockX13.dylib"]) ? YES : NO);
	BOOL DockXInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/DockXI.dylib"]) ? YES : NO);
    BOOL MultiplaInstalled = (([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/Multipla.dylib"]) ? YES : NO);

    NSMutableDictionary *multiplaPrefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/xyz.thomz.burritoz.multiplaprefs.plist"];
	NSMutableDictionary *dockXIprefs = [NSMutableDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.xcxiao.dockxi.plist"];
	// still need to add DockX13 prefs but i can't find the bundle id 

    BOOL MultiplaXDock = [[multiplaPrefs objectForKey:@"XDock"] boolValue];
	BOOL DockXIXDock = [[dockXIprefs objectForKey:@"enableDXI"] boolValue];

	float percentageViewHeight = (isNotchedDevice ||(XDock && !isNotchedDevice) ||HomeGestureInstalled ||(DockXInstalled && DockXIXDock) ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)) ? backgroundView.bounds.size.height : self.bounds.size.height - 4;
	float percentageViewY = (isNotchedDevice ||(XDock && !isNotchedDevice) ||HomeGestureInstalled ||(DockXInstalled && DockXIXDock) ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)) ? 0 : 4;

	if(!self.percentageView){

		[[NSNotificationCenter defaultCenter] addObserver:self
				selector:@selector(updateBatteryViewWidth:)
				name:@"CenamoInfoChanged"
				object:nil];

		self.percentageView = [[UIView alloc] initWithFrame:CGRectMake(0,percentageViewY,self.batteryPercentageWidth,percentageViewHeight)];
		self.percentageView.alpha = alphaForBatteryView;

		self.percentageView.layer.masksToBounds = YES;
		self.percentageView.layer.cornerRadius = rounderCornersRadius;

		if(!disableColoring){
			if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
				self.percentageView.backgroundColor = [UIColor colorWithRed:lowPowerModeRedFactor green:lowPowerModeGreenFactor blue:lowPowerModeBlueFactor alpha:1.0];
			} else if([[UIDevice currentDevice] batteryState] == 2){
				self.percentageView.backgroundColor = [UIColor colorWithRed:chargingRedFactor green:chargingGreenFactor blue:chargingBlueFactor alpha:1.0];
			} else if(self.batteryPercentage <= 20){
				self.percentageView.backgroundColor = [UIColor colorWithRed:lowBatteryRedFactor green:lowBatteryGreenFactor blue:lowBatteryBlueFactor alpha:1.0];
			} else {
				self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
			}
		} else {
			self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
		}
		
		if(isNotchedDevice || (XDock && !isNotchedDevice) ||HomeGestureInstalled ||DockXInstalled ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)){
			[backgroundView addSubview:self.percentageView];
		} else {
			[self addSubview:self.percentageView];
			[self bringSubviewToFront:iconListView];
		}

		[self updateBatteryViewWidth:nil];
	}
}

%end

%end

%group otherStuff

%hook UITraitCollection
- (CGFloat)displayCornerRadius {
	if(XDock){
		return 6;
	} else {
		return %orig;
	}
}
%end

%hook BCBatteryDevice

-(void)setCharging:(BOOL)arg1 {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"CenamoInfoChanged" object:nil userInfo:nil];
    %orig;
}

-(void)setBatterySaverModeActive:(BOOL)arg1 {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"CenamoInfoChanged" object:nil userInfo:nil];
    %orig;
}

-(void)setPercentCharge:(NSInteger)arg1 {

    if(arg1!=0) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CenamoInfoChanged" object:nil userInfo:nil];
    }
    %orig;
}

%end

%end

%group SBFloatingDockViewios13only

%hook SBFloatingDockView
%property (nonatomic, retain) UIView *percentageView;
%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float batteryPercentage;

-(id)initWithFrame:(CGRect)arg1 {
	return %orig;
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
}

-(void)layoutSubviews {

	%orig;

		[self addPercentageBatteryView];
		[self updateBatteryViewWidth:nil];

}

%new 
-(void)updateBatteryViewWidth:(NSNotification *)notification {

	float percentageViewHeight = self.backgroundView.bounds.size.height;

	self.batteryPercentage = [[UIDevice currentDevice] batteryLevel] * 100;
	self.batteryPercentageWidth = (self.batteryPercentage * (self.backgroundView.bounds.size.width)) / 100;
	
	self.percentageView.frame = CGRectMake(0,0,self.batteryPercentageWidth,percentageViewHeight);

	if(!disableColoring){
		if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
			self.percentageView.backgroundColor = [UIColor colorWithRed:lowPowerModeRedFactor green:lowPowerModeGreenFactor blue:lowPowerModeBlueFactor alpha:1.0];
		} else if([[UIDevice currentDevice] batteryState] == 2){
			self.percentageView.backgroundColor = [UIColor colorWithRed:chargingRedFactor green:chargingGreenFactor blue:chargingBlueFactor alpha:1.0];
		} else if(self.batteryPercentage <= 20){
			self.percentageView.backgroundColor = [UIColor colorWithRed:lowBatteryRedFactor green:lowBatteryGreenFactor blue:lowBatteryBlueFactor alpha:1.0];
		} else {
			self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
		}
	} else {
		self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
	}

	NSLog(@"[Cenamo] : Battery info changed, battery level is %f", self.batteryPercentage);

}

%new
-(void)addPercentageBatteryView {

	float percentageViewHeight = self.backgroundView.bounds.size.height;

	if(!self.percentageView){

		[[NSNotificationCenter defaultCenter] addObserver:self
				selector:@selector(updateBatteryViewWidth:)
				name:@"CenamoInfoChanged"
				object:nil];

		self.percentageView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.batteryPercentageWidth,percentageViewHeight)];
		self.percentageView.alpha = alphaForBatteryView;

		self.percentageView.layer.masksToBounds = YES;
		self.percentageView.layer.cornerRadius = rounderCornersRadius;

		if(!disableColoring){
			if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
				self.percentageView.backgroundColor = [UIColor colorWithRed:lowPowerModeRedFactor green:lowPowerModeGreenFactor blue:lowPowerModeBlueFactor alpha:1.0];
			} else if([[UIDevice currentDevice] batteryState] == 2){
				self.percentageView.backgroundColor = [UIColor colorWithRed:chargingRedFactor green:chargingGreenFactor blue:chargingBlueFactor alpha:1.0];
			} else if(self.batteryPercentage <= 20){
				self.percentageView.backgroundColor = [UIColor colorWithRed:lowBatteryRedFactor green:lowBatteryGreenFactor blue:lowBatteryBlueFactor alpha:1.0];
			} else {
				self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
			}
		} else {
			self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
		}
		
		[self.backgroundView addSubview:self.percentageView];

		[self updateBatteryViewWidth:nil];
	}
}

%end

%end

%ctor {

	preferencesChanged();

	if(enabled){
		%init(otherStuff);
		if(([[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatyDock.dylib"] || [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/FloatingDockPlus13.dylib"]) && kCFCoreFoundationVersionNumber > 1600) {
			%init(SBFloatingDockViewios13only);
		} else {
			%init(SBDockView);
		}
	}
}