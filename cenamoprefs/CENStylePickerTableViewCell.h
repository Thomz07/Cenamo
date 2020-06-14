#include <Preferences/PSTableCell.h>
#include <Preferences/PSSpecifier.h>
#include <Preferences/PSListController.h>
#include "CENStylePickerOptionView.h"

@interface StylePickerTableViewCell : PSTableCell {
    StylePickerOptionView *_leftOptionView;
    StylePickerOptionView *_rightOptionView;
    PSListController *_parent;
}
@property (nonatomic,retain) StylePickerOptionView * leftOptionView;                                            //@synthesize _trailingGuide=__trailingGuide - In the implementation block
@property (nonatomic,retain) StylePickerOptionView * rightOptionView;                                            //@synthesize _trailingGuide=__trailingGuide - In the implementation block
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier;
- (void)didMoveToSuperview;
@end