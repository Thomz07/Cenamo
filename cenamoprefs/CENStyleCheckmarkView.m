#import "CENStyleCheckmarkView.h"
#import <UIKit/UIImage+Private.h>

@implementation StyleCheckmarkView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _configureView];
    }
    return self;
}
-(void)_configureView {
    UIImage *unchecked = [[UIImage kitImageNamed:@"UIRemoveControlMultiNotCheckedImage.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; // switch these?
    UIImage *checked = [[UIImage kitImageNamed:@"UITintedCircularButtonCheckmark.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    _circleImageView = [[UIImageView alloc] initWithImage:unchecked];
    _circleImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_circleImageView sizeToFit];
    [self addSubview:_circleImageView];

    _checkmarkImageView = [[UIImageView alloc] initWithImage:checked];
    _checkmarkImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_checkmarkImageView sizeToFit];
    [self addSubview:_checkmarkImageView];
}
-(void)_updateViewState {
    if (_selected) {
        [UIView animateWithDuration:0.15 animations:^{
            _checkmarkImageView.alpha = 1.f;
        }];
    } else {
        [UIView animateWithDuration:0.15 animations:^{
            _checkmarkImageView.alpha = 0.f;
        }];
    }

}
-(BOOL)isSelected {
    if (_selected) return TRUE;
    else return FALSE;
}
-(void)setSelected:(BOOL)arg1 {
    _selected = arg1;
    [self _updateViewState];
}
@end