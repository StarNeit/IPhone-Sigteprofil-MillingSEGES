#import "EditGrainVC.h"
#include "Grains.h"
#include "GuideVC.h"
#include "HistoryVC.h"

@interface EditGrainVC ()<UITextFieldDelegate, UIGestureRecognizerDelegate>
{
    IBOutlet UITextField *tv_navn;
    IBOutlet UITextField *tv_under;
    IBOutlet UITextField *tv_middle;
    IBOutlet UITextField *tv_over;
    IBOutlet UITextField *tv_position;
    
    IBOutlet UILabel *label_edit_logo;
    
    
    IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIView *view_delete_confirmation;
    IBOutlet UIButton *btn_delete_name_yes;
    
    NSString *g_name;
    
}
@end

@implementation EditGrainVC
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
    
    NSAttributedString *str_position = [[NSAttributedString alloc] initWithString:@"X" attributes:@{ NSForegroundColorAttributeName : color}];
    tv_position.attributedPlaceholder = str_position;
    
//---Single Tap---//
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.cancelsTouchesInView = NO;
    singleTap.delegate = self;
    [scrollView addGestureRecognizer:singleTap];
    
    
//---Initialize---//
    tv_navn.text = self.grain.grain_name;
    g_name = self.grain.grain_name;
    tv_under.text = self.grain.grain_under;
    tv_middle.text = self.grain.grain_middle;
    tv_over.text = self.grain.grain_over;
    tv_position.text = [NSString stringWithFormat:@"%d", self.position + 1];
    
    NSString *grain_name = self.grain.grain_name;
    if ([grain_name length] > 7){
        grain_name = [NSString stringWithFormat:@"%@...", [grain_name substringToIndex:4]];
    }
    
    label_edit_logo.text = [NSString stringWithFormat:@"Rediger - %@",self.grain.grain_name];
    
    view_delete_confirmation.hidden = YES;
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
    message = @"";
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

//Update
- (IBAction)onClickUpdate:(id)sender {
    tv_navn.text = [Common trimString:tv_navn.text];
    tv_under.text = [Common trimString:tv_under.text];
    tv_middle.text = [Common trimString:tv_middle.text];
    tv_over.text = [Common trimString:tv_over.text];
    tv_position.text = [Common trimString:tv_position.text];
    
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
    if ([tv_position.text isEqualToString:@""])
    {
        [Common showAlert:@"Please input Placering pas liste"];
        return;
    }
    if (([tv_under.text intValue] + [tv_middle.text intValue] + [tv_over.text intValue]) != 100)
    {
        [Common showAlert:@"Dine tal svare ikke til 100%"];
        return;
    }
    if ([tv_position.text intValue] == 0)
    {
        [Common showAlert:@"Please input Placering pas liste more than 0"];
        return;
    }
    if ([tv_position.text intValue] >= [Grains count])
    {
        [Common showAlert:[NSString stringWithFormat:@"Please input Placering pas liste less than %d",[Grains count]]];
        return;
    }
    if ([tv_position.text intValue] - 1 == self.position)
    {
         self.grain.grain_name = tv_navn.text;
         self.grain.grain_under = tv_under.text;
         self.grain.grain_middle = tv_middle.text;
         self.grain.grain_over = tv_over.text;
         
         [self.grain save];
    }else{
        int X = self.position;
        int Y = [tv_position.text intValue] - 1;
        
        //---caching all datas from the sqlite---//
        NSArray *grain_list = [Grains all];
        
        NSMutableArray *grain_names_list = [[NSMutableArray alloc] init];
        NSMutableArray *grain_under_list = [[NSMutableArray alloc] init];
        NSMutableArray *grain_middle_list = [[NSMutableArray alloc] init];
        NSMutableArray *grain_over_list = [[NSMutableArray alloc] init];
        
        //Delete all records from sqlite.
        for (Grains *grain1 in [Grains all])
        {
            [grain_names_list addObject:grain1.grain_name];
            [grain_under_list addObject:grain1.grain_under];
            [grain_middle_list addObject:grain1.grain_middle];
            [grain_over_list addObject:grain1.grain_over];
            
            [grain1 delete];
        }
        
        if (X < Y)
        {
            for (int i = 0; i < grain_list.count; i ++)
            {
                if (i == X) continue;
                Grains *grain_element = [Grains create];
                grain_element.grain_name = grain_names_list[i];
                grain_element.grain_under = grain_under_list[i];
                grain_element.grain_middle = grain_middle_list[i];
                grain_element.grain_over = grain_over_list[i];
                [grain_element save];
                
                if (i == Y)
                {
                    Grains *main_element = [Grains create];
                    main_element.grain_name = tv_navn.text;
                    main_element.grain_under = tv_under.text;
                    main_element.grain_middle = tv_middle.text;
                    main_element.grain_over = tv_over.text;
                    [main_element save];
                }
            }
        }else if (X > Y)
        {
            for (int i = 0; i < grain_list.count; i ++)
            {
                if (i == X) continue;
                if (i == Y)
                {
                    Grains *main_element = [Grains create];
                    main_element.grain_name = tv_navn.text;
                    main_element.grain_under = tv_under.text;
                    main_element.grain_middle = tv_middle.text;
                    main_element.grain_over = tv_over.text;
                    [main_element save];
                }
                
                Grains *grain_element = [Grains create];
                grain_element.grain_name = grain_names_list[i];
                grain_element.grain_under = grain_under_list[i];
                grain_element.grain_middle = grain_middle_list[i];
                grain_element.grain_over = grain_over_list[i];
                [grain_element save];
            }
        }
    }
    
    //pop...
    message = @"ÆNDRINGER GEMT";
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)onPlaceEdit:(id)sender {
    [tv_position setText:@""];
}


//Delete
- (IBAction)onClickDelete:(id)sender
{
    [btn_delete_name_yes setTitle:[NSString stringWithFormat:@"Slet %@",self.grain.grain_name] forState:UIControlStateNormal];
    view_delete_confirmation.hidden = NO;
}

//Delete-Yes
- (IBAction)onClickDeleteName:(id)sender {
    NSArray *grain_list = [Grains all];
    
    NSMutableArray *grain_names_list = [[NSMutableArray alloc] init];
    NSMutableArray *grain_under_list = [[NSMutableArray alloc] init];
    NSMutableArray *grain_middle_list = [[NSMutableArray alloc] init];
    NSMutableArray *grain_over_list = [[NSMutableArray alloc] init];
    
    //Delete all records from sqlite.
    for (Grains *grain1 in [Grains all])
    {
        [grain_names_list addObject:grain1.grain_name];
        [grain_under_list addObject:grain1.grain_under];
        [grain_middle_list addObject:grain1.grain_middle];
        [grain_over_list addObject:grain1.grain_over];
        
        [grain1 delete];
    }
    
    //Add all records from sqlite except one.
    for (int i = 0; i < grain_list.count; i ++)
    {
        if (i == self.position)
            continue;
        
        Grains *grain_element = [Grains create];
        grain_element.grain_name = grain_names_list[i];
        grain_element.grain_under = grain_under_list[i];
        grain_element.grain_middle = grain_middle_list[i];
        grain_element.grain_over = grain_over_list[i];
        [grain_element save];
    }
    //pop...
    message = [NSString stringWithFormat:@"%@ er slettet", g_name];
    [self.navigationController popViewControllerAnimated:NO];
}

//Delete-No
- (IBAction)onClickDeleteName_No:(id)sender {
    view_delete_confirmation.hidden = YES;
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
    }else if (textField == tv_position)
    {
        [scrollView setContentOffset:CGPointMake(0, 200) animated:YES];
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
