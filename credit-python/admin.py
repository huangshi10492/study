import msvcrt
import os

import requests
from prettytable import PrettyTable

url = 'http://127.0.0.1:8000/'
s = requests.session()


def clean():
    os.system("cls")


def login():
    clean()
    name = input("输入用户名:")
    password = input("输入密码:")
    clean()
    requests.session()
    r = s.post(url + "admin/login", data={"name": name, "pwd": password}).json()
    print(r['msg'])
    print("请按任意键继续~")
    ord(msvcrt.getch())
    if r['code'] != 0:
        login()


def get_activity() -> str | None:
    page = 1
    while 1:
        clean()
        r = s.get(url + "activity/get", params={'page': page}).json()
        print('当前是第 ' + str(page) + ' 页')
        table = PrettyTable(['编号', '活动名称', '学分'])
        for item in r['data']:
            table.add_row([item['pk'], item['fields']['name'], item['fields']['credit']])
        print(table)
        print("e:选择活动", end='\t')
        if page > 1:
            print('a:上一页', end='\t')
        elif page < r['pages']:
            print('d:下一页', end='\t')
        print('q:返回')
        index = msvcrt.getch()
        match index:
            case b'e':
                return input("输入活动编号:")
            case b'a':
                page = page - 1 if page > 1 else 1
            case b'd':
                page = page + 1 if page < r['pages'] else r['pages']
            case b'q':
                return None


def get_credit(activity_id) -> str | None:
    page = 1
    while 1:
        clean()
        r = s.get(url + "activity/credit", params={'page': page, 'activity_id': activity_id}).json()
        print('当前是第 ' + str(page) + ' 页')
        table = PrettyTable(['编号', '学号', '姓名', '审核状态'])
        for item in r['data']:
            status = ''
            match item['fields']['status']:
                case 0:
                    status = '未审核'
                case 1:
                    status = '通过'
                case 2:
                    status = '不通过'
            table.add_row(
                [item['pk'], item['fields']['student_name'], item['fields']['student'], status])
        print(table)
        print("e:选择", end='\t')
        if page > 1:
            print('a:上一页', end='\t')
        elif page < r['pages']:
            print('d:下一页', end='\t')
        print('q:返回')
        index = msvcrt.getch()
        match index:
            case b'e':
                return input("输入编号:")
            case b'a':
                page = page - 1 if page > 1 else 1
            case b'd':
                page = page + 1 if page < r['pages'] else r['pages']
            case b'q':
                return None


def add_activity():
    clean()
    name = input("输入活动名称:")
    credit = input("输入学分:")
    r = s.post(url + "activity/add", data={"name": name, "credit": credit}).json()
    print(r['msg'])
    print("请按任意键返回~")
    ord(msvcrt.getch())


def edit_activity():
    activity_id = get_activity()
    if activity_id is None:
        return
    if activity_id != '':
        name = input("输入活动名称:")
        credit = input("输入学分:")
        r = s.post(url + "activity/edit", data={"id": activity_id, "name": name, "credit": credit}).json()
        print(r['msg'])
        print("请按任意键返回~")
        ord(msvcrt.getch())
    else:
        print("未选择，请按任意键重新选择~")
        ord(msvcrt.getch())
        edit_activity()


def del_activity():
    activity_id = get_activity()
    if activity_id is None:
        return
    if activity_id != '':
        r = s.post(url + "activity/del", data={"id": activity_id}).json()
        print(r['msg'])
        print("请按任意键返回~")
        ord(msvcrt.getch())
    else:
        print("未选择，请按任意键重新选择~")
        ord(msvcrt.getch())
        del_activity()


def credit_review():
    activity_id = get_activity()
    if not activity_id:
        return
    while 1:
        credit_id = get_credit(activity_id)
        if credit_id is None:
            return
        if credit_id != '':
            status = input("1.通过，2.不通过\n请输入:")
            r = s.post(url + "credit/review", data={"id": credit_id, 'status': status}).json()
            print(r['msg'])
            print("请按任意键继续~\n按q退出")
            if msvcrt.getch() == b'q':
                return
        else:
            print("未选择，请按任意键重新选择~")
            ord(msvcrt.getch())
            del_activity()


def add_student():
    while 1:
        clean()
        student = input("请输入学生学号:")
        student_name = input("请输入学生姓名:")
        print("是否确认？\nq:退出，r:重新填写，其他任意键确认")
        index = msvcrt.getch()
        match index:
            case b'q':
                return
            case b'r':
                pass
            case _:
                r = s.post(url + 'admin/user/add', data={'name': student, 'student_name': student_name}).json()
                print(r['msg'])
                print("请按任意键继续~\n按q退出")
                if msvcrt.getch() == b'q':
                    return


def activity():
    while 1:
        clean()
        print('功能选择\n1:添加活动\n2:修改活动\n3:删除活动\n4:返回')
        index = msvcrt.getch()
        match index:
            case b'1':
                add_activity()
            case b'2':
                edit_activity()
            case b'3':
                del_activity()
            case b'4':
                return


def logout():
    clean()
    r = s.post(url + 'logout').json()
    print(r['msg'])


def hello():
    while 1:
        clean()
        print('功能选择\n1:活动管理\n2:学分审核\n3:添加学生\n4:退出系统')
        index = msvcrt.getch()
        match index:
            case b'1':
                activity()
            case b'2':
                credit_review()
                pass
            case b'3':
                add_student()
            case b'4':
                logout()
                return


if __name__ == '__main__':
    login()
    hello()
