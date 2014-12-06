WebLogic 12c on Docker
===============
Docker configurations to facilitate installation, configuration, and environment setup for developers.

# Install Oracle Linux 7 Base Docker Image
$ install-ol7-docker-image.sh

# Build WLS 12c Generic Image
Download all required packages
(1) Oracle JDK 8u25
(2) Oracle WebLogic 12c 12.1.3 Generic Install

Drop these files inside 'weblogic12c-generic'

Run 'build.sh' as root

# Build WLS 12c Developer Image
Download all required packages
(1) Oracle JDK 8u25
(2) Oracle WebLogic 12c 12.1.3 ZIP Install

Drop these files inside 'weblogic12c-developer'

Run 'build.sh' as root

# Running containers
Inside either 'generic' or 'developer' there are scripts to help run the AdminServer, as well N containers with NodeManager inside, allowing you to create a clustered environment.

- dockWebLogic.sh: starts AdminServer on a newly created container
- dockNodeManager.sh: starts NodeManager on a newly created container

* when you run dockNodeManager, a Machine will be automatically added to the domain running on AdminServer. Run dockWebLogic first!

