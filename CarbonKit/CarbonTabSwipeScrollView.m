//  The MIT License (MIT)
//
//  Copyright (c) 2015 - present Ermal Kaleci
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "CarbonTabSwipeScrollView.h"


@implementation CarbonTabSwipeScrollView

- (instancetype)initWithItems:(NSArray *)items {
    self = [self init];
    if (self) {
        [self setItems:items];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Disable scroll indicators
        self.showsHorizontalScrollIndicator = self.showsVerticalScrollIndicator = NO;
        
        if (@available(iOS 11.0, *)) {
            [self setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }
    return self;
}

- (void)setItems:(NSArray *)items {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    // Create Carbon segmented control
    _carbonSegmentedControl = [[CarbonTabSwipeSegmentedControl alloc] initWithItems:items];
    [self addSubview:_carbonSegmentedControl];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.superview != nil)
    [self.superview bringSubviewToFront:self];
    
    if (_carbonSegmentedControl) {
        // Set segmented control height equal to scroll view height
        CGRect segmentRect = _carbonSegmentedControl.frame;
        segmentRect.size.height = CGRectGetHeight(self.frame) - 2 * _padding;
        
        CGRect adjustedRect = segmentRect;
        if (_padding > 0) {
            
            //            NSLog(@"segmentRect.origin.x = %f", segmentRect.origin.x);
            //            NSLog(@"segmentRect.origin.y = %f", segmentRect.origin.y);
            //            NSLog(@"segmentRect.height = %f", segmentRect.size.height);
            if(segmentRect.origin.y == 0) {
                //                segmentRect.origin.y = _padding;
                //segmentRect.size.height = CGRectGetHeight(self.frame) - 2 * _padding;
                //                segmentRect.origin.x = _padding;
                const UIEdgeInsets insets = UIEdgeInsetsMake(0, _padding, 0, -_padding);
                adjustedRect = UIEdgeInsetsInsetRect(segmentRect, insets);
            }
            
            //segmentRect.size.height = CGRectGetHeight(self.frame) - 2 * _padding;
            
            //            NSLog(@"adjustedRect.origin.x = %f", adjustedRect.origin.x);
            //            NSLog(@"adjustedRect.origin.y = %f", adjustedRect.origin.y);
            //            NSLog(@"adjustedRect.height = %f", adjustedRect.size.height);
        }
        
        // update frame
        _carbonSegmentedControl.frame = adjustedRect;
        
        // Min content width equal to scroll view width
        CGFloat contentWidth = MAX(CGRectGetWidth(adjustedRect), CGRectGetWidth(self.frame) + 1);
        
        // Scroll view content size
        self.contentSize = CGSizeMake(contentWidth, CGRectGetHeight(adjustedRect));
    }
}


@end
