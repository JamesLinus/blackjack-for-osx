/* TableView */

#import <Cocoa/Cocoa.h>

@interface TableView : NSView
{
	NSMutableArray *hand,*splitHand;
	NSColor *bgColor;
	NSBundle *myBundle;
	NSMutableAttributedString *text1, *text2;
	BOOL isDealer,isSplit,secondHand;
}
//- (void)setImage:(NSImage *)newImage;
- (void)clean;
- (void)drawCard:(int)value;
- (void)changeColor:(NSColor *)newColor;
- (void)setIsDealer:(BOOL)dealer;
- (void)setIsSplit:(BOOL)split;
- (void)setSecondHand:(BOOL)secHand;
- (void)setSplitString:(int)which toString:(NSString *)s;
@end
