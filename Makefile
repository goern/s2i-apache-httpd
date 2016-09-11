# Include common Makefile code.
BASE_IMAGE_NAME = s2i-apache-httpd
ONBUILD_IMAGE_NAME = apache-httpd
VERSIONS = 2.4
OPENSHIFT_NAMESPACES = 2.4
SKIP_SQUASH = 1
TAG_ON_SUCCESS = true

# Include common Makefile code.
include hack/common.mk
