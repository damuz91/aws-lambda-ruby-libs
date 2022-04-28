.PHONY:	help build deploy
help:
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'
run:
	docker run --rm -it -v $$PWD:/var/task -w /var/task lambda-ruby-27
all: # Build and deploy from scratch
	make build
	make deploy
build: Dockerfile # Build the docker container, for coding
	docker build -t lambda-ruby-27 .
	docker run --rm -it -v $$PWD:/var/task -w /var/task lambda-ruby-27 make _install
_install: # Install the dependencies
	mkdir -p /var/task/lib
	cp -a /usr/lib64/libpq.so.5.5 /var/task/lib/libpq.so.5
	cp -a /usr/lib64/libldap_r-2.4.so.2.10.7 /var/task/lib/libldap_r-2.4.so.2
	cp -a /usr/lib64/liblber-2.4.so.2.10.7 /var/task/lib/liblber-2.4.so.2
	cp -a /usr/lib64/libsasl2.so.3.0.0 /var/task/lib/libsasl2.so.3
	cp -a /usr/lib64/libssl3.so /var/task/lib/
	cp -a /usr/lib64/libsmime3.so /var/task/lib/
	cp -a /usr/lib64/libnss3.so /var/task/lib/
	cp -a /usr/lib64/libnssutil3.so /var/task/lib/
	cp -a /usr/lib64/libcurl.so /var/task/lib/
	cp -a /usr/lib64/libcurl.so.4 /var/task/lib/
	cp -a /usr/lib64/libcurl.so.4.7.0 /var/task/lib/
	cp -a /usr/lib64/libnghttp2.so.14.20.0 /var/task/lib/libnghttp2.so.14
	cp -a /usr/lib64/libidn2.so.0.3.7 /var/task/lib/libidn2.so.0
	cp -a /usr/lib64/libssh2.so.1.0.1 /var/task/lib/libssh2.so.1
	cp -a /usr/lib64/libldap-2.4.so.2.10.7 /var/task/lib/libldap-2.4.so.2	
	cp -a /usr/lib64/libldap_r-2.4.so.2.10.7 /var/task/lib/libldap_r-2.4.so.2
	cp -a /usr/lib64/libunistring.so.0.1.2 /var/task/lib/libunistring.so.0
	exit
deploy:
	zip -q -r lib.zip lib;
	aws s3api create-bucket --bucket $(bucket) --region us-east-1
	aws s3 cp lib.zip s3://$(bucket)/lib.zip
	aws lambda publish-layer-version --layer-name ruby-libs --region us-east-1 --content S3Bucket=$(bucket),S3Key=lib.zip --compatible-runtimes ruby2.7 --compatible-architectures "arm64" "x86_64" --no-cli-pager
	rm -f lib.zip
	rm -rf lib
	echo "Remember to update your lambda function with the new layer version!!!"