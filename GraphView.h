//
//  GraphView.h
//  Calculator
//
//  Created by Paul Gambill on 3/16/12.
//  Copyright (c) 2012 Deloitte | Übermind. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphViewDataSource <NSObject>

- (float)yValueForXValue:(float)xValue;

@end

@interface GraphView : UIView

@property (nonatomic) UIViewContentMode contentMode;
@property (nonatomic) CGFloat scale;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@property (nonatomic, strong) id <GraphViewDataSource> dataSource;

@end
