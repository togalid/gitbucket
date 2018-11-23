FROM million12/centos-supervisor
MAINTAINER ta.wada

# python repo追加
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm

## yum
RUN yum install -y python36u python36u-pip python36u-devel \
 && yum autoremove -y \
 && yum clean all

## pip install
RUN source ~/.bash_profile \
 && pip3.6 install pytest

# dir
RUN mkdir -p /src
WORKDIR /src

# Run
ENTRYPOINT ["pytest"]
