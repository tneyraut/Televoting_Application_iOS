//
//  ProfVisualisationQuestionnaireTableViewController.m
//  Televoting
//
//  Created by Thomas Mac on 04/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ProfVisualisationQuestionnaireTableViewController.h"

#import "SpecificTableViewCell.h"

#import "Question.h"
#import "Reponse.h"

@interface ProfVisualisationQuestionnaireTableViewController ()

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSMutableArray *sectionArray;

@property(nonatomic, strong) NSMutableArray *cellArray;

@property(nonatomic, strong) ApercuQuestionnaireModel *_apercuQuestionnaireModel;

@end

@implementation ProfVisualisationQuestionnaireTableViewController

- (void) initialisationView {
    [self.navigationItem setTitle:@"Aperçu du questionnaire"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Aperçu du questionnaire" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) getApercuQuestionnaire:(int)questionnaire_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._apercuQuestionnaireModel)
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self._apercuQuestionnaireModel = [[ApercuQuestionnaireModel alloc] init];
        self._apercuQuestionnaireModel.delegate = self;
    }
    [self._apercuQuestionnaireModel getListeQuestionsReponses:questionnaire_id];
}

- (void) getApercuQuestionnaireDownloaded:(NSArray *)items
{
    if (items.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[@"Aucune question n'a été trouvée pour le questionnaire : " stringByAppendingString:self.questionnaireSelected.questionnaire_name] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.activityIndicatorView stopAnimating];
        
        [alertView show];
        
        return;
    }
    
    self.sectionArray = [[NSMutableArray alloc] init];
    
    self.cellArray = [[NSMutableArray alloc] init];
    
    for (int i=0;i<items.count;i=i+2)
    {
        [self.sectionArray addObject:@"Question"];
        [self.sectionArray addObject:@"Réponses"];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        [array addObject:[items objectAtIndex:i]];
        
        if (!self.apercuPartiel)
        {
            [array addObject:@""];
        }
        
        [self.cellArray addObject:array];
        [self.cellArray addObject:[items objectAtIndex:i+1]];
    }
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cellQuestion"];
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cellTemps"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self initialisationView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [self getApercuQuestionnaire:self.questionnaireSelected.questionnaire_id];
    
    [super viewDidAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSMutableArray *array = [self.cellArray objectAtIndex:section];
    
    return array.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionArray objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array = [self.cellArray objectAtIndex:indexPath.section];
    
    if ([[array objectAtIndex:indexPath.row] isKindOfClass:[Question class]] || (indexPath.row == 1 && [[array objectAtIndex:indexPath.row - 1] isKindOfClass:[Question class]] ))
    {
        if (indexPath.row == 0)
        {
            SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellQuestion" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.imageView setImage:[UIImage imageNamed:@"iconQuestion.png"]];
            
            Question *question = [array objectAtIndex:indexPath.row];
            
            UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 5.0f, 2 * self.view.frame.size.width / 3 - 50, cell.frame.size.height - 10.0f)];
            
            [textView setText:question.question];
            [textView setTextColor:[UIColor blackColor]];
            [textView setFont:[UIFont fontWithName:textView.font.fontName size:15.0]];
            [textView setEditable:NO];
            
            [cell addSubview:textView];
            
            return cell;
        }
        else
        {
            SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTemps" forIndexPath:indexPath];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.imageView setImage:[UIImage imageNamed:@"iconTimer.png"]];
            
            Question *question = [array objectAtIndex:indexPath.row - 1];
            
            [cell.textLabel setText:[NSString stringWithFormat:@"Temps imparti de %d secondes", question.temps_imparti]];
            
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
            
            return cell;
        }
    }
    
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([[array objectAtIndex:indexPath.row] isKindOfClass:[Reponse class]])
    {
        Reponse *reponse = [array objectAtIndex:indexPath.row];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 5.0f, 2 * self.view.frame.size.width / 3 - 50, cell.frame.size.height - 10.0f)];
        
        [textView setText:reponse.reponse];
        [textView setTextColor:[UIColor blackColor]];
        [textView setFont:[UIFont fontWithName:textView.font.fontName size:15.0]];
        [textView setEditable:NO];
        
        [cell addSubview:textView];
        
        [cell.imageView setImage:[UIImage imageNamed:@"iconReponse"]];
        
        if (!self.apercuPartiel)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 50.0f, 20.0f, cell.frame.size.height - 40.0f, cell.frame.size.height - 40.0f)];
        
            if (reponse.reponse_correcte)
            {
                [imageView setImage:[UIImage imageNamed:@"iconBonneReponse.png"]];
            }
            else
            {
                [imageView setImage:[UIImage imageNamed:@"iconMauvaiseReponse.png"]];
            }
            [cell addSubview:imageView];
        }
        
        return cell;
    }
    
    return cell;
}

@end
