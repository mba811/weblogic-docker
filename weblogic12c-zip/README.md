# Oracle WebLogic Docker image

This is a Dockerfile for [Oracle WebLogic 12c](http://www.oracle.com/technetwork/middleware/weblogic/overview/index.html). The purpose of this Docker container is to facilitate the setup of development and integration testing environments for developers.

**IMPORTANT**: Oracle **does not support Docker** in any environment, including but not limited to Development, Integration, and Production environments.

## How to Build

Follow this procedure:

1. Checkout the GitHub weblogic-docker repository

        git checkout git@github.com:weblogic-community/weblogic-docker.git

2. Go to the **weblogic12c-zip** folder

        cd weblogic-docker/weblogic12c-zip

3. [Download](http://www.oracle.com/technetwork/middleware/weblogic/downloads/wls-for-dev-1703574.html) and drop the WebLogic 12c ZIP Distribution file **wls1213_dev.zip** in this folder

4. Execute the build script

        build.sh

## Booting up Oracle WebLogic 12c on Docker

Along with the Dockerfile, two scripts are also provided to help you run either one server (Admin Server) or two or more servers (Node Managers) to allow you to setup a cluster.

 * dockWebLogic.sh
 * dockNodeManager.sh

To boot the WebLogic Admin Server, execute

    dockWebLogic.sh -attach

The argument '-attach' in this script will automatically bind port 7001 to the host. You will then be able to access the Admin Console at http://localhost:7001/console. If you don't use this argument, the script will tell you which IP address this container is running on and present you with the URL to open the Admin Console.

To boot a Node Manager to be able to setup a cluster, execute

    dockNodeManager.sh

This script will automagically start a Node Manager and add itself to the Admin Server as a new Machine. After this, go to the Admin Console and setup a cluster by creating either a regular one, or a Dynamic Cluster.

## Deploying Java EE Applications

You can use the web-based [Administration Console](http://docs.oracle.com/middleware/1213/core/ASADM/getstart.htm#ASADM10025), the [WebLogic Maven Plugin](http://docs.oracle.com/middleware/1213/wls/WLPRG/maven.htm), the [WebLogic Deployer](http://docs.oracle.com/middleware/1213/wls/DEPGD/deploy.htm), or the [WLST](http://docs.oracle.com/middleware/1213/wls/WLSTG/config_wls.htm#i1027344) (WebLogic Scripting Tool) to deploy applications to the remote servers running on Docker containers.

## Dockerfile Source
All source is on the [weblogic-docker GitHub repository](https://github.com/weblogic-community/weblogic-docker).

If you find any issues, please report through the [GitHub Issues page](https://github.com/weblogic-community/weblogic-docker/issues).

## License
To download and run WebLogic 12c ZIP Distribution regardless of inside or outside a Docker container, you must agree and accept the [OTN Free Developer License Terms](http://www.oracle.com/technetwork/licenses/wls-dev-license-1703567.html).

For the scripts and files hosted in the GitHub [weblogic-docker](https://github.com/weblogic-community/weblogic-docker/) repository required to build the Docker image are, unless otherwise noted, released under the Common Development and Distribution License (CDDL) 1.0 and GNU Public License 2.0 licenses.
