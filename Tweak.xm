#import "Tweak.h"

// Normal Dock

%group SBDockViewPercentage

%hook SBDockView
%property (nonatomic, retain) UIView *percentageView;
%property (nonatomic, retain) UIView *mediaView;
%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float mediaWidth;
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

		MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
			NSDictionary *newDict = (__bridge NSDictionary *)information;

			double speed = [[newDict objectForKey:@"kMRMediaRemoteNowPlayingInfoPlaybackRate"] doubleValue];
			float elapsedTime = [[newDict objectForKey:@"kMRMediaRemoteNowPlayingInfoElapsedTime"] floatValue];
			float duration = [[newDict objectForKey:@"kMRMediaRemoteNowPlayingInfoDuration"] floatValue];

				[UIView animateWithDuration:0.2
						animations:^{
							if(speed != 0){
								self.percentageView.alpha = 0;
								self.mediaView.alpha = alphaForBatteryView;
								self.mediaWidth = (elapsedTime * backgroundView.bounds.size.width) / duration;
								NSLog(@"[Cenamo] : Time Stamp is %f", elapsedTime);
								NSLog(@"[Cenamo] : Duration is %f", duration);
							} else {
								self.percentageView.alpha = alphaForBatteryView;
								self.mediaView.alpha = 0;
								NSLog(@"[Cenamo] : Time Stamp is %f", elapsedTime);
								NSLog(@"[Cenamo] : Duration is %f", duration);
							}
						}
				];
		});

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
				self.mediaView.frame = CGRectMake(0,percentageViewY,self.mediaWidth,percentageViewHeight);

				if(!disableColoring){
					if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
						if([lowPowerModeHexCode isEqualToString:@""]){
							self.percentageView.backgroundColor = [UIColor colorWithRed:lowPowerModeRedFactor green:lowPowerModeGreenFactor blue:lowPowerModeBlueFactor alpha:1.0];
							self.mediaView.backgroundColor = [UIColor colorWithRed:lowPowerModeRedFactor green:lowPowerModeGreenFactor blue:lowPowerModeBlueFactor alpha:1.0];
						} else {
							self.percentageView.backgroundColor = [UIColor colorFromHexCode:lowPowerModeHexCode];
							self.mediaView.backgroundColor = [UIColor colorFromHexCode:lowPowerModeHexCode];
						}
					} else if(self.batteryPercentage <= 20){
						if([lowBatteryHexCode isEqualToString:@""]){
							self.percentageView.backgroundColor = [UIColor colorWithRed:lowBatteryRedFactor green:lowBatteryGreenFactor blue:lowBatteryBlueFactor alpha:1.0];
							self.mediaView.backgroundColor = [UIColor colorWithRed:lowBatteryRedFactor green:lowBatteryGreenFactor blue:lowBatteryBlueFactor alpha:1.0];
						} else {
							self.percentageView.backgroundColor = [UIColor colorFromHexCode:lowBatteryHexCode];
							self.mediaView.backgroundColor = [UIColor colorFromHexCode:lowBatteryHexCode];
						}
					} else if([[UIDevice currentDevice] batteryState] == 2){
						if([chargingHexCode isEqualToString:@""]){
							self.percentageView.backgroundColor = [UIColor colorWithRed:chargingRedFactor green:chargingGreenFactor blue:chargingBlueFactor alpha:1.0];
							self.mediaView.backgroundColor = [UIColor colorWithRed:chargingRedFactor green:chargingGreenFactor blue:chargingBlueFactor alpha:1.0];
						} else {
							self.percentageView.backgroundColor = [UIColor colorFromHexCode:chargingHexCode];
							self.mediaView.backgroundColor = [UIColor colorFromHexCode:chargingHexCode];
						}
					} else if([[UIDevice currentDevice] batteryState] == 1 && self.batteryPercentage == 100 && transparentHundred){
						self.percentageView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
					} else {
						if([defaultHexCode isEqualToString:@""]){
							self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
							self.mediaView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
						} else {
							self.percentageView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
							self.mediaView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
						}
					}
				} else {
					if([defaultHexCode isEqualToString:@""]){
						self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
						self.mediaView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
					} else {
						self.percentageView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
						self.mediaView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
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
		maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:backgroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:(CGSize){backgroundView.layer.cornerRadius, backgroundView.layer.cornerRadius}].CGPath;
		self.percentageView.layer.mask = maskLayer;

		CAShapeLayer *maskLayer2 = [CAShapeLayer layer];
		maskLayer2.path = [UIBezierPath bezierPathWithRoundedRect:backgroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:(CGSize){backgroundView.layer.cornerRadius, backgroundView.layer.cornerRadius}].CGPath;
		self.mediaView.layer.mask = maskLayer2;
	}

	float percentageViewHeight = (isNotchedDevice ||(XDock && !isNotchedDevice) ||HomeGestureInstalled ||(DockXInstalled && DockXIXDock) ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)) ? backgroundView.bounds.size.height : self.bounds.size.height - 4;
	float percentageViewY = (isNotchedDevice ||(XDock && !isNotchedDevice) ||HomeGestureInstalled ||(DockXInstalled && DockXIXDock) ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)) ? 0 : 4;

	if(!self.percentageView && !self.mediaView){

		[[NSNotificationCenter defaultCenter] addObserver:self
				selector:@selector(updateBatteryViewWidth:)
				name:@"CenamoInfoChanged"
				object:nil];

		self.percentageView = [[UIView alloc] initWithFrame:CGRectMake(0,percentageViewY,self.batteryPercentageWidth,percentageViewHeight)];
		self.percentageView.alpha = alphaForBatteryView;

		self.mediaView = [[UIView alloc] initWithFrame:CGRectMake(0,percentageViewY,self.mediaWidth,percentageViewHeight)];
		self.mediaView.alpha = 0;

		self.percentageView.layer.masksToBounds = YES;
		self.percentageView.layer.cornerRadius = rounderCornersRadius;

		self.mediaView.layer.masksToBounds = YES;
		self.mediaView.layer.cornerRadius = rounderCornersRadius;

		if(!disableColoring){
			if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
				if([lowPowerModeHexCode isEqualToString:@""]){
					self.percentageView.backgroundColor = [UIColor colorWithRed:lowPowerModeRedFactor green:lowPowerModeGreenFactor blue:lowPowerModeBlueFactor alpha:1.0];
					self.mediaView.backgroundColor = [UIColor colorWithRed:lowPowerModeRedFactor green:lowPowerModeGreenFactor blue:lowPowerModeBlueFactor alpha:1.0];
				} else {
					self.percentageView.backgroundColor = [UIColor colorFromHexCode:lowPowerModeHexCode];
					self.mediaView.backgroundColor = [UIColor colorFromHexCode:lowPowerModeHexCode];
				}
			} else if(self.batteryPercentage <= 20){
				if([lowBatteryHexCode isEqualToString:@""]){
					self.percentageView.backgroundColor = [UIColor colorWithRed:lowBatteryRedFactor green:lowBatteryGreenFactor blue:lowBatteryBlueFactor alpha:1.0];
					self.mediaView.backgroundColor = [UIColor colorWithRed:lowBatteryRedFactor green:lowBatteryGreenFactor blue:lowBatteryBlueFactor alpha:1.0];
				} else {
					self.percentageView.backgroundColor = [UIColor colorFromHexCode:lowBatteryHexCode];
					self.mediaView.backgroundColor = [UIColor colorFromHexCode:lowBatteryHexCode];
				}
			} else if([[UIDevice currentDevice] batteryState] == 2){
				if([chargingHexCode isEqualToString:@""]){
					self.percentageView.backgroundColor = [UIColor colorWithRed:chargingRedFactor green:chargingGreenFactor blue:chargingBlueFactor alpha:1.0];
					self.mediaView.backgroundColor = [UIColor colorWithRed:chargingRedFactor green:chargingGreenFactor blue:chargingBlueFactor alpha:1.0];
				} else {
					self.percentageView.backgroundColor = [UIColor colorFromHexCode:chargingHexCode];
					self.mediaView.backgroundColor = [UIColor colorFromHexCode:chargingHexCode];
				}
			} else if([[UIDevice currentDevice] batteryState] == 1 && self.batteryPercentage == 100 && transparentHundred){
				self.percentageView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.0];
			} else {
				if([defaultHexCode isEqualToString:@""]){
					self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
					self.mediaView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
				} else {
					self.percentageView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
					self.mediaView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
				}
			}
		} else {
			if([defaultHexCode isEqualToString:@""]){
				self.percentageView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
				self.mediaView.backgroundColor = [UIColor colorWithRed:defaultRedFactor green:defaultGreenFactor blue:defaultBlueFactor alpha:1.0];
			} else {
				self.percentageView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
				self.mediaView.backgroundColor = [UIColor colorFromHexCode:defaultHexCode];
			}
		}
		
		if(isNotchedDevice || (XDock && !isNotchedDevice) ||HomeGestureInstalled ||DockXInstalled ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)){
			[backgroundView addSubview:self.percentageView];
			[backgroundView addSubview:self.mediaView];
		} else {
			[self insertSubview:self.percentageView aboveSubview:backgroundView];
			[self insertSubview:self.mediaView aboveSubview:backgroundView];
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
		maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:backgroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:(CGSize){backgroundView.layer.cornerRadius, backgroundView.layer.cornerRadius}].CGPath;
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

