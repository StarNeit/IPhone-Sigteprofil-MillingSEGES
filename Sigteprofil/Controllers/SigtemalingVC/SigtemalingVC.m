#import "SigtemalingVC.h"
#include "GuideVC.h"
#include "HistoryVC.h"

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define MAXLENGTH 3

@interface SigtemalingVC ()<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
   
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *label_selected_name;
    
    IBOutlet UILabel *label_recommend_under;
    IBOutlet UILabel *label_recommend_middle;
    IBOutlet UILabel *label_recommend_over;
    IBOutlet UILabel *label_under_percent;
    IBOutlet UILabel *label_middle_percent;
    IBOutlet UILabel *label_over_percent;
    
    
    
    IBOutlet UIPickerView *picker;
    IBOutlet UIView *view_timepicker;
    IBOutlet UILabel *label_time_panel;
    NSMutableArray *_pickerData;
    int total_seconds;
    NSTimer *secTimer;
    bool is_start_countdown;
    
    
    int active_field;
    IBOutlet UIButton *btn_under;
    IBOutlet UIButton *btn_middle;
    IBOutlet UIButton *btn_over;
    IBOutlet UIView *view_keyboard_top;
    IBOutlet UITextField *focus_input;
    float under_input;
    float middle_input;
    float over_input;
    
    
    IBOutlet UIView *view_note;
    IBOutlet UITextView *tv_note;
}
@property (strong, nonatomic) AVAudioPlayer *player;
@end

@implementation SigtemalingVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    self.title = @"";
    
//---Scroll View---//
    [scrollView setContentSize:CGSizeMake(1.0,600)];
    
//---Single Tap---//
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.cancelsTouchesInView = NO;
    singleTap.delegate = self;
    [scrollView addGestureRecognizer:singleTap];
    
//---Initialize---//
    
    NSString *grain_name = self.grain.grain_name;
    if ([grain_name length] > 7){
        grain_name = [NSString stringWithFormat:@"%@...", [grain_name substringToIndex:4]];
    }
    label_selected_name.text = [NSString stringWithFormat:@"%@", grain_name];
    
    label_recommend_under.text = [NSString stringWithFormat:@"Målsætning: %@", self.grain.grain_under];
    label_recommend_middle.text = [NSString stringWithFormat:@"Målsætning: %@", self.grain.grain_middle];
    label_recommend_over.text = [NSString stringWithFormat:@"Målsætning: %@", self.grain.grain_over];

    
//---Time Picker---//
    _pickerData = [[NSMutableArray alloc] init];
    for (int i = 0; i < 60; i ++)
    {
        [_pickerData addObject:[NSString stringWithFormat:@"%d min", i]];
    }
    total_seconds = 120;//2 min
    
//---Keyboard customization---//
    under_input = 0;
    middle_input = 0;
    over_input = 0;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//---Single Tap---//
- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer
{
    // Close keyboard for any text edit views that are children of the main view
    [gestureRecognizer.view endEditing:YES];
    [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

//---UI Control---//
- (IBAction)onClickCalculate:(id)sender {
    //pop...
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)onClickHistory:(id)sender {
    HistoryVC *vc = [[HistoryVC alloc] init];
    UINavigationController *navigationController = self.navigationController;
    NSMutableArray *activeViewControllers=[[NSMutableArray alloc] initWithArray: navigationController.viewControllers] ;
    [activeViewControllers removeLastObject];
    
    // Reset the navigation stack
    [navigationController setViewControllers:activeViewControllers];
    [navigationController pushViewController:vc animated:NO];
}

- (IBAction)onClickGuide:(id)sender {
    GuideVC *vc = [[GuideVC alloc] init];
    UINavigationController *navigationController = self.navigationController;
    NSMutableArray *activeViewControllers=[[NSMutableArray alloc] initWithArray: navigationController.viewControllers] ;
    [activeViewControllers removeLastObject];
    
    // Reset the navigation stack
    [navigationController setViewControllers:activeViewControllers];
    [navigationController pushViewController:vc animated:NO];
}

- (IBAction)onClickNote:(id)sender {
    view_note.hidden = NO;
}

- (IBAction)onClickGem:(id)sender {
    if ([label_under_percent.text isEqualToString:@"XX %"])
    {
        [Common showAlert:@"Invalid input"];
        return;
    }
    
    Sigt *sigt = [Sigt create];
    sigt.navn = self.grain.grain_name;
    sigt.note = [Common trimString:tv_note.text];
    sigt.under_percent = label_under_percent.text;
    sigt.middle_percent = label_middle_percent.text;
    sigt.over_percent = label_over_percent.text;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSString *dateString = [dateFormat stringFromDate:today];
    NSLog(@"date: %@", dateString);
    
    sigt.date = dateString;
    
    [sigt save];
    
    //pop...
    message = @"Din sigtning er gemt";
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)onClickNoteSave:(id)sender {
    view_note.hidden = YES;
}

//---start down count---//
- (IBAction)onClickStartDownCount:(id)sender {
    if (total_seconds > 0 && is_start_countdown == false){
        secTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                    target:self
                                                  selector:@selector(timer)
                                                  userInfo:nil
                                                   repeats:YES];
        
        is_start_countdown = true;
    }
}
- (IBAction)onClickTime:(id)sender {
    view_timepicker.frame = CGRectMake(0, 97, view_timepicker.frame.size.width, view_timepicker.frame.size.height);//show timepicker
}

- (IBAction)onClickChooseTime:(id)sender {
    view_timepicker.frame = CGRectMake(0, 997, view_timepicker.frame.size.width, view_timepicker.frame.size.height);//hide timepicker
    
    int selected_item = [picker selectedRowInComponent:0];
    
    NSRange rng = [_pickerData[selected_item] rangeOfString:@" "];
    NSString *min = [_pickerData[selected_item] substringToIndex:rng.location];
    
    label_time_panel.text = [NSString stringWithFormat:@"%@:00", min];
    total_seconds = [min intValue] * 60;
    
    [self stopTimer];
}

- (void)timer {
    total_seconds--;
    label_time_panel.text = [NSString stringWithFormat:@"%d:%d", total_seconds / 60, total_seconds % 60];

    if ( total_seconds <= 0 ) {
        [self stopTimer];
        
        //play sound
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/%@.wav",
                                   [[NSBundle mainBundle] resourcePath], @"alarm"];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL
                                                         error:nil];
        _player.numberOfLoops = 0;
        
        [_player play];
    }
}

