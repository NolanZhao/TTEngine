__author__ = 'rzrk001'
from utils.StringHelper import replaceStr
from TTEngine.constants import RUN_TYPE_TIMER
def win_getCrontable(runInfos, xtDir):
    strRuns = []
    weekset = ['SUN','MON','TUE','WED','THU','FRI','SAT']
    hourset = ['00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23']
    minuteset = ['00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37','38','39','40','41','42','43','44','45','46','47','48','49','50','51','52','53','54','55','56','57','58','59']
    dict = {}
    for info in runInfos:
        if info.runType == RUN_TYPE_TIMER:
            runParam = info.runParam.strip()
            name = runParam.split('/')[-1]
            name = name.split('.')[0]
            if name in dict:
                i = dict[name] + 1
            else:
                dict[name] = 0
                i = dict[name]
            print "dict[name] :%s" % dict[name]
            xe = "c:\windows\system32\schtasks /create "  + "/tr %s " % runParam
            x = ""
            restarts = info.timerParam.split()
            st,dict[name] = wek(restarts,weekset,name,i,xe,hourset,minuteset,dict)
            print st
            if len(st) > 0:
                st = "\n".join(st)
                strRuns.append(st)

    ret = "\n".join(strRuns)
    ret = ret + "\n"
    ret = replaceStr(ret, {"xtDir":xtDir})

    return ret

def hour(restarts,hourset):
    hhh = []
    if restarts.find(',') >= 0:
        hour_res = restarts.split(',')
        for hour_re in hour_res:
            if hour_re.find('/') >= 0:
                hour_arr = hour_re.split('/')
                if hour_arr[0].find('-') >= 0:
                    hour_ar = hour_arr[0].split('-')
                    xs = hourset[int(hour_ar[0]):int(hour_ar[1])+1:hour_arr[1]]
                else:
                    hour_ar = hour_arr[0]
                    xs = hourset[int(hour_ar)]
            else:
                hour_arr = [hour_re,1]
                if hour_arr[0].find('-') >= 0:
                    hour_ar = hour_arr[0].split('-')
                    xs = hourset[int(hour_ar[0]):int(hour_ar[1])+1:hour_arr[1]]
                else:
                    hour_ar = hour_arr[0]
                    xs = hourset[int(hour_ar)]
            hhh.append(xs)
    else :
        hour_res = restarts
        if hour_res.find('/') >= 0:
            hour_arr = hour_res.split('/')
            if hour_arr[0].find('-') >= 0:
                hour_ar = hour_arr[0].split('-')
                xs = hourset[int(hour_ar[0]):int(hour_ar[1])+1:int(hour_arr[1])]
            else:
                hour_ar = hour_arr[0]
                xs = hourset[int(hour_ar)]
        else:
            hour_arr = [hour_res,1]
            if hour_arr[0].find('-') >= 0:
                hour_ar = hour_arr[0].split('-')
                xs = hourset[int(hour_ar[0]):int(hour_ar[1])+1:hour_arr[1]]
            else:
                hour_ar = hour_arr[0]
                xs = hourset[int(hour_ar)]
        hhh = xs
    return hhh

def minutes(restarts,minuteset):
    mmm = []
    if restarts.find(',') >= 0:
        miunte_res = restarts.split(',')
        for miunte_re in miunte_res:
            if miunte_re.find('/') >= 0:
                minute_arr = miunte_re.split('/')
            else:
                minute_arr = [miunte_re,1]
            if minute_arr[0].find('-') >= 0:
                minute_ar = minute_arr[0].split('-')
                mm = minuteset[int(minute_ar[0]):int(minute_ar[1])+1:minute_arr[1]]
            else:
                minute_ar = minute_arr[0]
                mm =  minuteset[int(minute_ar)]
            mmm.append(mm)

    else :
        miunte_res = restarts
        if miunte_res.find('/') >= 0:
            minute_arr = miunte_res.split('/')
        else:
            minute_arr = [miunte_res,1]
        if minute_arr[0].find('-') >= 0:
            minute_ar = minute_arr[0].split('-')
            mm = minuteset[int(minute_ar[0]):int(minute_ar[1])+1:int(minute_arr[1])]
        else:
            minute_ar = minute_arr[0]
            mm =  minuteset[int(minute_ar)]
        mmm = mm
    return mmm

