import json

from django.contrib import auth
from django.contrib.auth.decorators import login_required, user_passes_test
from django.contrib.auth.models import User
from django.core import serializers
from django.core.paginator import Paginator, PageNotAnInteger, EmptyPage
from django.http import JsonResponse
from app.models import Student, Activity, ActivityStudent


# 管理员判断
def admin_check(user):
    return user.is_superuser


# 管理员登录
def admin_login(request):
    if request.method == 'POST':
        username = request.POST.get("name")
        password = request.POST.get("pwd")
        user = auth.authenticate(username=username, password=password)
        if user is not None and user.is_active and admin_check(user):
            auth.login(request, user)
            return JsonResponse({"code": 0, "msg": "登陆成功"})
        else:
            # 登录失败
            return JsonResponse({"code": 1, "msg": "登录失败"})
    return JsonResponse({"code": 1, "msg": "请求无效"})


# 用户登出
@login_required
def logout(request):
    auth.logout(request)
    return JsonResponse({"code": 0, "msg": "退出登录成功"})


# 添加学生
@login_required
@user_passes_test(admin_check)
def add_user(request):
    if request.method == 'POST':
        username = request.POST.get("name")
        student_name = request.POST.get('student_name')
        if User.objects.filter(username=username).exists():
            return JsonResponse({"code": 1, "msg": "学生已存在"})
        user = User.objects.create_user(username=username, password='123456')
        student = Student(user=user, student_name=student_name)
        student.save()
        return JsonResponse({"code": 0, "msg": "添加学生:" + username + "成功"})
    return JsonResponse({"code": 1, "msg": "请求无效"})


# 添加活动
@login_required
@user_passes_test(admin_check)
def add_activity(request):
    if request.method == 'POST':
        name = request.POST.get('name')
        credit = request.POST.get('credit')
        Activity.objects.create(name=name, credit=credit)
        return JsonResponse({"code": 0, "msg": "添加活动成功"})
    return JsonResponse({"code": 1, "msg": "请求无效"})


# 修改活动
@login_required
@user_passes_test(admin_check)
def edit_activity(request):
    if request.method == 'POST':
        activity = Activity.objects.get(id=request.POST.get('id'))
        activity.name = request.POST.get('name') if request.POST.get('name') != '' else activity.name
        activity.credit = request.POST.get('credit') if request.POST.get('credit') != '' else activity.credit
        activity.save()
        return JsonResponse({"code": 0, "msg": "修改活动成功"})
    return JsonResponse({"code": 1, "msg": "请求无效"})


# 删除活动
@login_required
@user_passes_test(admin_check)
def del_activity(request):
    if request.method == 'POST':
        Activity.objects.get(id=request.POST.get('id')).delete()
        return JsonResponse({"code": 0, "msg": "删除活动成功"})
    return JsonResponse({"code": 1, "msg": "请求无效"})


# 获取审核列表
@login_required
@user_passes_test(admin_check)
def get_review(request):
    if request.method == 'GET':
        page = request.GET.get('page')
        activity_id = request.GET.get('activity_id')
        queryset = ActivityStudent.objects.all().filter(activity_id=activity_id).order_by('-id')
        paginator = Paginator(queryset, 10)  # 实例化一个分页对象, 每页显示10个
        try:
            page_obj = paginator.page(page)
        except PageNotAnInteger:
            page_obj = paginator.page(1)  # 如果传入page参数不是整数，默认第一页
        except EmptyPage:
            page_obj = paginator.page(paginator.num_pages)
        data = json.loads(serializers.serialize('json', page_obj))
        for i, _ in enumerate(data):
            data[i]['fields']['student_name'] = page_obj.object_list[i].student.student_name
            data[i]['fields']['student'] = page_obj.object_list[i].student.user.username
        return JsonResponse({"code": 0, "msg": "获取成功", "pages": paginator.num_pages, "data": data})
    return JsonResponse({"code": 1, "msg": "请求无效"})


# 学分审核
@login_required
@user_passes_test(admin_check)
def credit_review(request):
    if request.method == 'POST':
        credit_id = request.POST.get('id')
        status = request.POST.get('status')
        if status in ['1', '2']:
            credit = ActivityStudent.objects.get(id=credit_id)
            credit.status = status
            credit.save()
            return JsonResponse({"code": 0, "msg": "成功"})
    return JsonResponse({"code": 1, "msg": "请求无效"})


# 学生登录
def user_login(request):
    if request.method == 'POST':
        username = request.POST.get("name")
        password = request.POST.get("pwd")
        user = auth.authenticate(username=username, password=password)
        if user is not None and user.is_active and not admin_check(user):
            auth.login(request, user)
            user.student.__dict__.pop("_state")
            return JsonResponse({"code": 0, "msg": "登陆成功", "data": user.student.__dict__})
        else:
            # 登录失败
            return JsonResponse({"code": 1, "msg": "登录失败"})
    return JsonResponse({"code": 1, "msg": "请求无效"})


# 修改密码
@login_required
def change_password(request):
    if request.method == 'POST':
        student_id = request.POST.get('id')
        password = request.POST.get('pwd')
        student = Student.objects.get(id=student_id)
        user = User.objects.get(id=student.user.id)
        user.set_password(password)
        user.save()
        return JsonResponse({"code": 0, "msg": "修改成功"})
    return JsonResponse({"code": 1, "msg": "请求无效"})


# 查看学分
@login_required
def get_credit(request):
    if request.method == 'POST':
        student_id = request.POST.get('id')
        queryset = ActivityStudent.objects.all().filter(student_id=student_id)
        data = json.loads(serializers.serialize('json', queryset))
        for i, _ in enumerate(data):
            data[i]['fields']['activity'] = queryset[i].activity.name
            data[i]['fields']['credit'] = int(queryset[i].activity.credit)
        return JsonResponse({"code": 0, "msg": "获取成功", "data": data})
    return JsonResponse({"code": 1, "msg": "请求无效"})


# 获取活动
@login_required
def get_activity(request):
    if request.method == 'GET':
        page = request.GET.get('page')
        queryset = Activity.objects.all().order_by('-id')
        paginator = Paginator(queryset, 10)  # 实例化一个分页对象, 每页显示10个
        try:
            page_obj = paginator.page(page)
        except PageNotAnInteger:
            page_obj = paginator.page(1)  # 如果传入page参数不是整数，默认第一页
        except EmptyPage:
            page_obj = paginator.page(paginator.num_pages)
        data = json.loads(serializers.serialize('json', page_obj))
        return JsonResponse({"code": 0, "msg": "请求无效", "pages": paginator.num_pages, "data": data})


# 活动报名
@login_required
def sign_activity(request):
    if request.method == 'POST':
        activity_id = request.POST.get('activity_id')
        student_id = request.POST.get('student_id')
        if ActivityStudent.objects.filter(student_id=student_id, activity_id=activity_id).exists():
            return JsonResponse({"code": 1, "msg": "活动已报名，请勿重复报名"})
        student = Student.objects.get(id=student_id)
        student.activity.add(activity_id)
        return JsonResponse({"code": 0, "msg": "报名成功"})
    return JsonResponse({"code": 1, "msg": "请求无效"})
