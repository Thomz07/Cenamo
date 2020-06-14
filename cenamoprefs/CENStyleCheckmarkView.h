@interface StyleCheckmarkView : UIView {
    UIImageView *_circleImageView;
    UIImageView *_checkmarkImageView;
    BOOL _selected;
}
@property (nonatomic,retain) UIImageView * circleImageView;                                        //@synthesize _previewImageView=__previewImageView - In the implementation block
@property (nonatomic,retain) UIImageView * checkmarkImageView;                                        //@synthesize _previewImageView=__previewImageView - In the implementation block
@property (assign,nonatomic) BOOL selected;
-(void)setSelected:(BOOL)arg1;
-(void)_configureView;
-(void)_updateViewState;
-(BOOL)isSelected;
-(instancetype)initWithFrame:(CGRect)frame;
@end