def wek(restarts,weekset,name,i,xe,hourset,minuteset,dict):
    whs = []
    x = []

    if restarts[4] == '*':
        st = xe
        if restarts[1] == "*" and  restarts[0] != "*":
            if restarts[0].find('*') == 0:
                mmm = restarts[0].split('/')[-1]
            else:
                mmm = minutes(restarts[0],minuteset)
            if isinstance(mmm,str):
                s = st + "/sc hourly /tn %s_%s /st 00:00>y.txt " % (name,i)
                i += 1
                whs.append(s)
            else:
                for m in mmm:
                    s = st + "/sc hourly /tn %s_%s /st 00:%s>y.txt" % (name,i,m)
                    i += 1
                    whs.append(s)
        elif restarts[1] != "*" and  restarts[0] == "*":
            if restarts[1].find("*") == 0:
                hhh = restarts[1].split('/')[-1]
            else:
                hhh = hour(restarts[0],hourset)
            if isinstance(hhh,str):
                s = st + "/sc minute /tn %s_%s /st %s:00>y.txt:" % (name,i,hhh)
                i += 1
                whs.append(s)
            else:
                for h in hhh:
                    s = st + "/sc minute /tn %s_%s /st %s:00>y.txt" % (name,i,h)
                    i += 1
                    whs.append(s)
        elif restarts[1] == "*" and  restarts[0] == "*":
            s = st + "/sc minute /tn %s_%s " % (name,i)
            i += 1
            whs.append(s)
        elif restarts[1] != "*" and restarts[0] != "*":
            if restarts[0].find('*') == 0:
                mmm = restarts[0].split('/')[-1]
            else:
                mmm = minutes(restarts[0],minuteset)
            if restarts[1].find('*') == 0:
                hhh = restarts[1].split('/')[-1]
            else:
                hhh = hour(restarts[1],hourset)
            if isinstance(hhh,list) and isinstance(mmm,list):
                for x in hhh:
                    for m in mmm:
                        s = st + "/sc daily /tn %s_%s /st %s:%s>y.txt" % (name,i,x,m)
                        i += 1
                        print '1'
                        whs.append(s)
            elif isinstance(hhh,list) and isinstance(mmm,str):
                for h in hhh:
                    s = st + "/sc daily /tn %s_%s /st %s:%s>y.txt" % (name,i,h,mmm)
                    i += 1
                    print '12'
                    whs.append(s)
            elif isinstance(mmm,list) :
                for m in mmm:
                    s = st + "/sc daily /tn %s_%s /st %s:%s>y.txt" % (name,i,hhh,m)
                    i += 1
                    print '13'
                    whs.append(s)
            else :
                s = st + "/sc daily /tn %s_%s /st %s:%s>y.txt" % (name,i,hhh,mmm)
                print '14'
                whs.append(s)



    else:
        if restarts[4].find(',') >= 0:
            week_res = restarts[4].split(',')
            for week_re in week_res:
                if week_re.find('/') >= 0:
                    week_arr = week_re.split('/')
                else:
                    week_arr = [week_re,1]
                if week_arr[0].find('-') >= 0:
                    week_ar = week_arr[0].split('-')
                    xs = weekset[int(week_ar[0]):int(week_ar[1])+1:week_arr[1]]
                else:
                    week_ar = week_arr[0]
                    xs = weekset[int(week_ar)]
                i += 1
                x += xs
        else :
            week_res = restarts[4]
            if week_res.find('/') >= 0:
                week_arr = week_res.split('/')
            else:
                week_arr = [week_res,1]
            if week_arr[0].find('-') >= 0:
                week_ar = week_arr[0].split('-')
                xs = weekset[int(week_ar[0]):int(week_ar[1])+1:int(week_arr[1])]
            else:
                week_ar = week_arr[0]
                xs = weekset[int(week_ar)]
            x = xs
        x = ','.join(x)

        st = xe + "/sc WEEKLY /d %s" % x
        if restarts[1] == "*" and restarts[0] != "*":
            if restarts[0].find('*') == 0:
                mmm = restarts[0].split('*')[-1]
            else:
                mmm = minutes(restarts[0],minuteset)
            if isinstance(mmm,str):
                for h in hourset:
                    s = st + " /tn %s_%s /st %s:%s>y.txt" % (name,i,h,mmm)
                    i += 1
            else:
                for h in hourset:
                    for m in mmm:
                        s = st + " /tn %s_%s /st %s:%s>y.txt" % (name,i,h,m)
                        i += 1
        elif restarts[1] != "*" and restarts[0] == "*":
            if restarts[1].find("*") == 0:
                hhh = restarts[1].split('/')[-1]
            else:
                hhh = hour(restarts[0],hourset)
            if isinstance(hhh,str):
                for m in minuteset:
                    s = st + "/tn %s_%s /st %s:%s>y.txt" % (name,i,hhh,m)
                    i += 1
                whs.append(s)
            else:
                for m in minuteset:
                    for h in hhh:
                        s = st + "/tn %s_%s /st %s:%s>y.txt" % (name,i,h,m)
                        i += 1
                        whs.append(s)
        elif restarts[1] == "*" and restarts[0].find("*") == 0:
            s = st + "/tn %s_%s>y.txt" % (name,i)
            i +=1
            whs.append(s)

        elif restarts[1] != "*" and restarts[0] != "*":
            if restarts[0].find('*') == 0:
                mmm = restarts[0].split('/')[-1]
            else:
                mmm = minutes(restarts[0],minuteset)
            if restarts[1].find('*') == 0:
                hhh = restarts[1].split('/')[-1]
            else:
                hhh = hour(restarts[1],hourset)
            if isinstance(hhh,list) and isinstance(mmm,list):
                for x in hhh:
                    for m in mmm:
                        s = st + "/tn %s_%s /st %s:%s>y.txt" % (name,i,x,m)
                        i += 1
                        print '1'
                        whs.append(s)
            elif isinstance(hhh,list) and isinstance(mmm,str):
                for h in hhh:
                    s = st + "/tn %s_%s /st %s:%s>y.txt" % (name,i,h,mmm)
                    i += 1
                    print '12'
                    whs.append(s)
            elif isinstance(mmm,list) :
                for m in mmm:
                    s = st + "/tn %s_%s /st %s:%s>y.txt" % (name,i,hhh,m)
                    i += 1
                    print '13'
                    whs.append(s)
            else :
                s = st + "/tn %s_%s /st %s:%s>y.txt" % (name,i,hhh,mmm)
                print '14'
                whs.append(s)

    return whs,i


