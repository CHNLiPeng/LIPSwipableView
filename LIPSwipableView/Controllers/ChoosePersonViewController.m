//
// ChoosePersonViewController.m
//
// Copyright (c) 2014 to present, Brian Gesiak @modocache
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "ChoosePersonViewController.h"
#import "Person.h"
#import "LIPSwipeToChoose.h"

static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;

@interface ChoosePersonViewController ()
@property (nonatomic, strong) NSMutableArray *people;


//Property For Undo
@property (nonatomic,strong) UIButton *undoButton;
@property (nonatomic,strong) Person *lastRemovedPerson;
@property (nonatomic,strong) Person *undoPerson;
@property (nonatomic,assign) LIPSwipeDirection undoDirection;
@end

@implementation ChoosePersonViewController

#pragma mark - Object Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        // This view controller maintains a list of ChoosePersonView
        // instances to display.
        _people = [[self defaultPeople] mutableCopy];
    }
    return self;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];

    // Display the first ChoosePersonView in front. Users can swipe to indicate
    // whether they like or dislike the person displayed.
    self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
    [self.view addSubview:self.frontCardView];

    // Display the second ChoosePersonView in back. This view controller uses
    // the LIPSwipeToChooseDelegate protocol methods to update the front and
    // back views after each user swipe.
    self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
    [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];

    // Add buttons to programmatically swipe the view left or right.
    // See the `nopeFrontCardView` and `likeFrontCardView` methods.
    [self constructNopeButton];
    [self constructLikedButton];
    [self constructUndoButton];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - LIPSwipeToChooseDelegate Protocol Methods

// This is called when a user didn't fully swipe left or right.
- (void)viewDidCancelSwipe:(UIView *)view {
    NSLog(@"You couldn't decide on %@.", self.currentPerson.name);
}

// This is called then a user swipes the view fully left or right.
- (void)view:(UIView *)view wasChosenWithDirection:(LIPSwipeDirection)direction {
    // LIPSwipeToChooseView shows "NOPE" on swipes to the left,
    // and "LIKED" on swipes to the right.
    if (direction == LIPSwipeDirectionLeft) {
        NSLog(@"You noped %@.", self.currentPerson.name);
    } else if(direction==LIPSwipeDirectionRight) {
        NSLog(@"You liked %@.", self.currentPerson.name);
    }else {
        NSLog(@"You UP %@.", self.currentPerson.name);
    };

    // LIPSwipeToChooseView removes the view from the view hierarchy
    // after it is swiped (this behavior can be customized via the
    // LIPSwipeOptions class). Since the front card view is gone, we
    // move the back card to the front, and create a new back card.
    self.undoPerson=((ChoosePersonView*)self.frontCardView).person;
    self.undoButton.userInteractionEnabled=YES;
    self.undoDirection=direction;
    
    
    self.frontCardView = self.backCardView;
    if ((self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        // Fade the back card into view.
        self.backCardView.alpha = 0.f;
        [self.view insertSubview:self.backCardView belowSubview:self.frontCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.backCardView.alpha = 1.f;
                         } completion:nil];
    }
}

#pragma mark - Internal Methods

- (void)setFrontCardView:(ChoosePersonView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    self.currentPerson = frontCardView.person;
}

- (NSArray *)defaultPeople {
    // It would be trivial to download these from a web service
    // as needed, but for the purposes of this sample app we'll
    // simply store them in memory.
    return @[
        [[Person alloc] initWithName:@"Finn"
                               image:[UIImage imageNamed:@"finn"]
                                 age:15
               numberOfSharedFriends:3
             numberOfSharedInterests:2
                      numberOfPhotos:1],
        [[Person alloc] initWithName:@"Jake"
                               image:[UIImage imageNamed:@"jake"]
                                 age:28
               numberOfSharedFriends:2
             numberOfSharedInterests:6
                      numberOfPhotos:8],
        [[Person alloc] initWithName:@"Fiona"
                               image:[UIImage imageNamed:@"fiona"]
                                 age:14
               numberOfSharedFriends:1
             numberOfSharedInterests:3
                      numberOfPhotos:5],
        [[Person alloc] initWithName:@"P. Gumball"
                               image:[UIImage imageNamed:@"prince"]
                                 age:18
               numberOfSharedFriends:1
             numberOfSharedInterests:1
                      numberOfPhotos:2],
    ];
}

