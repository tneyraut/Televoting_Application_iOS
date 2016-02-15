//
//  DataQuestionnaireModel.m
//  Televoting
//
//  Created by Thomas Mac on 04/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import "DataQuestionnaireModel.h"

#import "Questionnaire.h"

@interface DataQuestionnaireModel() {
    NSMutableData* _downloadedData;
}

@end

@implementation DataQuestionnaireModel

- (void) getDataQuestionnaire:(int)questionnaire_id
{
    NSURL* jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://isic.mines-douai.fr/televoting/services/getAllDataQuestionnaire.php?questionnaire_id=%d", questionnaire_id]];
    NSURLRequest* urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _downloadedData = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_downloadedData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableArray* _dataQuestionnaire = [[NSMutableArray alloc] init];
    
    NSError* error;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    NSDictionary *jsonElement = jsonArray[0];
    
    [_dataQuestionnaire addObject:jsonElement[@"cours_name"]];
    [_dataQuestionnaire addObject:jsonElement[@"questionnaire_name"]];
    [_dataQuestionnaire addObject:jsonElement[@"mode_examen"]];
    [_dataQuestionnaire addObject:jsonElement[@"malus"]];
    [_dataQuestionnaire addObject:jsonElement[@"pause"]];
    [_dataQuestionnaire addObject:jsonElement[@"lancee"]];
    
    [_dataQuestionnaire addObject:jsonArray[1]];
    [_dataQuestionnaire addObject:jsonArray[2]];
    
    if (self.delegate)
    {
        [self.delegate getDataQuestionnaireDownloaded:_dataQuestionnaire];
    }
}

@end

