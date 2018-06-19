//
//  ViewController.m
//  WrenGesturesImplementation
//
//  Created by Autospace on 6/13/18.
//  Copyright © 2018 Autospace. All rights reserved.
//

#import "ViewController.h"
#import "XYZEmbeddableView.h"

@interface ViewController ()

@property BOOL isLongPressStarted;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isLongPressStarted = NO;
}

- (IBAction) handleLongPressGesture:(UILongPressGestureRecognizer *) recognizer {
    recognizer.minimumPressDuration = 1.0; //one second
    if (!self.isLongPressStarted){
        self.isLongPressStarted = YES;
        CGPoint coords = [recognizer locationInView:self.view];
        CGRect embeddableViewFrame = CGRectMake(coords.x, coords.y, 150.0, 150.0);
        XYZEmbeddableView *view = [[XYZEmbeddableView alloc] initWithFrame:embeddableViewFrame];
        [self setBackgroundImageForView:view withFrame:embeddableViewFrame];
        view.layer.cornerRadius = 10;
        [self.view addSubview:view];
    }
    
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        self.isLongPressStarted = NO;
    }
}

- (void)setBackgroundImageForView:(UIView *) view withFrame:(CGRect)frame {
    UIImage *image =[UIImage imageNamed:@"wallpaper-image"];
    CGFloat frameWidth = image.size.width * (frame.size.height / image.size.height);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frameWidth, frame.size.height)];
    [imageView setImage:image];
    [view setFrame:CGRectMake(frame.origin.x - frameWidth / 2, frame.origin.y - frame.size.height / 2, frameWidth, frame.size.height)];
    [view addSubview:imageView];
}

@end
