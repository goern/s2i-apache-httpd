# Include common Makefile code.
BASE_IMAGE_NAME = s2i-apache-httpd
ONBUILD_IMAGE_NAME = apache-httpd
VERSIONS = 2.4
NAMESPACE = goern
SKIP_SQUASH = 1

# Include common Makefile code.
include hack/common.mk
