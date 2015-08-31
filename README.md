# LIPSwipableView
A tinder like SwipableView
##What it looks like?
![](/SwipableView.gif)

##Inspire by [MDCSwipeToChoose](https://github.com/modocache/MDCSwipeToChoose).

##What is the different between LPSwipableView and MDCSwipeToChoose?
* 1.You could Undo your manipulation。
* 2.You could customize swipable direction(customizable) by setting the swipableDirections Property.
 

 ~~~objective-c
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
~~~
