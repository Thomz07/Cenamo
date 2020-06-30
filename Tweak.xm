#import "Tweak.h"

// Normal Dock

%group SBDockViewPercentage

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

	if(theDock==nil) {
	
		theDock = self;

	}
}

%new
+(id)sharedDock {
	return theDock;
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

	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){

		float percentageViewHeight = (isNotchedDevice ||(XDock && !isNotchedDevice) ||HomeGestureInstalled ||(DockXInstalled && DockXIXDock) ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)) ? backgroundView.bounds.size.height : self.bounds.size.height - 4;
		float percentageViewY = (isNotchedDevice ||(XDock && !isNotchedDevice) ||HomeGestureInstalled ||(DockXInstalled && DockXIXDock) ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)) ? 0 : 4;

    	if(!customPercentEnabled){
			self.batteryPercentage = [[UIDevice currentDevice] batteryLevel] * 100;
		} else {
			self.batteryPercentage = customPercent;
		}
		if(isNotchedDevice || (XDock && !isNotchedDevice) ||HomeGestureInstalled ||DockXInstalled ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)){
			self.batteryPercentageWidth = (self.batteryPercentage * (backgroundView.bounds.size.width)) / 100;
		} else {
			self.batteryPercentageWidth = (self.batteryPercentage * (self.bounds.size.width)) / 100;
		}
		dispatch_async(dispatch_get_main_queue(), ^(void){
			[UIView animateWithDuration:0.2
                 animations:^{
				self.percentageView.frame = CGRectMake(0,percentageViewY,self.batteryPercentageWidth,percentageViewHeight);

				if(!disableColoring){
					if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
						if([lowPowerModeHexCode isEqualToString:@""]){
							self.percentageView.backgroundColor = [UIColor colorWithRed:lowPowerModeRedFactor green:lowPowerModeGreenFactor blue:lowPowerModeBlueFactor alpha:1.0];
						} else {
							self.percentageView.backgroundColor = [UIColor colorFromHexCode:lowPowerModeHexCode];
						}
					} else if(self.batteryPercentage <= 20){
						if([lowBatteryHexCode isEqualToString:@""]){
							self.percentageView.backgroundColor = [UIColor colorWithRed:lowBatteryRedFactor green:lowBatteryGreenFactor blue:lowBatteryBlueFactor alpha:1.0];
						} else {
							self.percentageView.backgroundColor = [UIColor colorFromHexCode:lowBatteryHexCode];
						}
					} else if([[UIDevice currentDevice] batteryState] == 2){
						if([chargingHexCode isEqualToString:@""]){
							self.percentageView.backgroundColor = [UIColor colorWithRed:chargingRedFactor green:chargingGreenFactor blue:chargingBlueFactor alpha:1.0];
						} else {
							self.percentageView.backgroundColor = [UIColor colorFromHexCode:chargingHexCode];
						}
					} else if([[UIDevice currentDevice] batteryState] == 1 && self.batteryPercentage == 100 && transparentHundred){
						self.percentageView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
					} else {
						if([defaultHexCode isEqualToString:@""]){
							self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
						} else {
							self.percentageView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
						}
					}
				} else {
					if([defaultHexCode isEqualToString:@""]){
						self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
					} else {
						self.percentageView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
					}
				}
			}];
		});
	});

}

