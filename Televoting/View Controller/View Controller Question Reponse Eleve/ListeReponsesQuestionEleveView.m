//
//  ListeReponsesQuestionEleveView.m
//  Televoting
//
//  Created by Thomas Mac on 27/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "ListeReponsesQuestionEleveView.h"

#import "SpecificTableViewCell.h"

#import "reponse_question_eleve.h"

@interface ListeReponsesQuestionEleveView () <UIAlertViewDelegate>

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) QuestionEleveModel *_questionEleveModel;

@property(nonatomic, strong) NSString *nouvelleReponse;

@end

@implementation ListeReponsesQuestionEleveView

- (void) initialisationView {
    
    [self.navigationItem setTitle:@"Réponses"];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.498 green:0.776 blue:0.737 alpha:1]];
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [self.navigationController.navigationBar setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil]];
    
    if (self.user.professeur)
    {
        UIBarButtonItem *buttonRepondre = [[UIBarButtonItem alloc] initWithTitle:@"Répondre" style:UIBarButtonItemStyleDone target:self action:@selector(actionListenerButtonRepondre)];
        
        [buttonRepondre setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
        
        [self.navigationItem setRightBarButtonItem:buttonRepondre];
    }
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Réponses" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
}

- (void) actionListenerButtonRepondre
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] init];
    
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alertView setDelegate:self];
    
    [alertView setTitle:@"Répondre"];
    [alertView setMessage:self.question_eleve_selected.question];
    
    [[alertView textFieldAtIndex:0] setPlaceholder:@"Réponse"];
    [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
    
    [alertView addButtonWithTitle:@"Valider"];
    [alertView addButtonWithTitle:@"Annuler"];
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Valider"])
    {
        [self creerReponseEleve:self.question_eleve_selected.question_eleve_id user_id:self.user.user_id reponse:[alertView textFieldAtIndex:0].text];
    }
}

- (void) creerReponseEleve:(int)questionEleve_id user_id:(int)user_id reponse:(NSString*)reponse
{
    [self.activityIndicatorView startAnimating];
    
    if (!self._questionEleveModel)
    {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        self._questionEleveModel = [[QuestionEleveModel alloc] init];
        
        self._questionEleveModel.delegate = self;
    }
    
    self.nouvelleReponse = reponse;
    
    [self._questionEleveModel creationReponseQuestionEleve:questionEleve_id user_id:user_id reponse:reponse];
}

- (void) questionsEleveDownloaded:(NSArray *)items
{
    reponse_question_eleve *new_reponse_question_eleve = [[reponse_question_eleve alloc] init];
    
    new_reponse_question_eleve.reponse = self.nouvelleReponse;
    
    [self.reponsesQuestionEleveArray addObject:new_reponse_question_eleve];
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.reponsesQuestionEleveArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 3, 5.0f, 2 * self.view.frame.size.width / 3, cell.frame.size.height - 10.0f)];
    
    [textView setTextColor:[UIColor blackColor]];
    [textView setFont:[UIFont fontWithName:textView.font.fontName size:15.0]];
    [textView setEditable:NO];
    
    if (indexPath.row == 0)
    {
        [textView setText:self.question_eleve_selected.question];
        
        [cell.imageView setImage:[UIImage imageNamed:@"iconQuestion.png"]];
    }
    else
    {
        reponse_question_eleve *reponseQuestionEleve = [[reponse_question_eleve alloc] init];
        
        reponseQuestionEleve = self.reponsesQuestionEleveArray[indexPath.row - 1];
        
        [textView setText:reponseQuestionEleve.reponse];
        
        [cell.imageView setImage:[UIImage imageNamed:@"iconReponse.png"]];
    }
    
    [cell addSubview:textView];
    
    return cell;
}

@end
