#import "HistoryVC.h"
#import "GuideVC.h"
#import "Grains.h"
#import "Sigt.h"
#import "DropListCell.h"
#import "HistoryCell.h"
#import "CHCSVParser.h"

@interface HistoryVC ()<UIGestureRecognizerDelegate>
{
    NSMutableArray *m_array_grains_name;
    NSMutableArray *m_array_sigts;
    
    IBOutlet UITableView *tableView_dropbox;
    IBOutlet UILabel *label_search_term;
    
    
    IBOutlet UITableView *tableView_history;
    
    IBOutlet UIView *view_note;
    IBOutlet UITextView *tv_note;
    
    NSString *filter_key;
}
@end

@implementation HistoryVC
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
    
    tableView_dropbox.tag = 1000;
    tableView_history.tag = 1001;
    
    //---Single Tap---//
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.cancelsTouchesInView = NO;
    singleTap.delegate = self;
    [view_note addGestureRecognizer:singleTap];
  
    //---Init for Dropbox Search---
    m_array_grains_name = [[NSMutableArray alloc] init];
    
    [m_array_grains_name addObject:@"Dato"];
    for (Grains *grain in [Grains all])
    {
        if (![grain.grain_name isEqualToString:@"TILFØJ NY"])
            [m_array_grains_name addObject:grain.grain_name];
    }
    
    label_search_term.text = @"Dato";
    tableView_dropbox.hidden = YES;
    
    filter_key = @"Dato";
    
    //---Init for Table Datas---
    m_array_sigts = (NSMutableArray*)[Sigt all];
    view_note.hidden = YES;
    
    //---hide separated line uitableview---
    tableView_dropbox.tableFooterView = [[UIView alloc] init];
    tableView_dropbox.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView_history.tableFooterView = [[UIView alloc] init];
    tableView_history.separatorStyle = UITableViewCellSeparatorStyleNone;

}

//---Single Tap---//
- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer
{
    // Close keyboard for any text edit views that are children of the main view
    [gestureRecognizer.view endEditing:YES];
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

- (IBAction)onClickSearchTerm:(id)sender {
    tableView_dropbox.hidden = NO;
}

- (IBAction)onClickDownloadCSV:(id)sender {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = @"segesFileExport.csv";
    NSURL *fileURL = [NSURL fileURLWithPathComponents:[NSArray arrayWithObjects:documentsDirectory, filename, nil]];
    
    
    CHCSVWriter *cvsExport = [[CHCSVWriter alloc] initForWritingToCSVFile:[fileURL absoluteString]];
    
    for (Sigt *sigt in [Sigt all])
    {
        //[cvsExport writeLineOfFields:sigt.navn, sigt.under_percent, sigt.middle_percent, sigt.over_percent, sigt.note, sigt.date, nil];
        [cvsExport writeField:sigt.navn];
    }
    [cvsExport closeStream];
    
    
//    for (Product *prod in fetchedObjects) {
//        [cvsExport writeLineOfFields:prod.code, prod.barcode, prod.name, prod.size, prod.casesize, nil];
//    }
//    [cvsExport closeFile];

}



//---Table View---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int cnt = 0;
    if (tableView.tag == 1000)//dropbox list
    {
        if (m_array_grains_name == nil)
            return 1;
        cnt = [m_array_grains_name count];
    }else if (tableView.tag == 1001)//history list
    {
        if (m_array_sigts == nil)
            return 1;
        cnt = [m_array_sigts count] + 1;
    }
    return cnt;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 0;
    if (tableView.tag == 1000)//dropbox list
    {
        height = 28;
    }else if (tableView.tag == 1001)//history list
    {
        height = 36;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000)//dropbox list
    {
        //---DropListCell---
        DropListCell *cell = (DropListCell *)[tableView dequeueReusableCellWithIdentifier:@"DropListCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DropListCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (m_array_grains_name.count == 0)
            return cell;
        cell.label_name.text = [m_array_grains_name objectAtIndex:indexPath.row];
        return cell;
    }else //history list
    {
        //---HistoryCell---
        HistoryCell *cell = (HistoryCell *)[tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
        if (cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (indexPath.row == 0)
        {
            cell.label_navn_dato.text = @"Navn & Dato";
            cell.label_under.text = @"Under 1mm";
            cell.label_middle.text = @"1 - 2mm";
            cell.label_over.text = @"Over 2mm";
            
            cell.btn_note.hidden = YES;
            cell.label_note.hidden = NO;
        }else{
            if (m_array_sigts.count == 0)
                return cell;
            Sigt *sigt = [m_array_sigts objectAtIndex:indexPath.row - 1];
            
            NSString *sigt_name = sigt.navn;
            if ([sigt_name length] > 7){
                sigt_name = [NSString stringWithFormat:@"%@...", [sigt_name substringToIndex:4]];
            }
            
            cell.label_navn_dato.text = [NSString stringWithFormat:@"%@ - %@", sigt_name, sigt.date];
            cell.label_under.text = sigt.under_percent;
            cell.label_middle.text = sigt.middle_percent;
            cell.label_over.text = sigt.over_percent;
            
            if ([sigt.note isEqualToString:@""])
            {
                cell.btn_note.hidden = YES;
                cell.label_note.hidden = YES;
            }else{
                cell.label_note.hidden = YES;
                
                cell.btn_note.hidden = NO;
                cell.btn_note.tag = indexPath.row - 1;
                [cell.btn_note addTarget:self action:@selector(clickNote:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1000)//dropbox list
    {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        label_search_term.text = [m_array_grains_name objectAtIndex:indexPath.row];
        tableView_dropbox.hidden = YES;
        
        filter_key = label_search_term.text;
        
        m_array_sigts = @[];
        m_array_sigts = (NSMutableArray*)[[NSMutableArray alloc] init];
        
        if ([filter_key isEqualToString:@"Dato"])
        {
            for (Sigt *sigt in [Sigt all]){
                [m_array_sigts addObject:sigt];
            }
        }else{
            for (Sigt *sigt in [Sigt all]){
                if ([sigt.navn isEqualToString:filter_key])
                    [m_array_sigts addObject:sigt];
            }
        }
        [tableView_history reloadData];
    }else if (tableView.tag == 1001)//history list
    {
       
    }
}

- (void) clickNote:(id) sender
{
    int row = ((UIButton*)sender).tag;
    Sigt *sigt = [m_array_sigts objectAtIndex:row];
    
    view_note.hidden = NO;
    tv_note.text = sigt.note;
}

- (IBAction)onClickGemNote:(id)sender {
    view_note.hidden = YES;
}

@end
