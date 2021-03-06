FROM openshift/base-centos7

# This image provides an Apache httpd environment for serving static files

MAINTAINER SoftwareCollections.org <sclorg@redhat.com>

EXPOSE 8080

ENV APACHE_HTTPD_VERSION=2.4 \
    PATH=$PATH:/opt/rh/rh-httpd24/root/usr/bin

LABEL io.k8s.description="Platform for serving static files" \
      io.k8s.display-name="Apache httpd 2.4" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,http,http24,apache,httpd,rhscl-httpd24"

# Install Apache httpd and PHP
RUN yum install -y centos-release-scl && \
    INSTALL_PKGS="httpd24" && \
    yum install -y --setopt=tsflags=nodocs --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
COPY ./s2i/bin/ $STI_SCRIPTS_PATH

# Each language image can have 'contrib' a directory with extra files needed to
# run and build the applications.
COPY ./contrib/ /opt/app-root

# In order to drop the root user, we have to make some directories world
# writeable as OpenShift default security model is to run the container under
# random UID.
RUN sed -i -f /opt/app-root/etc/httpdconf.sed /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf && \
    echo "IncludeOptional /opt/app-root/etc/conf.d/*.conf" >> /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf && \
    head -n151 /opt/rh/httpd24/root/etc/httpd/conf/httpd.conf | tail -n1 | grep "AllowOverride All" || exit && \
    mkdir /tmp/sessions && \
    chown -R 1001:0 /opt/app-root /tmp/sessions && \
    chmod -R a+rwx /tmp/sessions && \
    chmod -R ug+rwx /opt/app-root && \
    chmod -R a+rwx /opt/rh/httpd24/root/var/run/httpd

USER 1001

# Set the default CMD to print the usage of the language image
CMD $STI_SCRIPTS_PATH/usage
