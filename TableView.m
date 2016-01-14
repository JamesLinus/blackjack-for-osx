#import "TableView.h"

@implementation TableView

- (id)initWithFrame:(NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		// Add initialization code here
	}
	myBundle = [NSBundle mainBundle];
	return self;
}

- (void)drawRect:(NSRect)rect
{
	NSRect bounds = [self bounds];
	NSString *path;
	NSImage *image;
	NSEnumerator *e;
	NSRect imageRect;
	NSRect drawingRect;
	NSSize imageSize;
	int i = 0;
	[bgColor set];
	[NSBezierPath fillRect:bounds];
	e = [hand objectEnumerator];
	imageRect.origin = NSZeroPoint;
	if(isSplit) {
		while (image = [e nextObject]) {
			imageSize = [image size];
			imageRect.size.height = imageSize.height;
			if(i == [hand count] - 1)
				imageRect.size.width = imageSize.width;
			else
				imageRect.size.width = imageSize.width/2;
			drawingRect.size = imageRect.size;
			drawingRect.origin.x = 40 + (i * imageSize.width/2);
			drawingRect.origin.y = (bounds.size.height - imageSize.height) / 2;
			[image drawInRect:drawingRect
					 fromRect:imageRect
					operation:NSCompositeSourceOver
					 fraction:1.0];
			i++;
		}
		if(text1)
			[text1 drawAtPoint:NSMakePoint(40,185)];
		i = 0;
		e = [splitHand objectEnumerator];
		while (image = [e nextObject]) {
			imageSize = [image size];
			imageRect.size.height = imageSize.height;
			if(i == [splitHand count] - 1)
				imageRect.size.width = imageSize.width;
			else
				imageRect.size.width = imageSize.width/2;
			drawingRect.size = imageRect.size;
			drawingRect.origin.x = 440 + (i * imageSize.width/2);
			drawingRect.origin.y = (bounds.size.height - imageSize.height) / 2;
			[image drawInRect:drawingRect
					 fromRect:imageRect
					operation:NSCompositeSourceOver
					 fraction:1.0];
			i++;
		}
		if(text2)
			[text2 drawAtPoint:NSMakePoint(440,185)];
	} else {
		while (image = [e nextObject]) {
			if (i==0 && isDealer) {
				path = [myBundle pathForImageResource:@"b1fv"];
				image = [[NSImage alloc] initWithContentsOfFile:path];
			}
			imageRect.size = [image size];
			drawingRect.size = imageRect.size;
			drawingRect.origin.x = 40 + (i * (imageRect.size.width + 40));
			drawingRect.origin.y = (bounds.size.height - imageRect.size.height) / 2;
		
			[image drawInRect:drawingRect
					 fromRect:imageRect
					operation:NSCompositeSourceOver
					 fraction:1.0];
			if(i==0 && isDealer)
				[image release];
			i++;
		}
	}
}

- (void)changeColor:(NSColor *)newColor
{
	[newColor retain];
	[bgColor release];
	bgColor = newColor;
	[self setNeedsDisplay:YES];
}

- (void)clean
{
	[hand release];
	hand = [[NSMutableArray alloc] initWithCapacity:5];
	if(splitHand)
		[splitHand release];
	if(text1)
		[text1 release];
	if(text2)
		[text2 release];
	splitHand = nil;
	text1 = nil;
	text2 = nil;
	isSplit = NO;
	secondHand = NO;
}

- (void)drawCard:(int)value;
{
	NSString *path;
	NSImage *image;
	
	path = [myBundle pathForImageResource:[NSString stringWithFormat:@"%d",value+1]];
	image = [[NSImage alloc] initWithContentsOfFile:path];
	if(image == nil)
		NSLog(@"File Error!");
	if (isSplit && secondHand) {
		[splitHand addObject:image];
	} else {
		[hand addObject:image];
	}
	[image release];
	[self setNeedsDisplay:YES];
}

- (void)setIsDealer:(BOOL)dealer
{
	isDealer = dealer;
}

- (void)setSecondHand:(BOOL)secHand
{
	secondHand = secHand;
	if(secondHand){
		text2 = text1;
		text1 = nil;
	}
}

- (void)setIsSplit:(BOOL)split
{
	
	isSplit = split;
	if(split) {
		splitHand = [[NSMutableArray alloc] init];
		[splitHand addObject:[hand objectAtIndex:1]];
		[hand removeObjectAtIndex:1];
		text1 = [[NSMutableAttributedString alloc] initWithString:@"Active hand"];
		[text1 addAttribute:NSFontAttributeName
					  value:[NSFont userFontOfSize:22]
					  range:NSMakeRange(0,[text1 length])];
		[self setNeedsDisplay:YES];
	}
}

- (void)setSplitString:(int)which toString:(NSString *)s
{
	if(which == 1) {
		text1 = [[NSMutableAttributedString alloc] initWithString:s];
		[text1 addAttribute:NSFontAttributeName
					  value:[NSFont userFontOfSize:22]
					  range:NSMakeRange(0,[text1 length])];
	}
	if(which == 2)
		[text2 replaceCharactersInRange:NSMakeRange(0,[text2 length]) withString:s];
}

/*- (void)setImage:(NSImage *)newImage
{
	NSPoint result;
	NSRect r;
	NSSize imgSize;
	int width, height, imgWidth, imgHeight;
	
	[newImage retain];
	if(image != nil) {
		[image release];
	}
	image = newImage;
	r = [self bounds];
	width = round(r.size.width);
	height = round(r.size.height);
	imgSize = [image size];
	imgWidth = round(imgSize.width);
	imgHeight = round(imgSize.height);
	result.x = random() % (width - imgWidth);
	result.y = random() % (height - imgHeight);
	cardOrigin = result;
	
	[self setNeedsDisplay:YES];
}*/

- (void)dealloc
{
	[hand release];
	[splitHand release];
	[bgColor release];
	[myBundle release];
	[super dealloc];
}

@end
