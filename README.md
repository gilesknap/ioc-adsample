# ADSimDetector Generic IOC for epics-containers

Creates a generic IOC for ADSimDetector using GitHub Actions and
IOC Builder for EPICS and Kubernetes (ibek).

The Generic IOC built by CI is published to
[Github Packages](https://github.com/orgs/epics-containers/packages?repo_name=ioc-adsimdetector).

## How to test this container

1. `git clone git@github.com:epics-containers/ioc-adsimdetector.git`
2. `git submodule update --init --recursive`
3. open the folder in vscode
4. reopen in container
5. optional - view log to see the build progress
6. open a terminal and perform the following inside the container

   - (TODO it would be nice to have a single ibek wrapper command for these
     or maybe add them in as part of the 'ioc build' wrapper)
   - `ibek ioc build`
   - `ibek dev instance /epics/ioc-adsimdetector/ioc_examples/bl01t-ea-ioc-02`
   - `cd /epics/ioc`
   - `./start`
   - `python -m  http.server 8000 --directory /epics/opi`

7. `phoebus.sh -resource 'http://localhost:8000/index.bob'`

## Related projects

- [ibek](https://github.com/epics-containers/ibek) builds generic IOCs and
IOC instances.
- [ibek-support](https://github.com/epics-containers/ibek-support) tells ibek
how each EPICS support module is built.
- [epics containers documentation](https://epics-containers.github.io/)
explanations and tutorials for epics-containers.
- [epics-base](https://github.com/epics-containers/epics-base) the EPICS base
container image upon which all Generic IOCs are built.
- [epics-containers-cli](https://github.com/epics-containers-cli) a command
  line tool to assist with building and deploying epics-containers into
  Kubernetes.