%new
-(void)addPercentageBatteryView {

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

	if(isNotchedDevice ||(XDock && !isNotchedDevice) ||HomeGestureInstalled ||(DockXInstalled && DockXIXDock) ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)){

		CAShapeLayer *maskLayer = [CAShapeLayer layer];
		maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:backgroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:(CGSize){30.0, 30.0}].CGPath;
		self.percentageView.layer.mask = maskLayer;
	}

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
				if([lowPowerModeHexCode isEqualToString:@""]){
					self.percentageView.backgroundColor = [UIColor colorWithRed:lowPowerModeRedFactor green:lowPowerModeGreenFactor blue:lowPowerModeBlueFactor alpha:1.0];
				} else {
					self.percentageView.backgroundColor = [UIColor colorFromHexCode:lowPowerModeHexCode];
				}
			} else if(self.batteryPercentage <= 20){
				if([lowBatteryHexCode isEqualToString:@""]){
					self.percentageView.backgroundColor = [UIColor colorWithRed:lowBatteryRedFactor green:lowBatteryGreenFactor blue:lowBatteryBlueFactor alpha:1.0];
				} else {
					self.percentageView.backgroundColor = [UIColor colorFromHexCode:lowBatteryHexCode];
				}
			} else if([[UIDevice currentDevice] batteryState] == 2){
				if([chargingHexCode isEqualToString:@""]){
					self.percentageView.backgroundColor = [UIColor colorWithRed:chargingRedFactor green:chargingGreenFactor blue:chargingBlueFactor alpha:1.0];
				} else {
					self.percentageView.backgroundColor = [UIColor colorFromHexCode:chargingHexCode];
				}
			} else if([[UIDevice currentDevice] batteryState] == 1 && self.batteryPercentage == 100 && transparentHundred){
				self.percentageView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
			} else {
				if([defaultHexCode isEqualToString:@""]){
					self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
				} else {
					self.percentageView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
				}
			}
		} else {
			if([defaultHexCode isEqualToString:@""]){
				self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
			} else {
				self.percentageView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
			}
		}
		
		if(isNotchedDevice || (XDock && !isNotchedDevice) ||HomeGestureInstalled ||DockXInstalled ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)){
			[backgroundView addSubview:self.percentageView];
		} else {
			[self insertSubview:self.percentageView aboveSubview:backgroundView];
		}

		[self updateBatteryViewWidth:nil];
	}
}

%end

%end

%group SBDockViewTint

%hook SBDockView
%property (nonatomic, retain) UIView *percentageView;
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

	if(theDock==nil) {
	
		theDock = self;

	}
}

%new
+(id)sharedDock {
	return theDock;
}

-(void)layoutSubviews {

	%orig;

	[self addPercentageBatteryView];
	[self updateBatteryViewWidth:nil];
}

%new 
-(void)updateBatteryViewWidth:(NSNotification *)notification {

	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
		if(!customPercentEnabled){
			self.batteryPercentage = [[UIDevice currentDevice] batteryLevel] * 100;
		} else {
			self.batteryPercentage = customPercent;
		}
		dispatch_async(dispatch_get_main_queue(), ^(void){
			[UIView animateWithDuration:0.2
                 animations:^{
				if(!disableColoring){
					if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
						if([lowPowerModeHexCode isEqualToString:@""]){
							self.percentageView.backgroundColor = [UIColor colorWithRed:lowPowerModeRedFactor green:lowPowerModeGreenFactor blue:lowPowerModeBlueFactor alpha:1.0];
						} else {
							self.percentageView.backgroundColor = [UIColor colorFromHexCode:lowPowerModeHexCode];
						}
					} else if([[UIDevice currentDevice] batteryState] == 2){
						if([chargingHexCode isEqualToString:@""]){
							self.percentageView.backgroundColor = [UIColor colorWithRed:chargingRedFactor green:chargingGreenFactor blue:chargingBlueFactor alpha:1.0];
						} else {
							self.percentageView.backgroundColor = [UIColor colorFromHexCode:chargingHexCode];
						}
					} else if(self.batteryPercentage <= 20){
						if([lowBatteryHexCode isEqualToString:@""]){
							self.percentageView.backgroundColor = [UIColor colorWithRed:lowBatteryRedFactor green:lowBatteryGreenFactor blue:lowBatteryBlueFactor alpha:1.0];
						} else {
							self.percentageView.backgroundColor = [UIColor colorFromHexCode:lowBatteryHexCode];
						}
					} else {
						if([defaultHexCode isEqualToString:@""]){
							if(defaultRedFactor == 1.0 && defaultGreenFactor == 1.0 && defaultBlueFactor == 1.0){
								self.percentageView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
							} else {
								self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
							}
						} else {
							self.percentageView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
						}
					}
				} else {
					if([defaultHexCode isEqualToString:@""]){
						if(defaultRedFactor == 1.0 && defaultGreenFactor == 1.0 && defaultBlueFactor == 1.0){
							self.percentageView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
						} else {
							self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
						}
					} else {
						self.percentageView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
					}
				}
			}];
		});
	});
}

