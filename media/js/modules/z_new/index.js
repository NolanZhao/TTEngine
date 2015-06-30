/**
 * Created by Wei on 2014/6/24.
 */
function createWin(options){
    var defaultConfig = {
        title: "&nbsp;",
        width: $(window).width() - 500,
        height: $(window).height() - 200,
        collapsible:false,
        minimizable:false,
        closed:true,
        modal:true,
        onClose:function(){
            $(this).window("destroy");
        },
        onMove:function(left, top){
            if (top < 0)
                $(this).window("move", {left:left, top:0});
        }
    };
    $.extend(defaultConfig, options);
    var ezWin = window.top.$('<div class="ez-window"></div>');
    return ezWin.window(defaultConfig);
}
function createCustomWin(options, dom){
    var defaultConfig = {resizable:false, maximizable:false};
    $.extend(defaultConfig, options);
    var cWin = createWin(defaultConfig);
    var layout = window.top.$("<div class='custom-layout'></div>");
    cWin.append(layout);
    layout.layout({fit:true});
    layout.layout("add", {
        region: 'center',
        style : 'margin:10px;',
        content: dom.find(".center")[0].outerHTML
    });
    layout.layout("add", {
        region: 'south',
        height: 40,
        border: false,
        content: dom.find(".south")[0].outerHTML
    });
    var buttons = layout.find(".custom-linkbutton");
    buttons.each(function(i, button){
        var icon = $(button).data("icon");
        $(button).linkbutton({iconCls:icon});
    });
    return cWin;
}
function createIframe(src, callback) {
    if (!callback) callback = function(){};
    return $("<iframe></iframe>", {
        scrolling: "yes",
        frameborder: 0,
        style: "width:100%;height:99%;",
        src: src,
        load: callback
    });
}
// 设置菜单块高度，覆盖默认填充
function setMenuHeight(){
    var panels = $(".west .panel");
    panels.find(".panel-body").css("height","auto");
    panels.find(".panel-tool a").removeClass("accordion-expand");
}
// 创建子菜单
function createSubMenu(menus){
    var subMenus = "";
    var iconBase = "/media/z_new/images/icons/";
    var a = "<a href='#' data-id='{0}' data-src='{1}' class='sub-menu'><img src='{2}'/>{3}</a>";
    $.each(menus, function(i, submenu){
        var params = [];
        params.push(submenu.id);
        params.push(submenu.url);
        params.push(iconBase + submenu.icon);
        params.push(submenu.name);
        subMenus += jQuery.validator.format(a, params);
    });
    return subMenus;
}
// 添加Tab
function createTab(options){
    var iframe = '<iframe scrolling="yes" frameborder="0"  src="{0}" style="width:100%;height:99%;"></iframe>';
    var tabs = $(".easyui-tabs");
    tabs.tabs("add", {
        "id": options.id,
        "title": options.title,
        "selected": true,
        "closable": true,
        "content": jQuery.validator.format(iframe, options.url)
    });
}
// 重新加载Tab内容（刷新iframe）
function reloadTabContent(tabTitle){
    var tabs = $(".easyui-tabs");
    var tab = tabs.tabs("getTab", tabTitle);
    if (tab !=null){
        var iframe = tab.find("iframe");
        iframe.attr("src", iframe.attr("src"));
    }
}
function reloadDataGrid(tabTitle){
    var tabs = $(".easyui-tabs");
    var tabsPanels = $(".tabs-panels > .panel");
    var index = tabs.tabs("getTabIndex", tabTitle);
    var iframe = tabsPanels.eq(index).find("iframe");
    var btnRefresh = iframe.contents().find(".btnRefresh");
    btnRefresh.click();
}
// 关闭当前打开的模式窗口
function closeCurrentWindow(){
    var cWin = $(".ez-window:last");
    cWin.window("destroy");
}
// 初始化事件
function initEvents(){
    // 点击子菜单打开Tab
    $(".west").on("click", ".sub-menu", function(){
        var _self = $(this);
        var tabs = $(".easyui-tabs");
        var options = {
            "id": _self.data("id"),
            "url": _self.data("src"),
            "title": _self.text()
        };
        if (tabs.tabs("getTab", options.title)){
            tabs.tabs("select", options.title);
        }else{
            createTab(options);
        }
        return false;
    });


    // 双击对话框标题最大化
    $("body").on("dblclick", ".panel-title", function(e){
        var _self = $(this);
        var ezWin = _self.parents(".window").find(".ez-window");
        var status = _self.data("status");
        if (status){
            _self.data("status", false);
            ezWin.window("restore");
        }else{
            _self.data("status", true);
            ezWin.window("maximize");
        }
    });

    $(".tabs").on("dblclick", "li", function(){ // 双击关闭Tab页
        var tabs = $(".easyui-tabs");
        var selectedTab = tabs.tabs('getSelected');
        var index = tabs.tabs('getTabIndex',selectedTab);
        tabs.tabs("close", index != 0 ? index : "");
    });

    // 按ESC关闭窗口
    $(document).bind('keydown', 'esc', function(){
        var activeWin = window.top.$(".ez-window:last");
        activeWin.window("destroy");
    });

    // 登出
    $(".logout").click(function(){
        var url = $(this).attr("href");
        window.location.replace(url);
    });

    // 同步更换iframe主题
    function changeIframesTheme(param){
        var iframes = $('iframe');
        $.each(iframes, function(i, iframe){
            var doc = $(iframe).contents();
            var url = "/media/js/libs/jquery-easyui-1.4.1/themes/{0}/easyui.css";
            var oldLink = doc.find("#themes");
            if (oldLink.size == 0) return;
            var head = doc.find("head");
            var link = $("<link>", {
                "rel" : "stylesheet",
                "id"  : "themes",
                "href": jQuery.validator.format(url, param.value),
                "load": function(){
                    oldLink.remove();
                }
            });
            link.insertAfter(oldLink);
        });
    }

    // 更换主题
    $(".changeThemes").combobox({
        onSelect: function(param){
            var url = "/media/js/libs/jquery-easyui-1.4.1/themes/{0}/easyui.css";
            var oldLink = $("#themes");
            var head = $("head");
            var link = $("<link>", {
                "rel" : "stylesheet",
                "id"  : "themes",
                "href": jQuery.validator.format(url, param.value),
                "load": function(){
                    oldLink.remove();
                }
            });
            link.insertAfter(oldLink);
            changeIframesTheme(param);
        }
    });
}
$(function(){
    initEvents();
    setMenuHeight();
    $(window).resize(function(){
        setMenuHeight();
    });
});