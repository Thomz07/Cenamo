@interface UIDevice (notchedDevice)
@property (nonatomic,readonly) NSString * model;
-(NSString *)model;
// new methods
-(BOOL)isNotched;
-(BOOL)isAnIpad;
-(BOOL)isAnIpod;
@end

@interface UIDevice (currentProduct)
-(id)_currentProduct;
@end