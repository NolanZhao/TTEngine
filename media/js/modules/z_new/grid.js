/**
 * Created by Wei on 2014/11/28.
 */
function syncTheme(){
    var theme = window.top.$('.changeThemes').combobox('getValue');
    var url = "/media/js/libs/jquery-easyui-1.4.1/themes/{0}/easyui.css";
    var oldLink = $("#themes");
    if (oldLink.size == 0) return;
    var link = $("<link>", {
        "rel" : "stylesheet",
        "id"  : "themes",
        "href": jQuery.validator.format(url, theme),
        "load": function(){
            oldLink.remove();
        }
    });
    link.insertAfter(oldLink);
}
$(function(){
    syncTheme();

    // 按ESC关闭窗口
    $(document).bind('keydown', 'esc', function(){
        var activeWin = window.top.$(".ez-window:last");
        activeWin.window("destroy");
    });
});