%new
-(void)addPercentageBatteryView {

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

	if(isNotchedDevice ||(XDock && !isNotchedDevice) ||HomeGestureInstalled ||(DockXInstalled && DockXIXDock) ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)){

		CAShapeLayer *maskLayer = [CAShapeLayer layer];
		maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:backgroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:(CGSize){30.0, 30.0}].CGPath;
		self.percentageView.layer.mask = maskLayer;
	}

	if(!self.percentageView){
		[[NSNotificationCenter defaultCenter] addObserver:self
				selector:@selector(updateBatteryViewWidth:)
				name:@"CenamoInfoChanged"
				object:nil];

		self.percentageView = [[UIView alloc]initWithFrame:CGRectMake(0,0,backgroundView.bounds.size.width,backgroundView.bounds.size.height)];
		self.percentageView.alpha = alphaForBatteryView;

		if(!disableColoring){
			if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
				if([lowPowerModeHexCode isEqualToString:@""]){
					self.percentageView.backgroundColor = [UIColor colorWithRed:lowPowerModeRedFactor green:lowPowerModeGreenFactor blue:lowPowerModeBlueFactor alpha:1.0];
				} else {
					self.percentageView.backgroundColor = [UIColor colorFromHexCode:lowPowerModeHexCode];
				}
			} else if([[UIDevice currentDevice] batteryState] == 2){
				if([chargingHexCode isEqualToString:@""]){
					self.percentageView.backgroundColor = [UIColor colorWithRed:chargingRedFactor green:chargingGreenFactor blue:chargingBlueFactor alpha:1.0];
				} else {
					self.percentageView.backgroundColor = [UIColor colorFromHexCode:chargingHexCode];
				}
			} else if(self.batteryPercentage <= 20){
				if([lowBatteryHexCode isEqualToString:@""]){
					self.percentageView.backgroundColor = [UIColor colorWithRed:lowBatteryRedFactor green:lowBatteryGreenFactor blue:lowBatteryBlueFactor alpha:1.0];
				} else {
					self.percentageView.backgroundColor = [UIColor colorFromHexCode:lowBatteryHexCode];
				}
			} else {
				if([defaultHexCode isEqualToString:@""]){
					if(defaultRedFactor == 1.0 && defaultGreenFactor == 1.0 && defaultBlueFactor == 1.0){
						self.percentageView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
					} else {
						self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
					}
				} else {
					self.percentageView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
				}
			}
		} else {
			if([defaultHexCode isEqualToString:@""]){
				if(defaultRedFactor == 1.0 && defaultGreenFactor == 1.0 && defaultBlueFactor == 1.0){
					self.percentageView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
				} else {
					self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
				}
			} else {
				self.percentageView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
			}
		}

		[backgroundView addSubview:self.percentageView];
	}

	self.percentageView.frame = CGRectMake(0,0,backgroundView.bounds.size.width,backgroundView.bounds.size.height);
	
}

%end

%end

// Floating Dock Temporarly removed because it sucks

%group SBFloatingDockViewios13
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

// XDock and today view bug fix

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

%hook SBIconListPageControl

-(void)setAlpha:(CGFloat)arg1 {
	UIView *superSuper = self.superview.superview;
	if([superSuper isKindOfClass:[objc_getClass("SBRootFolderView") class]]) {
		if(!isNotchedDevice && arg1==0) {
				[theDock setAlpha:0.0];
		} else if(!isNotchedDevice && arg1!=0) {
				[theDock setAlpha:1.0];
		}
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

%ctor {

	preferencesChanged();
	detectFloatingDock();

	if(enabled){
		%init(otherStuff);
		if(floatingDockEnabled && kCFCoreFoundationVersionNumber > 1600) {
			%init(SBFloatingDockViewios13);
		} else if(floatingDockEnabled && kCFCoreFoundationVersionNumber < 1600) {
			
		} else if(percentageOrTint == 0){
			%init(SBDockViewPercentage);
		} else {
			%init(SBDockViewTint);
		}
	}
}