//
//  GCDViewController.m
//  GCD_Intro
//
//  Created by Matthew Henderson on 10/20/12.
//  Copyright (c) 2012 Matthew Henderson. All rights reserved.
//

#import "GCDViewController.h"
#import "GCDTransaction.h"
#import "GCDAccount.h"

@interface GCDViewController ()
@property (nonatomic, assign) IBOutlet UIProgressView* progressView;
@property (nonatomic, assign) IBOutlet UILabel* currentBalanceLabel;
@property (nonatomic, strong) NSDate* start;
@property (nonatomic, assign) IBOutlet UISwitch* concurrentSwitch;
@property (nonatomic, assign) IBOutlet UILabel* maxOpLabel;
@property (nonatomic, assign) IBOutlet UIStepper* maxOpStepper;
-(IBAction)syncAction:(id)sender;
-(IBAction)asyncAction:(id)sender;
-(IBAction)applyAction:(id)sender;
-(IBAction)asyncApplyAction:(id)sender;
-(IBAction)nsoperationAction:(id)sender;
-(IBAction)stepperAction:(id)sender;
@end

@implementation GCDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)doWorkOnAccount:(GCDAccount*) syncAccount withProgress:(NSInteger)progress{
    GCDTransaction* transaction = [[GCDTransaction alloc] init];
    [transaction determineTransactionAmount];
    BOOL validTransaction = [syncAccount processTransaction:transaction];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!validTransaction) {
            self.view.backgroundColor = [UIColor redColor];
        }
        self.progressView.progress = MAX(self.progressView.progress,(progress/100.0));
        self.currentBalanceLabel.text = [NSString stringWithFormat:@"$%d %f", syncAccount.balance, -[self.start timeIntervalSinceNow]];
    });
}

-(IBAction)syncAction:(id)sender{
    self.view.backgroundColor = [UIColor greenColor];
    self.progressView.progress = 0.0f;
    NSInteger balance  = ((arc4random() % 12) + 1) * 100;
    self.start = [NSDate date];

    GCDAccount *syncAccount = [[GCDAccount alloc] initWithName:@"sync" andStartingBalance:balance];
    for (int i = 1; i <= 100; i++) {
        GCDTransaction* transaction = [[GCDTransaction alloc] init];
        [transaction determineTransactionAmount];
        if(![syncAccount processTransaction:transaction]){
            self.view.backgroundColor = [UIColor redColor];
        }
        self.progressView.progress = (i/100.0);
        self.currentBalanceLabel.text = [NSString stringWithFormat:@"$%d %f", syncAccount.balance, -[self.start timeIntervalSinceNow]];
    }
}

-(IBAction)asyncAction:(id)sender{
    self.view.backgroundColor = [UIColor greenColor];
    self.progressView.progress = 0.0f;
    NSInteger balance  = ((arc4random() % 12) + 1) * 100;
    GCDAccount *syncAccount = [[GCDAccount alloc] initWithName:@"async" andStartingBalance:balance];
    self.start = [NSDate date];
    dispatch_queue_t queue = dispatch_queue_create("com.gcdintro.async", ((self.concurrentSwitch.isOn) ? DISPATCH_QUEUE_CONCURRENT: DISPATCH_QUEUE_SERIAL));

    for (int i = 1; i <= 100; i++) {
        dispatch_async(queue, ^{
            [self doWorkOnAccount:syncAccount withProgress:i];
        });
    }
}

-(IBAction)applyAction:(id)sender{
    self.start = [NSDate date];
    self.progressView.progress = 0.0f;
    self.view.backgroundColor = [UIColor greenColor];
    NSInteger balance  = ((arc4random() % 12) + 1) * 100;
    GCDAccount *syncAccount = [[GCDAccount alloc] initWithName:@"apply" andStartingBalance:balance];
    BOOL deadlock = NO;
    dispatch_queue_t queue = (deadlock) ? syncAccount.queue : dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_apply(100, queue, ^(size_t i) {
        [self doWorkOnAccount:syncAccount withProgress:(i+1)];
    });
}

-(IBAction)asyncApplyAction:(id)sender{
    self.view.backgroundColor = [UIColor greenColor];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self applyAction:sender];
    });
}


-(IBAction)nsoperationAction:(id)sender{
    NSOperationQueue* aQueue = [[NSOperationQueue alloc] init];
    self.progressView.progress = 0.0f;
    NSInteger maxCount = self.maxOpStepper.value;
    [aQueue setMaxConcurrentOperationCount:maxCount];
    self.start = [NSDate date];
    self.view.backgroundColor = [UIColor greenColor];
    NSInteger balance  = ((arc4random() % 12) + 1) * 100;
    GCDAccount *syncAccount = [[GCDAccount alloc] initWithName:@"nsop" andStartingBalance:balance];
    for (int i = 1; i <= 100; i++) {
        [aQueue addOperationWithBlock:^{
            [self doWorkOnAccount:syncAccount withProgress:(i+1)];
        }];
    }
}

- (IBAction)stepperAction:(UIStepper *)sender {
    NSInteger value = (NSInteger)[sender value];
    [self.maxOpLabel setText:[NSString stringWithFormat:@"Max Ops %d", value]];
}

@end
