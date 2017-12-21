//
//  UITableView+CCPIndexView.m
//  CCPIndexView
//
//  Created by chuchengpeng on 2017/12/21.
//  Copyright © 2017年 chuchengpeng. All rights reserved.
//

#import "UITableView+CCPIndexView.h"
#import "Aspects.h"
#import <objc/runtime.h>


@interface IndexLabel:UILabel
@end

@implementation IndexLabel

- (instancetype)init {
    if (self = [super init]) {
        self.bounds = CGRectMake(0, 0, 60, 60);
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:18 weight:1.5];
        self.adjustsFontSizeToFitWidth = YES;
        self.textAlignment = NSTextAlignmentCenter;
        self.layer.cornerRadius = 30;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:65/255 green:65/255 blue:125/255 alpha:0.5];
        // [self circelLayer];
    }
    return self;
}

- (void)circelLayer {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(40, 0)];
    [path addLineToPoint:CGPointMake(50, 15)];
    [path addLineToPoint:CGPointMake(40, 30)];
    [path addLineToPoint:CGPointMake(0, 30)];
    [path addArcWithCenter:CGPointMake(0, 15) radius:15 startAngle:M_PI_2 endAngle:M_PI*3/2 clockwise:YES];
    layer.path = path.CGPath;
    [layer setFillColor:[UIColor clearColor].CGColor];
    [layer setStrokeColor:[UIColor redColor].CGColor];
    layer.lineCap = @"round";
    [self.layer insertSublayer:layer atIndex:0];
}
@end

@interface UITableView ()

//
@property (nonatomic, strong) IndexLabel *idLabel;

@end

static const void *indexLabel_key = &indexLabel_key;
@implementation UITableView (CCPIndexView)

- (void)setIdLabel:(IndexLabel *)idLabel {
    objc_setAssociatedObject(self, indexLabel_key, idLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (IndexLabel *)idLabel {
    return objc_getAssociatedObject(self, &indexLabel_key);
}

- (void)ccpIndexView {
    if (self.idLabel == nil) {
        self.idLabel = [[IndexLabel alloc] init];
    }
    id delegate = self.delegate;
    NSAssert(delegate, @"请设置UITableViewDelegate");
    BOOL isRs = [delegate respondsToSelector:@selector(sectionIndexTitlesForTableView:)];
    BOOL isRs1 = [delegate respondsToSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:)];
    NSAssert(isRs, @"请实现sectionIndexTitlesForTableView:");
    NSAssert(isRs1, @"请实现tableView:sectionForSectionIndexTitle:atIndex:");
    
    [delegate aspect_hookSelector:@selector(tableView:sectionForSectionIndexTitle:atIndex:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>info ,UITableView *tableView, NSString *title, NSInteger index) {
        [self addIndexLabelWithText:title atIndex:index];
    } error:NULL];
}


- (void)addIndexLabelWithText:(NSString *)text atIndex:(NSInteger)idx {
    UIView *aview = self.subviews.lastObject;
    BOOL isIndexView = [NSStringFromClass([aview class]) isEqualToString:@"UITableViewIndex"];
    if (!isIndexView) {
        for (id obj in self.subviews) {
            BOOL isIdx = [NSStringFromClass([obj class]) isEqualToString:@"UITableViewIndex"];
            if (isIdx) {
                aview = obj;
                break;
            }
        }
    }
    CGPoint cp = CGPointMake(-66, CGRectGetHeight(aview.bounds)/2);
    self.idLabel.center = cp;
    if (self.idLabel.superview != aview) {
        [aview addSubview:self.idLabel];
        self.idLabel.hidden = text.length == 0;
    }
    [aview aspect_hookSelector:@selector(touchesBegan:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet<UITouch *> *touches,UIEvent *event) {
        UITouch *touch = [touches anyObject];
        CGPoint center = self.idLabel.center;
        center.y = [touch locationInView:aview].y;
        self.idLabel.center = center;
        self.idLabel.hidden = NO;
    } error:NULL];
    [aview aspect_hookSelector:@selector(touchesMoved:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
        UITouch *touch = [touches anyObject];
        CGPoint center = self.idLabel.center;
        center.y = [touch locationInView:aview].y;
        self.idLabel.center = center;
        self.idLabel.hidden = NO;
    } error:NULL];
    [aview aspect_hookSelector:@selector(touchesEnded:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
        UITouch *touch = [touches anyObject];
        CGPoint center = self.idLabel.center;
        center.y = [touch locationInView:aview].y;
        self.idLabel.center = center;
        self.idLabel.hidden = YES;
    } error:NULL];
    [aview aspect_hookSelector:@selector(touchesCancelled:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches,UIEvent *event) {
        self.idLabel.hidden = YES;
    } error:NULL];
    self.idLabel.text = text;
}


@end
