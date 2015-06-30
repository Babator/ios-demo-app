//
//  ListVideosView.m
//  Babator
//
//  Created by Andrey Kulinskiy on 6/4/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import "ListVideosView.h"
#import "ListVideosCell.h"
#import "BBTVideoItem.h"

#define HeightCell 150

@interface ListVideosView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* items;

@end

@implementation ListVideosView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.items = @[];
    [self addSubview:self.tableView];
}

#pragma mark -
#pragma mark Methods
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}

#pragma mark -
#pragma mark Actions

#pragma mark -
#pragma mark Propertys
- (void)setVideos:(NSArray *)videos {
    
    _videos = videos;
    if (videos) {
        self.items = videos;
        
    }
    else {
        self.items = @[];
    }
    
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    [self addSubview:self.tableView];
    
    [self.tableView reloadData];
    self.tableView.contentInset = UIEdgeInsetsZero;
}

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        //[_tableView setSeparatorInset:UIEdgeInsetsZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSString *CellIdentifier = @"Cell";
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell %ld - %ld", (long)indexPath.section, (long)indexPath.row];
    ListVideosCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ListVideosCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        BBTVideoItem* item = [self.items objectAtIndex: indexPath.row];
        [cell setData:item];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HeightCell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BBTVideoItem* item = [self.items objectAtIndex: indexPath.row];
    [self.delegate listVideosView:self selectItem:item];
}



@end



