# chapter2

## docker help * 获取帮助

### example

![image.png](https://upload-images.jianshu.io/upload_images/5977684-227a22b56a590141.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### centos 启动docker daemon


1. 安装启动nginx镜像
> docker run --detach --name web nginx:latest
> 
> --detach  (-d)  以守护模式在后台运行 

309b883e6c24d0d2e9f71c452ac18265977e4e3c317e7ab3ba81fa966c06bb60

2. 安装邮件程序
> docker run -d --name mailer dockerinaction/ch2_mailer

3. 运行交互式容器
> docker run --interactive --tty --link web:web --name web_test busybox:latest /bin/sh

> --interactive (-i) docker保持标准输入流对容器开放     
> --tty (-t)    为docker容器分配一个虚拟终端

4. wget -O - HTTP://web:80/ 访问容器web上的nginx

5. exit 终止shell,停止该容器

6. 启动监控器
> docker run -it --name agent --link web:insideweb --link mailer:insidemailer dockerinaction/ch2_agent

---
## docker 常用命令
1. 列出正在运行的容器 docker ps (-a)
    - 容器ID
    - 使用的镜像
    - 容器中执行的命令
    - 容器运行的时长
    - 容器暴露的网络端口
    - 容器名

2. 重新启动容器         docker restart web

3. 检查容器的日志       docker logs web 日志不会轮转，将持续增长，持久保存
   
4. 重命名容器           docker rename [oldname] [newname]

5. 执行容器             docker exec [name|id]

6. 停止容器             docker stop [name|id]

7. 创建容器而不启动      docker create [name]

8. 删除容器             docker rm -f [name]

9. 删除所有容器         docker rm -vf $(docker ps -a -q)

---
## PID命名空间
docker为每一个容器创建一个PID命名空间

1. docker run -d --name namespaceA busybox:latest /bin/sh -c "sleep 30000"
2. docker run -d --name namespaceB busybox:latest /bin/sh "nc -l -p 0.0.0.0:80"
3. 执行以下两条命令将看到两个不同的进程列表
   - docker exec namespaceA ps
   - docker exec namespaceB ps
4. 创建没有pid命名空间的容器
   - docker run --pid host busybox:latest ps

---
## 系统中两个程序引起冲突的常见原因
- 两个程序绑定到相同的网络端口号
- 使用相同的临时文件名或文件锁
- 使用不同版本的且全局已安装的库
- 使用相同的PID文件
- 第二个程序修改第一个程序正在使用的环境变量，导致第一个程序中断

docker通过linux的命名空间、根文件系统和虚拟网络组件等工具解决这些冲突，为容器提供隔离

---
## 消除元数据冲突   使用dockerId和名称生成功能解决容器的命名问题
![image.png](https://upload-images.jianshu.io/upload_images/5977684-4cd424a66e5904bc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

1. 获取容器id (写入shell变量)   
   - CID=$(docker create nginx:latest)
   - echo $CID
2. 获取容器id (写入文件)
   - docker create --cidfile /tmp/web.cid nginx
   - cat /tmp/web.cid 


---
## 容器的状态和依赖

- sh 创建容器的脚本
```
MAILER_CID=$(docker run -d dockerinaction/ch2_mailer)
WEB_CID=$(docker create nginx)
AGENT_CID=$(docker create --link $WEB_CID:insideweb --link $MAILER_CID:insidemailer dockerinaction/ch2_agent)
```
- docker start $AGENT_CID
- docker start $WEB_CID

### docker容器的状态转移图

![image.png](https://upload-images.jianshu.io/upload_images/5977684-8aa9eaf13ad8fa46.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 正在运行
- 暂停
- 重新启动
- 退出

### --link 将ip地址注入所依赖的容器，在运行的容器中得到该IP地址

---
## 构建与环境无关的系统

- 只读文件系统
- 环境变量注入
- 存储卷

### 只读文件系统    --read-only
> docker run -d --name wp --read-only wordpress:4

检查容器是否子运行,显示docker为该容器保留的所有元数据
> docker inspect --format "{{.State.Running}}" wp

docker安装mysql
> docker run -d --name wpdb -e MYSQL_ROOT_PASSWORD=ch2demo mysql:5

创建新的wordpress容器并链接到mysql上
> docker run -d --name wp2 --link wpdb:mysql -p 80 --read-only wordpress:4

为可写空间创建指定的卷
> docker run -d --name wp3 --link wpdb:mysql -p 80 -v /run/lock/apache2/ -v /run/apache2/ --read-only wordpress:4

### 环境变量的注入  --env   (-e)




---
## 使用存储卷存储日志数据




























