#import "Tweak.h"

// Normal Dock

%group SBDockViewPercentage

%hook SBDockView
%property (nonatomic, retain) UIView *percentageView;
%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float batteryPercentage;

-(id)initWithDockListView:(id)arg1 forSnapshot:(BOOL)arg2 {
	return theDock = %orig;
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

	otherTweakPrefs();

	if(HomeGestureInstalled ||DockX13Installed ||DockXInstalled ||MultiplaInstalled){
		XDock = NO;
	}
}

-(void)layoutSubviews {
	%orig;

	otherTweakPrefs();

	[self updateBatteryViewWidth:nil];
	if(isNotchedDevice ||(XDock && !isNotchedDevice) ||HomeGestureInstalled ||(DockXInstalled && DockXIXDock) ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)){
		CAShapeLayer *maskLayer = [CAShapeLayer layer];
		maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:backgroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:(CGSize){backgroundView.layer.cornerRadius, backgroundView.layer.cornerRadius}].CGPath;
		self.percentageView.layer.mask = maskLayer;
	}
}

-(void)didMoveToWindow {
	%orig;
	[self addPercentageBatteryView];

	if([backgroundView respondsToSelector:@selector(_materialLayer)]){
		((MTMaterialView *)backgroundView).weighting = hideBgView ? 0 : 1;
	}

	if([backgroundView respondsToSelector:@selector(blurView)]){
		((SBWallpaperEffectView *)backgroundView).blurView.hidden = hideBgView ? YES : NO;
	}
}

%new 
-(void)updateBatteryViewWidth:(NSNotification *)notification {
	otherTweakPrefs();

	backgroundView = [self valueForKey:@"backgroundView"];

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
	otherTweakPrefs();

	backgroundView = [self valueForKey:@"backgroundView"];

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
	return theDock = %orig;
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

	otherTweakPrefs();

	if(HomeGestureInstalled ||DockX13Installed ||DockXInstalled ||MultiplaInstalled){
		XDock = NO;
	}
}

-(void)layoutSubviews {
	%orig;

	otherTweakPrefs();

	[self updateBatteryViewWidth:nil];
	if(isNotchedDevice ||(XDock && !isNotchedDevice) ||HomeGestureInstalled ||(DockXInstalled && DockXIXDock) ||DockX13Installed ||(MultiplaInstalled && MultiplaXDock)){
		CAShapeLayer *maskLayer = [CAShapeLayer layer];
		maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:backgroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:(CGSize){backgroundView.layer.cornerRadius, backgroundView.layer.cornerRadius}].CGPath;
		self.percentageView.layer.mask = maskLayer;
	}
}

-(void)didMoveToWindow {
	%orig;
	[self addPercentageBatteryView];

	if([backgroundView respondsToSelector:@selector(_materialLayer)]){
		((MTMaterialView *)backgroundView).weighting = hideBgView ? 0 : 1;
	}

	if([backgroundView respondsToSelector:@selector(blurView)]){
		((SBWallpaperEffectView *)backgroundView).blurView.hidden = hideBgView ? YES : NO;
	}
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
					self.percentageView.frame = CGRectMake(0,0,backgroundView.bounds.size.width,backgroundView.bounds.size.height);
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
	otherTweakPrefs();

	backgroundView = [self valueForKey:@"backgroundView"];

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
	
}
%end
%end

%group SBFloatingDockViewPercentage
%hook SBFloatingDockPlatterView
%property (nonatomic, retain) UIView *percentageView;
%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float batteryPercentage;

-(id)initWithFrame:(CGRect)arg1 {
	return floatingDock = %orig;
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

	XDock = NO;
}

-(id)initWithReferenceHeight:(double)arg1 maximumContinuousCornerRadius:(double)arg2 {
	return floatingDock = %orig;
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

	XDock = NO;
} 

