#import "GuideVC.h"
#include "HistoryVC.h"

@interface GuideVC ()
{
    
    IBOutlet UIView *view_main_guide;
    IBOutlet UIView *view_sigte_guide;
    IBOutlet UIView *view_percent_guide;
    IBOutlet UIView *view_app_guide;
    
    IBOutletCollection(UIImageView) NSArray *img_app_guides;
    
    int app_guide_index;
    IBOutlet UIButton *btn_right;
    IBOutlet UIButton *btn_left;
    IBOutlet UIButton *btn_back;
    
}
@end

@implementation GuideVC
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
    
    //main guide screen display
    view_main_guide.hidden = NO;
    view_sigte_guide.hidden = YES;
    view_percent_guide.hidden = YES;
    view_app_guide.hidden = YES;
    
    btn_back.hidden = YES;
    
    if (self.isFirstLoading == 2)
    {
        [self openAppGuide];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
}

//---Main Guide Screen---//
- (IBAction)onClickSigteGuide:(id)sender {
    view_main_guide.hidden = YES;
    view_sigte_guide.hidden = NO;
    view_percent_guide.hidden = YES;
    view_app_guide.hidden = YES;
    
    btn_back.hidden = NO;
}

- (IBAction)onClickPercentGuide:(id)sender {
    view_main_guide.hidden = YES;
    view_sigte_guide.hidden = YES;
    view_percent_guide.hidden = NO;
    view_app_guide.hidden = YES;
    
    btn_back.hidden = NO;
}

- (IBAction)onClickAppGuide:(id)sender {
    [self openAppGuide];
}

- (void)openAppGuide
{
    view_main_guide.hidden = YES;
    view_sigte_guide.hidden = YES;
    view_percent_guide.hidden = YES;
    view_app_guide.hidden = NO;
    
    app_guide_index = 0;
    UIImageView *img = [img_app_guides objectAtIndex:app_guide_index];
    img.hidden = NO;
    btn_left.hidden = YES;
    btn_right.hidden = NO;
    
    btn_back.hidden = YES;
}

- (void) showAppGuides:(int) index
{
    for (int i = 0 ; i < img_app_guides.count; i ++)
    {
        UIImageView *img = [img_app_guides objectAtIndex:i];
        if (i != index){
            img.hidden = YES;
        }else{
            img.hidden = NO;
        }
    }
}

- (IBAction)onClickBtnRight:(id)sender {
    app_guide_index ++;
    if (app_guide_index > 3)
        app_guide_index = 3;
    
    if (app_guide_index < 3)
    {
        btn_right.hidden = NO;
    }else{
        btn_right.hidden = YES;
    }
    
    if (app_guide_index > 0)
    {
        btn_left.hidden = NO;
    }
    
    [self showAppGuides:app_guide_index];
}

- (IBAction)onClickBtnLeft:(id)sender {
    app_guide_index --;
    if (app_guide_index < 0)
        app_guide_index = 0;
    
    if (app_guide_index > 0)
    {
        btn_left.hidden = NO;
    }else{
        btn_left.hidden = YES;
    }
    
    if (app_guide_index < 3)
    {
        btn_right.hidden = NO;
    }
    
    [self showAppGuides:app_guide_index];
}

//back
- (IBAction)onClickBackToMain:(id)sender {
    if (self.isFirstLoading == 2)
    {
        self.isFirstLoading = 1;
        //pop...
        [self.navigationController popViewControllerAnimated:NO];
    }
    view_main_guide.hidden = NO;
    view_sigte_guide.hidden = YES;
    view_percent_guide.hidden = YES;
    view_app_guide.hidden = YES;
    
    btn_back.hidden = YES;
}

//link youtube site
- (IBAction)onClickYoutubeLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=xGOHEGehPbw"]];
}


@end
