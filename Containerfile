FROM ghcr.io/ublue-os/silverblue-main:latest

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:stable
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

## Add System76(io) DKMS

COPY --from=ghcr.io/ublue-os/akmods-extra:main-41 /rpms/ /tmp/rpms
RUN find /tmp/rpms
RUN rpm-ostree install /tmp/rpms/kmods/kmod-system76*.rpm
RUN rpm-ostree install /tmp/rpms/kmods/kmod-system76-io*.rpm

## Add NVIDIA

COPY --from=ghcr.io/ublue-os/akmods-nvidia:TAG /rpms/ /tmp/rpms
RUN find /tmp/rpms
RUN rpm-ostree install /tmp/rpms/ublue-os/ublue-os-nvidia*.rpm
RUN rpm-ostree install /tmp/rpms/kmods/kmod-nvidia*.rpm

COPY build.sh /tmp/build.sh

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    ostree container commit
    
