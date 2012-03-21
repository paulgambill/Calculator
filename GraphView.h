//
//  GraphView.h
//  Calculator
//
//  Created by Paul Gambill on 3/16/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewDelegate <NSObject>
- (double)yValueForXValue:(double)xValue;
@end

@interface GraphView : UIView

@property (nonatomic) UIViewContentMode contentMode;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGPoint graphOrigin;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@property (nonatomic, weak) id <GraphViewDelegate> dataSource;

@end
