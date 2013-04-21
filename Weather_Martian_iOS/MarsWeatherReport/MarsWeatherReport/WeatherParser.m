//
//  WeatherParser.m
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/16/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import "WeatherParser.h"
#import "TBXML.h"
#import "File.h"


#define kElementWeatherReportKey @"weather_report"
#define kElementTitleKey @"title"
#define kElementLinkKey @"link"
#define kElementSolKey @"sol"
#define kElementTerrestialDateKey @"terrestrial_date"
#define kElementMagnitudesKey @"magnitudes"
#define kElementMinTempKey @"min_temp"
#define kElementMaxTempKey @"max_temp"
#define kElementPressureKey @"pressure"
#define kElementPressureStringKey @"pressure_string"
#define kElementHumidityKey @"abs_humidity"
#define kElementWindSpeedKey @"wind_speed"
#define kElementWindDirectionKey @"wind_direction"
#define kElementATMOOpacityKey @"atmo_opacity"
#define kElementSeasonKey @"season"
#define kElementLSKey @"ls"
#define kElementSunriseKey @"sunrise"
#define kElementSunsetKey @"sunset"


@implementation WeatherParser
@synthesize key;
@synthesize weather;
@synthesize delegate;
-(id)initWithKey:(NSString *)aKey delegate:(id<WeatherParserDelegate>)del{
    if (self=[super init]) {
        self.key=aKey;
        self.delegate=del;
    }
    return self;
}

-(void)main{
    @autoreleasepool {
        NSString *fileName=[File pathInDocumentsDirectoryForFileName:[NSString stringWithFormat:@"%@.txt",key]];
        NSError *error=nil;
        NSData *data=[NSData dataWithContentsOfFile:fileName];
        
        TBXML *tbxml=[TBXML newTBXMLWithXMLData:data error:&error];
        if (!error) {
            TBXMLElement *rootElement=[tbxml rootXMLElement];
            [self traverseElement:rootElement];
            [(NSObject*)self.delegate performSelectorOnMainThread:@selector(weatherParserDidFinishParsing:) withObject:self waitUntilDone:NO];
            
        }
        else{
            self.error=error;
            [(NSObject*)self.delegate performSelectorOnMainThread:@selector(weatherParserDidFailWithError:) withObject:self waitUntilDone:NO];
            
            NSLog(@"error in tbxml %@",error.description);
        }
    }
}
-(void)traverseElement:(TBXMLElement *)element{
    do {
        NSString *elementName=[TBXML elementName:element];
        if (element->firstChild) {
            [self traverseElement:element->firstChild];
        }
        if ([elementName isEqualToString:kElementWeatherReportKey]) {
            
            Weather *w=[[Weather alloc] init];
            
            TBXMLElement *titleElement=[TBXML childElementNamed:kElementTitleKey parentElement:element];
            TBXMLElement *linkElement=[TBXML childElementNamed:kElementLinkKey parentElement:element];
            TBXMLElement *solElement=[TBXML childElementNamed:kElementSolKey parentElement:element];
            TBXMLElement *terrestialDateElement=[TBXML childElementNamed:kElementTerrestialDateKey parentElement:element];
            
            w.title=[TBXML textForElement:titleElement];
            w.link=[TBXML textForElement:linkElement];
            w.sol=[TBXML textForElement:solElement];
            w.terrestialDate=[TBXML textForElement:terrestialDateElement];
            
            
            NSError *error=nil;
            TBXMLElement *magnitudesElement=[TBXML childElementNamed:kElementMagnitudesKey parentElement:element error:&error];
            if (!error) {
                TBXMLElement *minTempElement=[TBXML childElementNamed:kElementMinTempKey parentElement:magnitudesElement];
                TBXMLElement *maxTempElement=[TBXML childElementNamed:kElementMaxTempKey parentElement:magnitudesElement];
                TBXMLElement *pressureElement=[TBXML childElementNamed:kElementPressureKey parentElement:magnitudesElement];
                TBXMLElement *pressureStringElement=[TBXML childElementNamed:kElementPressureStringKey parentElement:magnitudesElement];
                TBXMLElement *humidityElement=[TBXML childElementNamed:kElementHumidityKey parentElement:magnitudesElement];
                TBXMLElement *windSpeedElement=[TBXML childElementNamed:kElementWindSpeedKey parentElement:magnitudesElement];
                TBXMLElement *windDirectionElement=[TBXML childElementNamed:kElementWindDirectionKey parentElement:magnitudesElement];
                TBXMLElement *atmoElement=[TBXML childElementNamed:kElementATMOOpacityKey parentElement:magnitudesElement];
                TBXMLElement *seasonElement=[TBXML childElementNamed:kElementSeasonKey parentElement:magnitudesElement];
                TBXMLElement *lsElement=[TBXML childElementNamed:kElementLSKey parentElement:magnitudesElement];
                TBXMLElement *sunriseElement=[TBXML childElementNamed:kElementSunriseKey parentElement:magnitudesElement];
                TBXMLElement *sunsetElement=[TBXML childElementNamed:kElementSunsetKey parentElement:magnitudesElement];
                
                
                w.minTemp=[[TBXML textForElement:minTempElement] doubleValue];
                w.maxTemp=[[TBXML textForElement:maxTempElement] doubleValue];
                w.pressure=[[TBXML textForElement:pressureElement] doubleValue];
                w.pressureString=[TBXML textForElement:pressureStringElement];
                w.humidity=[[TBXML textForElement:humidityElement] doubleValue];
                w.windSpeed=[[TBXML textForElement:windSpeedElement] doubleValue];
                w.windDirection=[TBXML textForElement:windDirectionElement];
                w.atmoOpacity=[TBXML textForElement:atmoElement];
                w.season=[TBXML textForElement:seasonElement];
                w.ls=[[TBXML textForElement:lsElement] doubleValue];
                w.sunrise=[TBXML textForElement:sunriseElement];
                w.sunset=[TBXML textForElement:sunsetElement];
                
            }
            self.weather=w;
            
        }
        
    } while ((element=element->nextSibling));
}
@end
