#import "CENStylePickerTableViewCell.h"
#import <UIKit/UIImage+Private.h>
#include <notify.h>


@implementation StylePickerTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

    if (self) {
        [self setClipsToBounds:YES];
        //[self.contentView.widthAnchor constraintEqualToConstant:kCellSize].active = YES;
	[self.contentView.heightAnchor constraintEqualToConstant:210].active = YES;
	    
        _leftOptionView = [[StylePickerOptionView alloc] initWithFrame:CGRectZero appearanceOption:0];
        _leftOptionView.delegate = (id<StylePickerOptionViewDelegate>)self;
        [self.contentView addSubview:_leftOptionView];
        
        _rightOptionView = [[StylePickerOptionView alloc] initWithFrame:CGRectZero appearanceOption:1];
        _rightOptionView.delegate = (id<StylePickerOptionViewDelegate>)self;
        [self.contentView addSubview:_rightOptionView];

        _leftOptionView.translatesAutoresizingMaskIntoConstraints = false;
        [_leftOptionView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor constant:-80].active = YES;
        [_leftOptionView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;

        _rightOptionView.translatesAutoresizingMaskIntoConstraints = false;
        [_rightOptionView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor constant:80].active = YES;
        [_rightOptionView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor].active = YES;
    }
    return self;
}
-(void)setCellTarget:(id)arg1 {
    PSListController *parent = (PSListController *)arg1;
    NSBundle *globalBundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/stylepicker.bundle"];
    NSBundle *prefBundle = [NSBundle bundleForClass:parent.class];
    UIImage *leftImage = [UIImage imageNamed:self.specifier.properties[@"leftStyle"][@"image"] inBundle:prefBundle] ?: [UIImage imageNamed:@"left-image" inBundle:prefBundle];
    UIImage *rightImage = [UIImage imageNamed:self.specifier.properties[@"rightStyle"][@"image"] inBundle:prefBundle] ?: [UIImage imageNamed:@"right-image" inBundle:prefBundle];

    _leftOptionView.label.text = NSLocalizedStringFromTableInBundle(self.specifier.properties[@"leftStyle"][@"label"], @"Prefs", prefBundle, comment) ?: NSLocalizedStringFromTableInBundle(@"LIGHT", @"Common", globalBundle, comment);
    _leftOptionView.previewImage = leftImage ?: [UIImage imageNamed:@"left-image" inBundle:globalBundle];

    _rightOptionView.label.text = NSLocalizedStringFromTableInBundle(self.specifier.properties[@"rightStyle"][@"label"], @"Prefs", prefBundle, comment) ?: NSLocalizedStringFromTableInBundle(@"DARK", @"Common", globalBundle, comment);
    _rightOptionView.previewImage = rightImage ?: [UIImage imageNamed:@"right-image" inBundle:globalBundle];
    
}
-(void)userDidTapOnAppearanceOptionView:(StylePickerOptionView *)sender {
    NSNumber *someNumber = [NSNumber numberWithUnsignedLongLong:sender.appearanceOption];
	
	// If you use this way, you'll have to ask the user to respring to get new changes 
   	//NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", self.specifier.properties[@"defaults"]]];
	//[settings setObject:someNumber forKey:self.specifier.properties[@"key"]];
	//[settings writeToURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:///var/mobile/Library/Preferences/%@.plist", self.specifier.properties[@"defaults"]]] error:nil];
	
	// This way should just work
	CFPreferencesSetAppValue((CFStringRef)self.specifier.properties[@"key"], (CFNumberRef)someNumber, (CFStringRef)self.specifier.properties[@"defaults"]);

    [_leftOptionView _updateViewForCurrentStyle:sender.appearanceOption];
    [_rightOptionView _updateViewForCurrentStyle:sender.appearanceOption];

}
- (CGFloat)preferredHeightForWidth:(CGFloat)width {
    return 210.0f;
}
- (CGFloat)preferredHeightForWidth:(CGFloat)width inTableView:(id)tableView {
    return [self preferredHeightForWidth:width];
}
- (void)didMoveToSuperview {
	[super didMoveToSuperview];

	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", self.specifier.properties[@"defaults"]]];
	NSNumber *num = [settings objectForKey:self.specifier.properties[@"key"]] ?: self.specifier.properties[@"default"];
    unsigned long long apOption = [num longLongValue];

    switch (apOption) {
        case 0:
            _leftOptionView.enabled = YES;
            _rightOptionView.enabled = NO;
            break;
        case 1:
            _leftOptionView.enabled = NO;
            _rightOptionView.enabled = YES;
            break;
    }
}
@end
