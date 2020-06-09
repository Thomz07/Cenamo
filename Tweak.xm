#import "Tweak.h"

%group all

%hook SBDockView
%property (nonatomic, retain) UIView *percentageView;
%property (nonatomic, assign) bool isObserving;

%property (nonatomic, assign) float batteryPercentageWidth;
%property (nonatomic, assign) float batteryPercentage;

-(void)layoutSubviews {

	%orig;

	//if(!self.isObserving){

		[self addPercentageBatteryView];

		[[NSNotificationCenter defaultCenter] addObserver:self
			selector:@selector(updateBatteryViewWidth:)
			name:@"CenamoInfoChanged"
			object:nil];

		[self updateBatteryViewWidth:nil];

	//}
}

%new 
-(void)updateBatteryViewWidth:(NSNotification *)notification {

	SBWallpaperEffectView *backgroundView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");

	self.batteryPercentage = [[UIDevice currentDevice] batteryLevel] * 100;
	self.batteryPercentageWidth = (self.batteryPercentage * (backgroundView.bounds.size.width)) / 100;

	self.percentageView.frame = CGRectMake(0,0,self.batteryPercentageWidth,[UIScreen mainScreen].bounds.size.height);

	NSLog(@"[Cenamo] : Battery info changed, battery level is %f", self.batteryPercentage);

}

%new
-(void)addPercentageBatteryView {

	SBWallpaperEffectView *backgroundView = MSHookIvar<SBWallpaperEffectView *>(self, "_backgroundView");

	if(!self.percentageView){
		self.percentageView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.batteryPercentageWidth,[UIScreen mainScreen].bounds.size.height)];
		self.percentageView.alpha = alphaForBatteryView;
		self.percentageView.backgroundColor = [UIColor whiteColor];

		[backgroundView addSubview:self.percentageView];
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

	if(enabled){
		%init(all);
	}
}