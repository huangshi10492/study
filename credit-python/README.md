# credit-python

基于django开发的学分管理系统

## 介绍

本系统的后端主要依靠django框架提供的能力对数据进行CRUD和用户鉴权，前端为了方便使用命令行界面。

## 使用

### 后端

``` sh
pip install django
python manage.py migrate
python manage.py runserver
```

### 管理端

``` sh
pip install prettytable requests
python admin.py
```

### 用户端

``` sh
pip install prettytable requests
python user.py
```
