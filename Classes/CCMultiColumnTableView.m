//
//  SWMultiColumnTableView.m
//  SWGameLib
//
//
//  Copyright (c) 2010 Sangwoo Im
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Sangwoo Im on 6/3/10.
//  Copyright 2010 Sangwoo Im. All rights reserved.
//

#import "CCMultiColumnTableView.h"
#import "CCTableViewCell.h"


@implementation CCMultiColumnTableView
@synthesize colCount;

-(id)initWithViewSize:(CGSize)size {
    if ((self = [super initWithViewSize:size])) {
        colCount = 1;
    }
    return self;
}

-(void)setColCount:(NSUInteger)cols {
    colCount = cols;
    if (self.direction == CCScrollViewDirectionBoth) {
        [self _updateContentSize];
    }
}

-(NSInteger)__indexFromOffset:(CGPoint)offset {
    NSInteger  index;
    CGSize     cellSize;
    NSInteger  col, row;
    CGFloat    spaceWidth;

    cellSize = [self.dataSource cellSizeForTable:self];

    switch (self.direction) {
        case CCScrollViewDirectionHorizontal:
            spaceWidth = self.container.contentSize.height / colCount;
            col = (offset.y - (spaceWidth - cellSize.height)*0.5)/spaceWidth;
            row = offset.x / cellSize.width;
            break;
        default:
            spaceWidth = self.container.contentSize.width / colCount;
            col = (offset.x - (spaceWidth - cellSize.width)*0.5)/spaceWidth;
            row = offset.y / cellSize.height;
            break;
    }
    index = col + row * colCount;
    return index;
}

-(CGPoint)__offsetFromIndex:(NSInteger)index {
    CGPoint    offset;
    CGSize     cellSize;
    CGFloat    spaceWidth;
    NSInteger  col, row;

    cellSize = [self.dataSource cellSizeForTable:self];

    switch (self.direction) {
        case CCScrollViewDirectionHorizontal:
            row = index / colCount;
            col = index % colCount;
            spaceWidth = self.container.contentSize.height / colCount;
            offset = ccp(row * cellSize.height,
                         col * spaceWidth + (spaceWidth - cellSize.width) * 0.5);
            break;
        default:
            row = index / colCount;
            col = index % colCount;
            spaceWidth = self.container.contentSize.width / colCount;
            offset = ccp(col * spaceWidth + (spaceWidth - cellSize.width) * 0.5,
                         row * cellSize.height);
            break;
    }

    return offset;
}

-(void)_updateContentSize {
    CGSize size, cellSize, viewSize;
    NSUInteger cellCount, rows;

    cellSize = [self.dataSource cellSizeForTable:self];
    cellCount = [self.dataSource numberOfCellsInTableView:self];
    viewSize = CGSizeMake(_viewSize.width/self.container.scaleX, _viewSize.height/self.container.scaleY);

    switch (self.direction) {
        case CCScrollViewDirectionHorizontal:
            colCount = viewSize.height / cellSize.height;
            rows = ceilf(cellCount/((CGFloat)colCount));
            size = CGSizeMake(MAX(rows * cellSize.width, viewSize.width), colCount * cellSize.height);
            break;
        default:
            if (self.direction == CCScrollViewDirectionVertical) {
                colCount = viewSize.width / cellSize.width;
            }
            rows = ceilf(cellCount/((CGFloat)colCount));
            size = CGSizeMake(MAX(cellSize.width * colCount, viewSize.width), rows * cellSize.height);
            break;
    }
    [self setContentSize:size];
}
@end
