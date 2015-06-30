/**
 * Created by Wei on 2014/6/25.
 */
// 登录
function login() {
    var username = $.trim($("#username").val());
    var password = $.trim($("#password").val());
    if (username == "") {
        $.messager.alert('提示信息', '<span class="error">请输入用户名</span>');
        return;
    }
    if (password == "") {
        $.messager.alert('提示信息', '<span class="error">请输入密码</span>');
        return;
    }
    $.post("/login/", {username: username, password: password}, loginBack);
}
// 登录回调
function loginBack(resp) {
    if (resp.success == true)
        window.location.href = "/home";
    else
        $.messager.alert("登录失败，错误原因：", resp.error);
}
// 初始化事件
function initEvents(){
    $(".login").click(login);
    $(document).bind('keydown', 'return', function(){
        if ($(".messager-window").size() > 0) return;
        login();
    });
}
$(function(){
    initEvents();
});