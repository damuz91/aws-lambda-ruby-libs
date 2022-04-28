FROM lambci/lambda:build-ruby2.7 
RUN yum install -y postgresql postgresql-devel libcurl-devel
CMD "/bin/bash"