/**
 * Created by Wei on 2014/11/28.
 */
function renderStatusStyle(value,row,index){
    var styles = [
        'background-color:red;color:#fff;',
        'background-color:green;color:#fff;',
        'background-color:yellow;color:red;'
    ];
    return styles[value];
}
function renderAttachment(value,row,index){
    var link = '<a href="/{0}" target="_blank">下载</a>';
    return $.validator.format(link, value);
}
function showDetail(index,rowData){
    var ezWin = window.top.createWin({
        title: rowData.customer + ' - 详情',
        width: 500,
        height: 400
    });
    ezWin.append('<div style="padding: 20px;">' + rowData.detail + '</div>');
    ezWin.window("open");
}
function getColumns(){
    return [[
        {field:'module_type', title:'模块类型', width:120, align:'center', sortable:true},
		{field:'log_type', title:'日志类型', width:120, align:'center', sortable:true},
		{field:'monitor_type', title:'状态', width:80, align:'center', sortable:true, styler: renderStatusStyle,
            formatter: function(value,row,index){
                var dict = ['错误', '正常', '客户反馈'];
                return dict[value];
            }
        },
		{field:'create_user', title:'运维员', width:120, align:'center', sortable:true},
		{field:'detail', title:'详情', width:500, align:'left'},
		{field:'attachment_url', title:'附件', width:80, align:'center', formatter: renderAttachment},
		{field:'create_time', title:'提交时间', width:140, align:'center', sortable:true}
	]];
}
$(function(){
    var logListDetail = $('#logListDetail');
    logListDetail.datagrid({
        view: scrollview,
        loadMsg: '正在获取数据......',
        url: '/serverMonitor/getLogListDetail/?customerid=' + window.cusId,
        method: 'get',
        rownumbers:true,
        singleSelect:true,
        autoRowHeight:false,
        remoteSort: false,
        fit: true,
        pageSize:100,
        columns: getColumns(),
        onClickRow: showDetail
    });
});