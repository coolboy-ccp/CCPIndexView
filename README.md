# CCPIndexView
effect of tableviewIndex
修改系统tableview索引的点击效果
使用方法：
#import "UITableView+CCPIndexView.h"
调用：
[tableView ccpIndexView];
注意：tableview一定要指定delegate，并实现sectionIndexTitlesForTableView：
和tableView: sectionForSectionIndexTitle: atIndex:方法
