#import "CreateGrainVC.h"
#include "Grains.h"
#include "GuideVC.h"
#include "HistoryVC.h"

@interface CreateGrainVC ()<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    IBOutlet UITextField *tv_navn;
    IBOutlet UITextField *tv_under;
    IBOutlet UITextField *tv_middle;
    IBOutlet UITextField *tv_over;
    
    IBOutlet UIScrollView *scrollView;
    
}
@end

@implementation CreateGrainVC
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
    
    
//---Set Placeholder Text Color---//
    UIColor *color = [UIColor colorWithRed:0 green:100.0f/255.0f blue:114.0f/255.0f alpha:1];
    
    NSAttributedString *str_nav = [[NSAttributedString alloc] initWithString:@"Skriv her" attributes:@{ NSForegroundColorAttributeName : color}];
    tv_navn.attributedPlaceholder = str_nav;
    
    NSAttributedString *str_under = [[NSAttributedString alloc] initWithString:@"XX %" attributes:@{ NSForegroundColorAttributeName : color}];
    tv_under.attributedPlaceholder = str_under;
    
    NSAttributedString *str_middle = [[NSAttributedString alloc] initWithString:@"XX %" attributes:@{ NSForegroundColorAttributeName : color}];
    tv_middle.attributedPlaceholder = str_middle;
    
    NSAttributedString *str_over = [[NSAttributedString alloc] initWithString:@"XX %" attributes:@{ NSForegroundColorAttributeName : color}];
    tv_over.attributedPlaceholder = str_over;
    
    
//---Single Tap---//
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.cancelsTouchesInView = NO;
    singleTap.delegate = self;
    [scrollView addGestureRecognizer:singleTap];
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

- (IBAction)onClickSave:(id)sender {
    tv_navn.text = [Common trimString:tv_navn.text];
    tv_under.text = [Common trimString:tv_under.text];
    tv_middle.text = [Common trimString:tv_middle.text];
    tv_over.text = [Common trimString:tv_over.text];
    
    if ([tv_navn.text isEqualToString:@""])
    {
        [Common showAlert:@"Please input Navn"];
        return;
    }
    if ([tv_under.text isEqualToString:@""])
    {
        [Common showAlert:@"Please input Under 1mm"];
        return;
    }
    if ([tv_middle.text isEqualToString:@""])
    {
        [Common showAlert:@"Please input 1-2 mm"];
        return;
    }
    if ([tv_over.text isEqualToString:@""])
    {
        [Common showAlert:@"Please input Over 2 mm"];
        return;
    }
    if (([tv_under.text intValue] + [tv_middle.text intValue] + [tv_over.text intValue]) != 100)
    {
        [Common showAlert:@"Dine tal svare ikke til 100%"];
        return;
    }
    
    
    //---remove last 'Add new' button---//
    int count = [Grains count], k = 0;
    for (Grains *grain in [Grains all])
    {
        if (k == count - 1)
        {
            [grain delete];
        }
        k ++;
    }
    
    //---Add a new grain---//
    Grains *grains = [Grains create];
    grains.grain_name = tv_navn.text;
    grains.grain_under = tv_under.text;
    grains.grain_middle = tv_middle.text;
    grains.grain_over = tv_over.text;
    [grains save];
    
    
    //---Add 'Add new' button---//
    Grains *grains5 = [Grains create];
    grains5.grain_name = @"TILFØJ NY";
    grains5.grain_under = @"0";
    grains5.grain_middle = @"0";
    grains5.grain_over = @"0";
    [grains5 save];
    
    
    //pop...
    [self.navigationController popViewControllerAnimated:NO];
}

//---TextField Delegate---//
#pragma mark - UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == tv_under)
    {
        [scrollView setContentOffset:CGPointMake(0, 50) animated:YES];
    }else if (textField == tv_middle)
    {
        [scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    }else if (textField == tv_over)
    {
        [scrollView setContentOffset:CGPointMake(0,150) animated:YES];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == tv_navn)
    {
        [tv_under becomeFirstResponder];
    }
    return YES;
}

@end
