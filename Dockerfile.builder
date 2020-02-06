FROM centos:centos7

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo

RUN ACCEPT_EULA=Y yum install -y msodbcsql

RUN yum install -y \
	python3-devel \
	python-setuptools \
	gcc-c++ \
    openssl-devel \
	bash \
    unixODBC-devel \
	wget

RUN wget http://www6.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/atomic-sqlite-sqlite-3.8.5-3.el7.art.x86_64.rpm
RUN yum localinstall -y atomic-sqlite-sqlite-3.8.5-3.el7.art.x86_64.rpm
RUN mv /lib64/libsqlite3.so.0.8.6{,-3.17}
RUN mv /opt/atomic/atomic-sqlite/root/usr/lib64/libsqlite3.so.0.8.6 /lib64

RUN ln -fs /usr/bin/python3 /usr/bin/python

RUN mkdir /code

WORKDIR /code

COPY requirements.txt /code/

RUN python -m pip install --upgrade pip && python -m pip install -r requirements.txt
