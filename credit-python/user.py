import msvcrt
import os

import requests
from prettytable import PrettyTable

url = 'http://127.0.0.1:8000/'
s = requests.session()
student_id = ''


def clean():
    os.system("cls")


def login():
    clean()
    name = input("输入用户名:")
    password = input("输入密码:")
    clean()
    requests.session()
    r = s.post(url + "user/login", data={"name": name, "pwd": password}).json()
    print(r['msg'])
    print("请按任意键继续~")
    ord(msvcrt.getch())
    if r['code'] != 0:
        login()
    else:
        global student_id
        student_id = r['data']['id']


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
                page = page - 1 if page != 1 else 1
            case b'd':
                page = page + 1 if page != r['pages'] else r['pages']
            case b'q':
                return None


def activity():
    activity_id = get_activity()
    if activity_id is None:
        return
    if activity_id != '':
        r = s.post(url + "activity/sign", data={"activity_id": activity_id, "student_id": student_id}).json()
        print(r['msg'])
        print("请按任意键返回~")
        ord(msvcrt.getch())
    else:
        print("未选择，请按任意键重新选择~")
        ord(msvcrt.getch())
        activity()


def get_credit():
    r = s.post(url + "credit/get", data={"id": student_id}).json()
    page = 1
    max_page = int(len(r['data']) / 10) + 1
    all_credit = 0
    for item in r['data']:
        if item['fields']['status'] == 1:
            all_credit += item['fields']['credit']
    while 1:
        clean()
        print('现在获得的学分:' + str(all_credit) + '分')
        print('当前是第 ' + str(page) + ' 页')
        table = PrettyTable(['编号', '活动名称', '学分', '状态'])
        for i in range(10):
            if (page - 1) * 10 + i < len(r['data']):
                status = ''
                match r['data'][(page - 1) * 10 + i]['fields']['status']:
                    case 0:
                        status = '未审核'
                    case 1:
                        status = '通过'
                    case 2:
                        status = '不通过'
                table.add_row(
                    [r['data'][(page - 1) * 10 + i]['pk'], r['data'][(page - 1) * 10 + i]['fields']['activity'],
                     r['data'][(page - 1) * 10 + i]['fields']['credit'], status])
        print(table)
        if page > 1:
            print('a:上一页', end='\t')
        elif page < max_page:
            print('d:下一页', end='\t')
        print('q:返回')
        index = msvcrt.getch()
        match index:
            case b'a':
                page = page - 1 if page > 1 else 1
            case b'd':
                page = page + 1 if page < max_page else max_page
            case b'q':
                return None


def change_pwd():
    clean()
    new_pwd = input("请输入新的密码:")
    r = s.post(url + 'user/changePwd', data={'id': student_id, 'pwd': new_pwd}).json()
    print(r['msg'])
    print("请重新登录~")


def hello():
    while 1:
        clean()
        print('功能选择\n1:报名活动\n2:查看学分\n3:修改密码\n4:退出登录')
        index = msvcrt.getch()
        match index:
            case b'1':
                activity()
            case b'2':
                get_credit()
            case b'3':
                change_pwd()
                return
            case b'4':
                return


if __name__ == '__main__':
    login()
    hello()