%group SBFloatingDockViewPercentage
%hook SBFloatingDockView
%property (nonatomic, retain) UIView *percentageView;
%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float batteryPercentage;

-(id)initWithFrame:(CGRect)arg1 {
	return %orig;
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

	XDock = NO;

	if(theDock==nil) {
	
		floatingDock = self;

	}
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
		float percentageViewHeight = self.backgroundView.bounds.size.height;
		self.batteryPercentageWidth = (self.batteryPercentage * (self.backgroundView.bounds.size.width)) / 100;
		dispatch_async(dispatch_get_main_queue(), ^(void){
			[UIView animateWithDuration:0.2
                 animations:^{
				self.percentageView.frame = CGRectMake(0,0,self.batteryPercentageWidth,percentageViewHeight);

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

	CAShapeLayer *maskLayer = [CAShapeLayer layer];
	maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.backgroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:(CGSize){self.backgroundView.layer.cornerRadius, self.backgroundView.layer.cornerRadius}].CGPath;
	self.percentageView.layer.mask = maskLayer;

	if(!self.percentageView){

		[[NSNotificationCenter defaultCenter] addObserver:self
				selector:@selector(updateBatteryViewWidth:)
				name:@"CenamoInfoChanged"
				object:nil];

		float percentageViewHeight = self.backgroundView.bounds.size.height;
		self.batteryPercentageWidth = (self.batteryPercentage * (self.backgroundView.bounds.size.width)) / 100;

		self.percentageView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.batteryPercentageWidth,percentageViewHeight)];
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
		
		[self.backgroundView addSubview:self.percentageView];

		[self updateBatteryViewWidth:nil];
	}
}
%end
%end

%group SBFloatingDockViewTint
%hook SBFloatingDockView
%property (nonatomic, retain) UIView *percentageView;
%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float batteryPercentage;

-(id)initWithFrame:(CGRect)arg1 {
	return %orig;
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

	XDock = NO;

	if(theDock==nil) {
	
		floatingDock = self;

	}
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
		float percentageViewHeight = self.backgroundView.bounds.size.height;
		self.batteryPercentageWidth = self.backgroundView.bounds.size.width;
		dispatch_async(dispatch_get_main_queue(), ^(void){
			[UIView animateWithDuration:0.2
                 animations:^{
				self.percentageView.frame = CGRectMake(0,0,self.batteryPercentageWidth,percentageViewHeight);

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

	CAShapeLayer *maskLayer = [CAShapeLayer layer];
	maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.backgroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:(CGSize){self.backgroundView.layer.cornerRadius, self.backgroundView.layer.cornerRadius}].CGPath;
	self.percentageView.layer.mask = maskLayer;

	if(!self.percentageView){

		[[NSNotificationCenter defaultCenter] addObserver:self
				selector:@selector(updateBatteryViewWidth:)
				name:@"CenamoInfoChanged"
				object:nil];

		float percentageViewHeight = self.backgroundView.bounds.size.height;
		self.batteryPercentageWidth = self.backgroundView.bounds.size.width;

		self.percentageView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.batteryPercentageWidth,percentageViewHeight)];
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

%hook SBMediaController

-(void)_mediaRemoteNowPlayingInfoDidChange:(id)arg1 {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"CenamoInfoChanged" object:nil userInfo:nil];
	%orig;
}

%end

%end

%ctor {

	preferencesChanged();
	detectFloatingDock();

	if(enabled){
		%init(otherStuff);
		if((floatingDockEnabled && kCFCoreFoundationVersionNumber > 1600) || [[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
			if(percentageOrTint == 0){
				%init(SBFloatingDockViewPercentage);
			} else {
				%init(SBFloatingDockViewTint);
			}
		} else if(floatingDockEnabled && kCFCoreFoundationVersionNumber < 1600) {
			
		} else if(!floatingDockEnabled && percentageOrTint == 0){
			%init(SBDockViewPercentage);
		} else {
			%init(SBDockViewTint);
		}
	}
}