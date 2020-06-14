#import "CENStylePickerOptionView.h"

@implementation StylePickerOptionView
@synthesize delegate; //synthesise  MyClassDelegate delegate
- (id)initWithFrame:(struct CGRect)arg1 appearanceOption:(unsigned long long)arg2 {
    self = [super initWithFrame:arg1];
    if (self) {
        _appearanceOption = arg2;
        [self _configureView];
    }
    return self;
}
-(BOOL)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2 {
    return TRUE;
}
-(BOOL)highlighted {
    return self.highlight;
}
-(void)setHighlight:(BOOL)arg1 {
    _highlight = arg1;
    if (_highlight) {
        [UIView animateWithDuration:0.1 animations:^{
            _stackView.alpha = 0.5f;
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            _stackView.alpha = 1.0f;
        }];
    }
}
-(void)_configureView {
    _stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    _stackView.axis = UILayoutConstraintAxisVertical;
    _stackView.alignment = UIStackViewAlignmentCenter;
    _stackView.spacing = 10;
    _stackView.distribution = UIStackViewDistributionEqualSpacing;
    [self addSubview:_stackView];

    _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [_stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [_stackView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [_stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;

    _previewImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _previewImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _previewImageView.clipsToBounds = YES;
    _previewImageView.contentMode = UIViewContentModeScaleAspectFill;
    _previewImageView.layer.cornerRadius = 5;
    [_stackView addArrangedSubview:_previewImageView];

    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [_stackView addArrangedSubview:_label];

    _checkView = [[StyleCheckmarkView alloc] initWithFrame:CGRectZero];
    _checkView.translatesAutoresizingMaskIntoConstraints = NO;
    [_stackView addArrangedSubview:_checkView];
    [_checkView.heightAnchor constraintEqualToConstant:22].active = YES;
    [_checkView.widthAnchor constraintEqualToConstant:22].active = YES;

    _pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_userDidTapOnView:)];
    _pressRecognizer.minimumPressDuration = 0.025; //seconds
    _pressRecognizer.delegate = self;
    [self addGestureRecognizer:_pressRecognizer];
}
-(void)setPreviewImage:(UIImage*)image {
    _previewImage = image;
    _previewImageView.image = _previewImage;
}
-(void)setEnabled:(BOOL)enabled {
    _enabled = enabled;
    if (_enabled) {
        _checkView.selected = YES;
    } else {
        _checkView.selected = NO;
    }
}
-(void)_updateViewForCurrentStyle:(unsigned long long)arg1 {
    if (arg1 == _appearanceOption) {
        self.enabled = YES;
        _feedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [_feedbackGenerator impactOccurred];
    } else self.enabled = NO;
}
-(void)_userDidTapOnView:(id)arg1 {
    if (_pressRecognizer.state == UIGestureRecognizerStateBegan) {
        self.highlight = YES;

    } else if (_pressRecognizer.state == UIGestureRecognizerStateEnded) {
        if (!_checkView.selected) [self.delegate userDidTapOnAppearanceOptionView:self];   
        self.highlight = NO;
    }
}
@end