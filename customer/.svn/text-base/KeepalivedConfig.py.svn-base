#coding=utf8
__author__ = 'xujun'

KEEPALIVED_MASTER_CONFIG = """\
! Configuration File for keepalived

global_defs {
    router_id RZRKService13
}

vrrp_script checkAll {
       script "/home/rzrk/server/monitor/jk_daemon.sh"
       interval 5
	   weight -20
}

vrrp_instance VI_1 {
    interface eth0
    state BACKUP
    priority 80
	advert_int 2
	nopreempt
    virtual_router_id 213
    garp_master_delay 1

    authentication {
        auth_type PASS
        auth_pass abcdefghijklmn
    }

    track_interface {
       eth0
    }

    virtual_ipaddress {
        {{virtualIp}}/24
    }

    track_script {
       checkAll
    }

    notify_master "/home/rzrk/server/monitor/notify.sh master"
    notify_backup "/home/rzrk/server/monitor/notify.sh backup"
    notify_fault  "/home/rzrk/server/monitor/notify.sh fault"
}
"""

KEEPALIVED_SLAVE_CONFIG = """\
! Configuration File for keepalived

global_defs {
    router_id RZRKService13
}

vrrp_script checkAll {
       script "/home/rzrk/server/monitor/jk_daemon.sh"
       interval 5
	   weight -20
}

vrrp_instance VI_1 {
    interface eth0
    state BACKUP
    priority 70
	advert_int 2
    virtual_router_id 213
    garp_master_delay 1

    authentication {
        auth_type PASS
        auth_pass abcdefghijklmn
    }

    track_interface {
       eth0
    }

    virtual_ipaddress {
        {{virtualIp}}/24
    }

    track_script {
       checkAll
    }

    notify_master "/home/rzrk/server/monitor/notify.sh master"
    notify_backup "/home/rzrk/server/monitor/notify.sh backup"
    notify_fault  "/home/rzrk/server/monitor/notify.sh fault"
}
"""