- (ChoosePersonView *)popPersonViewWithFrame:(CGRect)frame {
    if ([self.people count] == 0) {
        return nil;
    }

    // UIView+LIPSwipeToChoose and LIPSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    LIPSwipeToChooseViewOptions *options = [LIPSwipeToChooseViewOptions new];
    options.delegate = self;
    options.likedText = @"Keep";
    options.threshold = 160.f;
    options.swipableDirections= (LIPSwipeDirectionRight|LIPSwipeDirectionLeft|LIPSwipeDirectionUp);
    options.onPan = ^(LIPPanState *state){
        CGRect frame = [self backCardViewFrame];
        self.backCardView.frame = CGRectMake(frame.origin.x,
                                             frame.origin.y - (state.thresholdRatio * 10.f),
                                             CGRectGetWidth(frame),
                                             CGRectGetHeight(frame));
    };

    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
    ChoosePersonView *personView = [[ChoosePersonView alloc] initWithFrame:frame
                                                                    person:self.people[0]
                                                                   options:options];
    self.lastRemovedPerson=self.people.firstObject;
    [self.people removeObjectAtIndex:0];
    return personView;
}

#pragma mark View Contruction

- (CGRect)frontCardViewFrame {
    CGFloat horizontalPadding = 20.f;
    CGFloat topPadding = 80.f;
    CGFloat bottomPadding = 200.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

- (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
                      frontFrame.origin.y + 10.f,
                      CGRectGetWidth(frontFrame),
                      CGRectGetHeight(frontFrame));
}

// Create and add the "nope" button.
- (void)constructNopeButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"nope"];
    button.frame = CGRectMake(ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:247.f/255.f
                                         green:91.f/255.f
                                          blue:37.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(nopeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

// Create and add the "like" button.
- (void)constructLikedButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *image = [UIImage imageNamed:@"liked"];
    button.frame = CGRectMake(CGRectGetMaxX(self.view.frame) - image.size.width - ChoosePersonButtonHorizontalPadding,
                              CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding,
                              image.size.width,
                              image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [button addTarget:self
               action:@selector(likeFrontCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)constructUndoButton {
    self.undoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.undoButton.frame=CGRectMake(self.view.center.x-50, CGRectGetMaxY(self.backCardView.frame) + ChoosePersonButtonVerticalPadding, 100, 50);
   // self.undoButton.center=self.view.center;
    self.undoButton.userInteractionEnabled=NO;
    [self.undoButton setTitle:@"Undo" forState:UIControlStateNormal];
    [self.undoButton setTintColor:[UIColor colorWithRed:29.f/255.f
                                         green:245.f/255.f
                                          blue:106.f/255.f
                                         alpha:1.f]];
    [self.undoButton addTarget:self
               action:@selector(undoCardView)
     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.undoButton];
}
#pragma mark Control Events

// Programmatically "nopes" the front card view.
- (void)nopeFrontCardView {
    [self.frontCardView lip_swipe:LIPSwipeDirectionLeft];
    
}

// Programmatically "likes" the front card view.
- (void)likeFrontCardView {
    [self.frontCardView lip_swipe:LIPSwipeDirectionRight];
}

- (void)undoCardView {
    self.frontCardView.frame = [self backCardViewFrame];
    self.backCardView=self.frontCardView;
    [self.people insertObject:self.undoPerson atIndex:0];
    
    self.frontCardView=[self popPersonViewWithFrame:[self frontCardViewFrame]];
    self.undoButton.userInteractionEnabled=NO;
    [self.people insertObject:self.lastRemovedPerson atIndex:0];
    self.lastRemovedPerson=nil;
    
   
    [self.view addSubview:self.frontCardView];
    [self.frontCardView lip_undoSwipe:self.undoDirection];
}
@end
