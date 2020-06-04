#import "Tweak.h"

%group all

%hook SBDockView
%property (nonatomic, strong) UIView *percentageView;
%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float batteryLevel;
%property (nonatomic, assign) float oldBatteryLevel;

SBWallpaperEffectView *backgroundView;

-(void)layoutSubviews {

	%orig;

	[[NSNotificationCenter defaultCenter] addObserver:self
			selector:@selector(checkBatteryLevel)
			name:@"CenamoBatteryChecking"
			object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
			selector:@selector(updateBatteryViewWidth)
			name:@"CenamoBatteryDidChange"
			object:nil];

	[self checkBatteryLevel];

	self.batteryPercentageWidth = (self.batteryLevel * (backgroundView.bounds.size.width)) / 100;

	self.percentageView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.batteryPercentageWidth,[UIScreen mainScreen].bounds.size.height)];
	self.percentageView.backgroundColor = [UIColor whiteColor];
	self.percentageView.alpha = 1;

	[backgroundView addSubview:self.percentageView];
}

%new
-(void)checkBatteryLevel {
	if(self.batteryLevel != self.oldBatteryLevel){

		[[NSNotificationCenter defaultCenter] postNotificationName:@"CenamoBatteryDidChange" object:nil];
	}

	self.oldBatteryLevel = self.batteryLevel;
}

%new 
-(void)updateBatteryViewWidth {

	backgroundView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");
	self.batteryLevel = [UIDevice currentDevice].batteryLevel * 100;

	NSLog(@"[Cenamo] : battery level is %f", self.batteryLevel);

}

%end

%end

%ctor {

	preferencesChanged();

	if(enabled){
		%init(all);
	}
}