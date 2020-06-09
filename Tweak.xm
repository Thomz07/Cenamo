#import "Tweak.h"

%group all

%hook SBDockView
%property (nonatomic, strong) UIView *percentageView;
%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float batteryLevel;

SBWallpaperEffectView *backgroundView;

-(id)initWithDockListView:(id)arg1 forSnapshot:(BOOL)arg2 {

	[[NSNotificationCenter defaultCenter] addObserver:self
			selector:@selector(updateBatteryViewWidth)
			name:@"CenamoBatteryDidChange"
			object:nil];

	[self updateBatteryViewWidth];

	%orig;
	return %orig;
}

-(void)layoutSubviews {

	%orig;

	backgroundView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");

	self.batteryPercentageWidth = (self.batteryLevel * (backgroundView.bounds.size.width)) / 100;

	self.percentageView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.batteryPercentageWidth,[UIScreen mainScreen].bounds.size.height)];
	self.percentageView.alpha = 1;

	[backgroundView addSubview:self.percentageView];
}

%new 
-(void)updateBatteryViewWidth {

	self.batteryLevel = [UIDevice currentDevice].batteryLevel * 100;

	if ([[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
		self.percentageView.backgroundColor = [UIColor yellowColor];
	} else {
		self.percentageView.backgroundColor = [UIColor whiteColor];
	}

	NSLog(@"[Cenamo] : battery level is %f", self.batteryLevel);

}

%end

%hook BCBatteryDevice

-(void)setCharging:(BOOL)arg1 {
    //sends the noti to update battery info
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CenamoBatteryDidChange" object:nil userInfo:nil];
    %orig;
}

-(void)setBatterySaverModeActive:(BOOL)arg1 {
    //sends the noti to update battery info
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CenamoBatteryDidChange" object:nil userInfo:nil];
    %orig;
}

-(void)setPercentCharge:(NSInteger)arg1 {
    //sends the noti to update battery info
    if(arg1!=0) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CenamoBatteryDidChange" object:nil userInfo:nil];
    }
    %orig;
}

%end

%end

%ctor {

	preferencesChanged();

	if(enabled){
		%init(all);
	}
}