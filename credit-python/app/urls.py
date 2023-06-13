from django.urls import path

from app import views

urlpatterns = [
    path('admin/login', views.admin_login),
    path('admin/user/add', views.add_user),
    path('user/login', views.user_login),
    path('user/changePwd', views.change_password),
    path('logout', views.logout),
    path('activity/add', views.add_activity),
    path('activity/edit', views.edit_activity),
    path('activity/del', views.del_activity),
    path('activity/get', views.get_activity),
    path('activity/sign', views.sign_activity),
    path('activity/credit', views.get_review),
    path('credit/review', views.credit_review),
    path('credit/get', views.get_credit)
]
