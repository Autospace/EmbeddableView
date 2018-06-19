//
//  WRNEmbeddableView.m
//  WrenGesturesImplementation
//
//  Created by Autospace on 6/13/18.
//  Copyright © 2018 Autospace. All rights reserved.
//

#import "XYZEmbeddableView.h"

@implementation XYZEmbeddableView

- (id)init {
    self = [super init];
    if (self) {
        [self setupGestures];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGestures];
    }
    return self;
}

- (void)setupGestures {
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self addGestureRecognizer:panGestureRecognizer];
    panGestureRecognizer.delegate = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    //tapGestureRecognizer.delegate = self;
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    [self addGestureRecognizer:pinchGestureRecognizer];
    pinchGestureRecognizer.delegate = self;
    UIRotationGestureRecognizer *rotateGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    [self addGestureRecognizer:rotateGestureRecognizer];
    rotateGestureRecognizer.delegate = self;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *) recognizer {
    [self setAnchorPoint:CGPointMake(0.5, 0.5)];
    CGPoint translation = [recognizer translationInView:[recognizer.view superview]];
    self.center = CGPointMake(self.center.x + translation.x, self.center.y + translation.y);
    if (recognizer.state == UIGestureRecognizerStateEnded){
        CGFloat leftPosition = self.frame.origin.x;
        CGFloat rightPosition = leftPosition + self.frame.size.width;
        CGFloat topPosition = self.frame.origin.y;
        CGFloat bottomPosition = topPosition + self.frame.size.height;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationDelegate:self];
        if (self.frame.size.width > self.superview.frame.size.width) {
            if (leftPosition > 0){
                self.center = CGPointMake(self.frame.size.width / 2, self.center.y);
            }
            if (rightPosition < self.superview.frame.size.width) {
                self.center = CGPointMake(self.center.x + (self.superview.frame.size.width - rightPosition), self.center.y);
            }
        } else {
            if (leftPosition < 0){
                self.center = CGPointMake(self.frame.size.width / 2, self.center.y);
            }
            if (rightPosition > self.superview.frame.size.width){
                self.center = CGPointMake(self.center.x - (rightPosition - self.superview.frame.size.width), self.center.y);
            }
        }
        if (self.frame.size.height > self.superview.bounds.size.height){
            if (topPosition > 0){
                self.center = CGPointMake(self.center.x, self.frame.size.height / 2);
            }
            if (bottomPosition < self.superview.frame.size.height) {
                self.center = CGPointMake(self.center.x, self.center.y + (self.superview.frame.size.height - bottomPosition));
            }
        } else {
            if (topPosition < 0){
                self.center = CGPointMake(self.center.x, self.center.y - topPosition);
            }
            if (bottomPosition > self.superview.frame.size.height){
                self.center = CGPointMake(self.center.x, self.center.y - (bottomPosition - self.superview.frame.size.height));
            }
        }
        [UIView commitAnimations];
    }
    [recognizer setTranslation:CGPointZero inView:self];
}

- (void)handleTapGesture:(UITapGestureRecognizer *) recognizer {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete action" message:@"Do you want to delete this item?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self removeFromSuperview]; }];
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:yesButton];
    [alert addAction:noButton];
    [[self superViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *) recognizer {
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint pinchCenter = [recognizer locationInView:self];
        [self setAnchorPoint:CGPointMake(pinchCenter.x / self.bounds.size.width, pinchCenter.y / self.bounds.size.height)];
    }
    self.transform = CGAffineTransformScale(self.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (void)handleRotateGesture:(UIRotationGestureRecognizer *) recognizer {
    [self setAnchorPoint:CGPointMake(0.5, 0.5)];
    self.transform = CGAffineTransformRotate(self.transform, recognizer.rotation);
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat radians = atan2f(self.transform.b, self.transform.a);
        CGFloat degrees = radians * (180 / M_PI);
        double radiansToNearestRightAngle = 0.0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0f];
        [UIView setAnimationDelegate:self];
        if (radians > 0){
            if (degrees < 45) {
                radiansToNearestRightAngle =  -radians;
            } else if (degrees > 45 && degrees < 90){
                radiansToNearestRightAngle = 0.5 * M_PI - radians;
            } else if (degrees > 90 && degrees < 135){
                radiansToNearestRightAngle = 0.5 * M_PI -radians;
            } else if (degrees > 135){
                radiansToNearestRightAngle = M_PI - radians;
            }
        } else {
            if (degrees > -45){
                radiansToNearestRightAngle = -radians;
            } else if (degrees < - 45 && degrees > -90){
                radiansToNearestRightAngle = -0.5 * M_PI - radians;
            } else if (degrees < -90 && degrees > -135){
                radiansToNearestRightAngle = - 0.5 * M_PI - radians;
            } else {
                radiansToNearestRightAngle = M_PI - radians;
            }
        }
        self.transform = CGAffineTransformRotate(self.transform, radiansToNearestRightAngle);
        [UIView commitAnimations];
    }
    recognizer.rotation = 0;
}

- (UIViewController*)superViewController
{
    for (UIView* next = [self superview]; next; next = next.superview){
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

-(void)setAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x,
                                   self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x,
                                   self.bounds.size.height * self.layer.anchorPoint.y);
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
    CGPoint position = self.layer.position;
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    self.layer.position = position;
    self.layer.anchorPoint = anchorPoint;
}

@end
