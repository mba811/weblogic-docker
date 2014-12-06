WebLogic 12c on Docker
===============
Docker configurations to facilitate installation, configuration, and environment setup for developers.

## Install Oracle Linux 7 Base Docker Image

		$ install-ol7-docker-image.sh

## Choose your WebLogic Distribution
This project hosts two configurations for building Docker images with WebLogic 12c.

### Developer Distribution
For more information on the WebLogic 12c ZIP Developer Distribution, visit [WLS Zip Distribution for Oracle WebLogic Server 12.1.3.0](download.oracle.com/otn/nt/middleware/12c/wls/1213/README.txt).

For more information on how to build, and run this image, check [weblogic12c-developer/README](https://github.com/weblogic-community/weblogic-docker/blob/master/weblogic12c-developer/README.md)

### Generic Full Distribution
Fore more information on the WebLogic 12c Generic Full Distribution, visit [WebLogic 12.1.3 Documentation](http://docs.oracle.com/middleware/1213/wls/index.html).

For more information on how to build, and run this image, check [weblogic12c-generic/README](https://github.com/weblogic-community/weblogic-docker/blob/master/weblogic12c-generic/README.md)

## License
To download and run WebLogic 12c Distribution regardless of inside or outside a Docker container, and regardless of Generic or Developer distribution, you must agree and accept the [OTN Free Developer License Terms](http://www.oracle.com/technetwork/licenses/wls-dev-license-1703567.html).

To download and run Oracle JDK regardless of inside or outside a DOcker container, you must agree and accept the [Oracle Binary Code License Agreement for Java SE](http://www.oracle.com/technetwork/java/javase/terms/license/index.html).

All scripts and files hosted in this project and GitHub [weblogic-docker](https://github.com/weblogic-community/weblogic-docker/) repository required to build the Docker images are, unless otherwise noted, released under the Common Development and Distribution License (CDDL) 1.0 and GNU Public License 2.0 licenses.
