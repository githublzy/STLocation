//
//  STLocationSendTableViewPresenter.m
//  STLocation
//
//  Created by 梁志云 on 16/6/19.
//  Copyright © 2016年 梁志运. All rights reserved.
//

#import "STLocationSendTableViewPresenter.h"
#import "STLocationAddressCell.h"
#import <CoreLocation/CoreLocation.h>

@interface STLocationSendTableViewPresenter ()

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, assign) CLLocationCoordinate2D centerCoordinate;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) STLocationSendCellConfigureBlock cellConfigureBlock;

@property (nonatomic, copy) STLocationSendTableViewSelectedBlock selectedBlcok;

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation STLocationSendTableViewPresenter

- (instancetype)initWithPoiInfoArray:(NSArray *)poiInfoArray
                      cellIdentifier:(NSString *)cellIdentifier
                  configureCellBlock:(STLocationSendCellConfigureBlock)cellConfigureBlock
                       selectedBlock:(STLocationSendTableViewSelectedBlock)selectedBlock
{
    self = [super init];
    if (self) {
        _poiInfos = poiInfoArray;
        _cellConfigureBlock = cellConfigureBlock;
        _selectedBlcok = selectedBlock;
        _cellIdentifier = cellIdentifier;
        _selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

- (void)setPoiInfos:(NSArray *)poiInfos
{
    if (_poiInfos && _tableView && [self selectedIndexPath].row != 0) {
        NSIndexPath *oldIndexPath = [[self selectedIndexPath] copy];
        
        [self setSelectedIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [_tableView reloadRowsAtIndexPaths:@[oldIndexPath, [self selectedIndexPath]] withRowAnimation:UITableViewRowAnimationFade];
        
        [_tableView scrollToRowAtIndexPath:[self selectedIndexPath] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    _poiInfos = poiInfos;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_tableView) {
        _tableView = tableView;
    }
    
    return [[self poiInfos] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = _cellIdentifier;
    
    STLocationAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[STLocationAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    BMKPoiInfo *poiInfo = [self poiInfos][indexPath.row];
    
    [cell refreshCellWithPoiInfo:poiInfo isSelected:([self selectedIndexPath].row == indexPath.row?YES:NO)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKPoiInfo *poiInfo = nil;
    if (indexPath.row < [[self poiInfos] count]) {
        poiInfo = [self poiInfos][indexPath.row];
    }
    if ([self selectedBlcok]) {
        self.selectedBlcok(poiInfo, indexPath);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath != [self selectedIndexPath]) {
        NSIndexPath *oldIndexPath = [self selectedIndexPath];
        
        [self setSelectedIndexPath:indexPath];
        
        [tableView reloadRowsAtIndexPaths:@[oldIndexPath, indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end