#import "CENStyleCheckmarkView.h"

@class StylePickerOptionView;
@protocol StylePickerOptionViewDelegate;

@interface StylePickerOptionView : UIView <UIGestureRecognizerDelegate> {
    UIStackView *_stackView;
    UIImageView *_previewImageView;
    UIImage *_previewImage;
    UILabel *_timeLabel;
    UILabel *_label;
    NSMutableDictionary *_properties;
    UILongPressGestureRecognizer *_pressRecognizer;
    UIImpactFeedbackGenerator *_feedbackGenerator;
    BOOL _highlight;
    BOOL _enabled;
    unsigned long long _appearanceOption;
    StyleCheckmarkView *_checkView;
}
@property (nonatomic,retain) UIStackView * stackView;                                               //@synthesize _stackView=__stackView - In the implementation block
@property (nonatomic,retain) UIImageView * previewImageView;  
@property (nonatomic,retain) UIImage * previewImage;
@property (nonatomic,retain) StyleCheckmarkView * checkView;                                               //@synthesize _stackView=__stackView - In the implementation block                                      //@synthesize _previewImageView=__previewImageView - In the implementation block
@property (nonatomic,retain) UILabel *timeLabel;                                                   //@synthesize _timeLabel=__timeLabel - In the implementation block
@property (nonatomic,retain) UILabel *label;  
@property (nonatomic, retain) NSMutableDictionary *properties;                                                     //@synthesize _label=__label - In the implementation block
//@property (nonatomic,retain) DBSCheckmarkView * _checkmarkView;                                      //@synthesize _checkmarkView=__checkmarkView - In the implementation block
@property (nonatomic,retain) UILongPressGestureRecognizer * pressRecognizer;                         //@synthesize _feedbackGenerator=__feedbackGenerator - In the implementation block
@property (nonatomic,retain) UIImpactFeedbackGenerator * feedbackGenerator;                         //@synthesize _feedbackGenerator=__feedbackGenerator - In the implementation block
@property (assign,nonatomic) BOOL enabled;                                      //@synthesize highlight=_highlight - In the implementation block
@property (assign,getter=highlighted,nonatomic) BOOL highlight;                                      //@synthesize highlight=_highlight - In the implementation block
@property (weak,nonatomic) id<StylePickerOptionViewDelegate> delegate;              //@synthesize delegate=_delegate - In the implementation block
@property (nonatomic,assign) unsigned long long appearanceOption;                                  //@synthesize appearanceOption=_appearanceOption - In the implementation block
-(BOOL)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2 ;
-(BOOL)highlighted;
-(void)setEnabled:(BOOL)enabled;
-(void)setHighlight:(BOOL)arg1 ;
-(void)_configureView;
-(void)setPreviewImage:(UIImage*)image;
- (id)initWithFrame:(struct CGRect)arg1 appearanceOption:(unsigned long long)arg2 ;
-(unsigned long long)appearanceOption;
//-(void)set_checkmarkView:(DBSCheckmarkView *)arg1 ;
-(void)_updateViewForCurrentStyle:(unsigned long long)arg1 ;
-(void)_userDidTapOnView:(id)arg1 ;
@end

@protocol StylePickerOptionViewDelegate <NSObject>
-(void)userDidTapOnAppearanceOptionView:(StylePickerOptionView *)sender ;
@end
