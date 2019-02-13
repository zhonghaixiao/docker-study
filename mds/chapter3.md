# chapter3

### 安装docker镜像
- docker hub
- docker save , docker load
- Dockerfiles

### 仓库名称 = 主机 + 用户帐号 + 名称
[registeryhost/][username/]name[:tag]

> quay.io/dockerinaction/ch3_hello_registry

### docker login, logout

### docker pull

### docker load -i myfile.tar 加载镜像

### docker build -t [仓库地址] dockerfile  从dockerfile构建镜像

### docker images -a 显示所有镜像

### docker rmi 删除镜像

---

# 持久化存储和卷间状态共享

## 存储卷   持久化和共享数据
存储卷是容器目录树上的挂载点，可以映射目录到主机的存储上

### 创建存储卷容器
> docker run -d --volume /var/lib/cassandra/data --name cass-shared alpine echo Data Container

继承存储卷的定义
> docker run -d --volumes-from cass-shared --name cass1 cassandra:2.2

运行cassandra客户端
> docker run -it --rm --link cass1:cass cassandra:2.2 cqlsh cass

操作
> select * from system.schema_keyspaces where keyspace_name='docker_hello_world'

> create keyspace docker_hello_world width replication = {
>   "class":"simpleStrategy",
>   "replication_factor": 1
> }

## 存储卷的类型
1. 绑定挂载存储卷
2. 管理存储卷

1. 创建http服务器，绑定目录到容器的文档根目录中
> docker run -d --name bmweb -v ~/example-docs:/use/local/apache2/htdocks -p 80:80 httpd:latest

2. 创建管理卷       解耦存储卷
> docker run -d -v /var/lib/cassandra/data --name cass-shared alpine echo Data Container

3. 共享存储卷
> --volumes-from

> docker run --name fowler -v ~/example-books:/library/PoEAA -v /library/DSL alpine:latest echo ""

> docker run --name knuth -v /library/TAoCP.vol1 -v /library/TAoCP.vol2 -v /library/TAoCP.vol3 -v /library/TAoCP.vol4 alpine:latest ehco ""

> docker run --name reader --volumes-from fowler --volumes-from knuth alpine:latest ls -l /library/

## 卷的生命周期

### 删除卷及容器
> docker rm -v student

### 删除所有停止的容器和卷
> docker rm -v $(docker ps -aq)

## 存储卷的高级容器模式


example:(使用数据压缩卷容器，在每个阶段提供特定于环境的配置，然后应用程序将在某个已知的位置查找其配置)

1. docker run --name devConfig -v /config dockerinaction/ch4_packed_config:latest /bin/sh -c 'cp /development/* /config/'
2. docker run --name prodConfig -v /config dockerinaction/ch4_packed_config:latest /bin/sh -c 'cp /production/* /config/'
3. docker run --name devApp --volumes-from devConfig /dockerinaction/ch4_polyapp
4. docker run --name prodApp  --volumes-from prodConfig dockerinaction/ch4_polyapp



























































