#import "HomeVC.h"
#include "HomeListCell.h"
#include "HomeListBottomCell.h"
#include "CreateGrainVC.h"
#include "Grains.h"
#include "EditGrainVC.h"
#include "SigtemalingVC.h"
#include "GuideVC.h"
#include "HistoryVC.h"

@interface HomeVC ()
{
    NSArray *m_array_grains;
    IBOutlet UITableView *m_tv_grains;
    
    IBOutlet UIView *view_message;
    IBOutlet UIButton *btn_message_confirm;
}
@end

@implementation HomeVC
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
    
    //---hide separated line uitableview---
    m_tv_grains.tableFooterView = [[UIView alloc] init];
    m_tv_grains.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (self.is_first_loading)
    {
        self.is_first_loading = false;
        
        GuideVC *vc = [[GuideVC alloc] init];
        vc.isFirstLoading = 2;
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    m_array_grains = [Grains all];
    [m_tv_grains reloadData];
    
    if (![message isEqualToString:@""])
    {
        view_message.hidden = NO;
        [btn_message_confirm setTitle: message forState:UIControlStateNormal];
        message = @"";
    }else{
        view_message.hidden = YES;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//---UI Control---//
- (IBAction)onClickCalculate:(id)sender {
    
}

- (IBAction)onClickHistory:(id)sender {
    HistoryVC *vc = [[HistoryVC alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)onClickGuide:(id)sender {
    GuideVC *vc = [[GuideVC alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

- (IBAction)onClickMessageConfirmButton:(id)sender {
    view_message.hidden = YES;
}


//---Table View---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (m_array_grains == nil)
        return 0;
    return [m_array_grains count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //---GrainsList---//
    Grains *grain = [m_array_grains objectAtIndex:indexPath.row];
    
    if ([grain.grain_name isEqualToString:@"TILFØJ NY"] && indexPath.row == [m_array_grains count] - 1) //Last 'Add New' Button
    {
        HomeListBottomCell *cell = (HomeListBottomCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeListBottomCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeListBottomCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        if ([m_array_grains count] % 2 != 0)
        {
            cell.view_back.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:245.0f/255.0f blue:253.0f/255.0f alpha:1];
        }else{
            cell.view_back.backgroundColor = [UIColor colorWithRed:172.0f/255.0f green:203.0f/255.0f blue:211.0f/255.0f alpha:1];
        }
        cell.tv_grain_name.text = grain.grain_name;
        
        return cell;
    }
    else //Normal Items
    {
        HomeListCell *cell = (HomeListCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeListCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeListCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (indexPath.row % 2 == 0)
        {
            cell.view_back.backgroundColor = [UIColor colorWithRed:230.0f/255.0f green:245.0f/255.0f blue:253.0f/255.0f alpha:1];
            [cell.btn_edit_grain setBackgroundImage:[UIImage imageNamed:@"btn_edit_green.png"] forState:UIControlStateNormal];
        }else{
            cell.view_back.backgroundColor = [UIColor colorWithRed:172.0f/255.0f green:203.0f/255.0f blue:211.0f/255.0f alpha:1];
            [cell.btn_edit_grain setBackgroundImage:[UIImage imageNamed:@"btn_edit_blue.png"] forState:UIControlStateNormal];
        }
        NSString *grain_name = grain.grain_name;
        if ([grain_name length] > 7){
            grain_name = [NSString stringWithFormat:@"%@...", [grain_name substringToIndex:4]];
        }
        
        cell.tv_grain_name.text = grain_name;
        cell.btn_edit_grain.tag = indexPath.row;
        [cell.btn_edit_grain addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == m_array_grains.count - 1) //Click Add New button
    {
        //---redirecting---//
        CreateGrainVC *vc = [[CreateGrainVC alloc] init];
        [self.navigationController pushViewController:vc animated:NO];
    }else //Click To Calculate Page
    {
        Grains *grain = [m_array_grains objectAtIndex:indexPath.row];
        
        //---redirecting---//
        SigtemalingVC *vc = [[SigtemalingVC alloc] init];
        vc.grain = grain;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (void) clickEdit:(id) sender
{
    int row = ((UIButton*)sender).tag;
    Grains *grain = [m_array_grains objectAtIndex:row];
    
    //Redirect to EditGrain VC
    EditGrainVC *vc = [[EditGrainVC alloc] init];
    vc.grain = grain;
    vc.position = row;
    [self.navigationController pushViewController:vc animated:NO];
}

@end