if __name__ == "__main__":
    print '1234'
    win_getCrontable("*/1 2-8/2    * * *", 'xtDir','D:server/monitor/runBanlanceSettlment.sh')
    win_getCrontable("*/1 10-23/3    * * *", 'xtDir','D:server/monitor/runBanlanceSettlment.sh')
    print 'whs'
# def month(restarts,monset,dayset):
#     if restarts[3] != "*" and restarts[2] != "*":
#         if restarts[3].find(',') >= 0:
#             res = restarts[3].spilt(',')
#             for re in res:
#                 if re.find('/') >= 0:
#                     arr = re.spilt('/')
#                     if arr[0].find('-') >= 0:
#                         ar = arr[0].spilt('-')
#                     xs = monset[ar[0]:ar[1]:arr[1]]
#                     str = "/sc monthly /m %s " %  xs
#         if restarts[2].find(',') >= 0:
#             res = restarts[2].find(',')
#             for re in res:
#                 if re.find('/') >= 0:
#                     arr = re.spilt('/')
#                     if arr[0].find('-') >= 0:
#                         ar = arr[0].spilt('-')
#                     xs = dayset[ar[0]:ar[1]:arr[1]]
#                     for x in xs:
#                         str1 = str + "/d %s" % x
#     elif restarts[3] == "*" and restarts[2] != "*":
#         if restarts[2].find(',') >= 0:
#             res = restarts[2].spilt(',')
#             for re in res:
#                 if re.find('/') >= 0:
#                     arr = re.spilt('/')
#                     if arr[0].find('-') >= 0:
#                         ar = arr[0].spilt('-')
#                     xs = dayset[ar[0]:ar[1]:arr[1]]
#                     for x in xs:
#                         str ="/sc monthly /d %s " % x
#
#     elif restarts[2] == "*" and restarts[3] != "*":
#         if restarts[3].find(',') >= 0:
#             res = restarts[3].spilt(',')
#             for re in res:
#                 if re.find('/') >= 0:
#                     arr = re.spilt('/')
#                     if arr[0].find('-') >= 0:
#                         ar = arr[0].spilt('-')
#                     xs = monset[ar[0]:ar[1]:arr[1]]
#                     str = "/sc monthly /m %s " %  xs
#     else :
#         str = ""
#     return str