- (void)stopTimer{
    [secTimer invalidate];
    secTimer = nil;
    is_start_countdown = false;
}

//---Main 3 Input Process---//
- (IBAction)onEditUnder:(id)sender {
    active_field = 1;
    if (![btn_under.titleLabel.text isEqualToString:@"0"]){
        focus_input.text = btn_under.titleLabel.text;
    }
    [focus_input becomeFirstResponder];
    
}
- (IBAction)onEditMiddle:(id)sender {
    active_field = 2;
    if (![btn_middle.titleLabel.text isEqualToString:@"0"]){
        focus_input.text = btn_middle.titleLabel.text;
    }
    [focus_input becomeFirstResponder];
}
- (IBAction)onEditOver:(id)sender {
    active_field = 3;
    if (![btn_over.titleLabel.text isEqualToString:@"0"]){
        focus_input.text = btn_over.titleLabel.text;
    }
    [focus_input becomeFirstResponder];
}

- (void) calculate
{
    if ((under_input + middle_input + over_input) == 0)
        return;
    float result_under = under_input / (under_input + middle_input + over_input) * 100;
    float result_middle = middle_input / (under_input + middle_input + over_input) * 100;
    float result_over = over_input / (under_input + middle_input + over_input) * 100;
    
    
    label_under_percent.text = [NSString stringWithFormat:@"%.0f %%", result_under];
    label_middle_percent.text = [NSString stringWithFormat:@"%.0f %%", result_middle];
    label_over_percent.text = [NSString stringWithFormat:@"%.0f %%", result_over];
}

- (IBAction)onClickEditDone:(id)sender {
    if ([focus_input.text isEqualToString:@""])
    {
        focus_input.text = @"0";
    }
    switch (active_field) {
        case 1:
        {
            [btn_under setTitle:focus_input.text forState:UIControlStateNormal];
            under_input = [focus_input.text intValue];
            [self calculate];
            break;
        }
        case 2:
        {
            [btn_middle setTitle:focus_input.text forState:UIControlStateNormal];
            middle_input = [focus_input.text intValue];
            [self calculate];
            break;
        }
        case 3:
        {
            [btn_over setTitle:focus_input.text forState:UIControlStateNormal];
            over_input = [focus_input.text intValue];
            [self calculate];
            break;
        }
        default:
            break;
    }
    
    focus_input.text = @"";
    [focus_input resignFirstResponder];
    view_keyboard_top.frame = CGRectMake(0, -50, self.view.frame.size.width, 50);
}
- (IBAction)onClickCancelDone:(id)sender {
    focus_input.text = @"";
    [focus_input resignFirstResponder];
    view_keyboard_top.frame = CGRectMake(0, -50, self.view.frame.size.width, 50);
}

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= MAXLENGTH || returnKey;
}

//---TextField Delegate---//
#pragma mark - UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 0.6 * NSEC_PER_SEC),
                   dispatch_get_main_queue(),
                   ^{
                       // Do whatever you want here.
                       view_keyboard_top.frame = CGRectMake(0, self.view.frame.size.height-216 - 50, self.view.frame.size.width, 50);
                   });
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}


//---Picker Delegate---//

// The number of columns of data
- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerData[row];
}

@end