-(void)layoutSubviews {
	%orig;

	[self addPercentageBatteryView];
	[self updateBatteryViewWidth:nil];

	if([self.backgroundView respondsToSelector:@selector(_materialLayer)]){
		((MTMaterialView *)backgroundView).weighting = hideBgView ? 0 : 1;
	}

	if([self.backgroundView respondsToSelector:@selector(blurView)]){
		((SBWallpaperEffectView *)backgroundView).blurView.hidden = hideBgView ? YES : NO;
	}

	CAShapeLayer *maskLayer = [CAShapeLayer layer];
	maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.backgroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:(CGSize){self.backgroundView.layer.cornerRadius, self.backgroundView.layer.cornerRadius}].CGPath;
	self.percentageView.layer.mask = maskLayer;
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
%hook SBFloatingDockPlatterView
%property (nonatomic, retain) UIView *percentageView;
%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float batteryPercentage;

-(id)initWithFrame:(CGRect)arg1 {
	return floatingDock = %orig;
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

	XDock = NO;
}

-(id)initWithReferenceHeight:(double)arg1 maximumContinuousCornerRadius:(double)arg2 {
	return floatingDock = %orig;
	[[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];

	XDock = NO;
}

-(void)layoutSubviews {
	%orig;

	[self addPercentageBatteryView];
	[self updateBatteryViewWidth:nil];

	if([self.backgroundView respondsToSelector:@selector(_materialLayer)]){
		self.backgroundView.alpha = hideBgView ? 0 : 1;
	}

	CAShapeLayer *maskLayer = [CAShapeLayer layer];
	maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.backgroundView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:(CGSize){self.backgroundView.layer.cornerRadius, self.backgroundView.layer.cornerRadius}].CGPath;
	self.percentageView.layer.mask = maskLayer;
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
		
		[self.backgroundView addSubview:self.percentageView];

		[self updateBatteryViewWidth:nil];
	}
}
%end
%end

// Aperio support

%group AperioPercentage
%hook APEPlaceholder
%property (nonatomic, retain) UIView *percentageView;
%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float batteryPercentage;

-(void)layoutSubviews {
	%orig;

	[self updateBatteryViewWidth:nil];
}

-(void)didMoveToWindow {
	%orig;
	[self addPercentageBatteryView];
}

%new 
-(void)updateBatteryViewWidth:(NSNotification *)notification {

	dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){

		float percentageViewHeight = self.bounds.size.height;
		float percentageViewY = 0;

    	if(!customPercentEnabled){
			self.batteryPercentage = [[UIDevice currentDevice] batteryLevel] * 100;
		} else {
			self.batteryPercentage = customPercent;
		}
		self.batteryPercentageWidth = (self.batteryPercentage * (self.bounds.size.width)) / 100;

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

	float percentageViewHeight = self.bounds.size.height;
		float percentageViewY = 0;

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
		
		[self insertSubview:self.percentageView atIndex:1];

		[self updateBatteryViewWidth:nil];
	}
}

%end
%end

%group AperioTint
%hook APEPlaceholder
%property (nonatomic, retain) UIView *percentageView;
%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float batteryPercentage;

-(void)layoutSubviews {
	%orig;

	[self updateBatteryViewWidth:nil];
}

-(void)didMoveToWindow {
	%orig;
	[self addPercentageBatteryView];
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
					self.percentageView.frame = CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height);
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
	otherTweakPrefs();

	if(!self.percentageView){
		[[NSNotificationCenter defaultCenter] addObserver:self
				selector:@selector(updateBatteryViewWidth:)
				name:@"CenamoInfoChanged"
				object:nil];

		self.percentageView = [[UIView alloc]initWithFrame:CGRectMake(0,0,self.bounds.size.width,self.bounds.size.height)];
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

		[self insertSubview:self.percentageView atIndex:1];
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
//
	preferencesChanged();
	otherTweakPrefs();
	detectFloatingDock();
	aperioDetect();

	if(enabled){
		%init(otherStuff);
		if((floatingDockEnabled && kCFCoreFoundationVersionNumber > 1600) || [[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
			if(percentageOrTint == 0){
				%init(SBFloatingDockViewPercentage);
			} else {
				%init(SBFloatingDockViewTint);
			}
		} else if(floatingDockEnabled && kCFCoreFoundationVersionNumber < 1600) {
			
		} else if(AperioInstalled && aperioEnabled){
			if(percentageOrTint == 0){
				%init(AperioPercentage);
			} else {
				%init(AperioTint);
			}
		} else if(!floatingDockEnabled && percentageOrTint == 0){
			%init(SBDockViewPercentage);
		} else {
			%init(SBDockViewTint);
		}
	}
}