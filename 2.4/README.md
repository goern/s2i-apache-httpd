# Apache httpd Docker image

This repository contains the source for building various versions of
Apache httpd as a reproducible Docker image using
[source-to-image](https://github.com/openshift/source-to-image).
Users can choose between RHEL and CentOS based builder images.
The resulting image can be run using [Docker](http://docker.io).


## Usage

To build a simple [apache-httpd-test-app](https://github.com/goern/s2i-apache-httpd/tree/master/2.4/test/test-app) application
using standalone [S2I](https://github.com/openshift/source-to-image) and then run the
resulting image with [Docker](http://docker.io) execute:

*  **For RHEL based image**
    ```
    $ s2i build https://github.com/goern/s2i-apache-httpd.git --context-dir=2.4/test/test-app goern/s2i-apache-httpd-24-rhel7 httpd-test-app
    $ docker run -p 8080:8080 httpd-test-app
    ```

*  **For CentOS based image**
    ```
    $ s2i https://github.com/goern/s2i-apache-httpd.git --context-dir=2.4/test/test-app goern/s2i-apache-httpd-24-centos7 httpd-test-app
    $ docker run -p 8080:8080 httpd-test-app
    ```

**Accessing the application:**
```
$ curl 127.0.0.1:8080
```


Repository organization
------------------------
* **`<httpd-version>`**

    * **Dockerfile**

        CentOS based Dockerfile.

    * **Dockerfile.rhel7**

        RHEL based Dockerfile. In order to perform build or test actions on this
        Dockerfile you need to run the action on properly subscribed RHEL machine.

    * **`s2i/bin/`**

        This folder contains scripts that are run by [S2I](https://github.com/openshift/source-to-image):

        *   **assemble**

            Used to install the sources into the location where the application
            will be run and prepare the application for deployment (eg. installing
            modules using npm, etc..)

        *   **run**

            This script is responsible for running the application, by using the
            application web server.

    * **`contrib/`**

        This folder contains a file with commonly used modules.

    * **`test/`**

        This folder contains the [S2I](https://github.com/openshift/source-to-image)
        test framework with a sample PHP app.

        * **`test-app/`**

            A simple PHP app used for testing purposes by the [S2I](https://github.com/openshift/source-to-image) test framework.

        * **run**

            Script that runs the [S2I](https://github.com/openshift/source-to-image) test framework.


## Environment variables

To set these environment variables, you can place them as a key value pair into a `.sti/environment`
file inside your source code repository.

You can override the Apache [MPM prefork](https://httpd.apache.org/docs/2.4/mod/mpm_common.html)
settings. In case you set the Cgroup limits in Docker, the image will attempt to automatically set the
optimal values. You can override this at any time by specifying the values
yourself:

* **HTTPD_START_SERVERS**
  * The [StartServers](https://httpd.apache.org/docs/2.4/mod/mpm_common.html#startservers)
    directive sets the number of child server processes created on startup.
  * Default: 8
* **HTTPD_MAX_REQUEST_WORKERS**
  * The [MaxRequestWorkers](https://httpd.apache.org/docs/2.4/mod/mpm_common.html#maxrequestworkers)
    directive sets the limit on the number of simultaneous requests that will be served.
  * `MaxRequestWorkers` was called `MaxClients` before version httpd 2.3.13.
  * Default: 256 (this is automatically tuned by setting Cgroup limits for the container using this formula:
    `TOTAL_MEMORY / 15MB`. The 15MB is average size of a single httpd process.

  You can use a custom composer repository mirror URL to download packages instead of the default 'packagist.org':

    * **COMPOSER_MIRROR**
      * Adds a custom composer repository mirror URL to composer configuration. Note: This only affects packages listed in composer.json.

## Source repository layout

* **.htaccess**

  In case the **DocumentRoot** of the application is nested within the source directory `/opt/app-root/src`,
  users can provide their own Apache **.htaccess** file.  This allows the overriding of Apache's behavior and
  specifies how application requests should be handled. The **.htaccess** file needs to be located at the root
  of the application source.
