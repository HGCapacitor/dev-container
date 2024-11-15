FROM ubuntu:latest
RUN apt update && apt install -y openssh-server sudo
RUN apt install -y dpkg lsb-release wget git

#Setup the ssh-agent socket for non root users
RUN echo 'SSH_AUTH_SOCK=/ssh-agent' >> /etc/environment

#Setup the devuser
RUN useradd -rm -d /home/devuser -s /bin/bash -g root -G sudo -u 1000 devuser 
RUN echo 'devuser:devuser' | chpasswd
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

#Setup docker cli (using host docker engine through /var/run/docker.sock)
RUN mkdir -p /opt/scrall
COPY resources/scrall /opt/scrall
RUN /opt/scrall/scripts.d/docker.sh -i cli
#RUN groupadd -g $(stat -c %g /var/run/docker.sock) docker
RUN groupadd -g 999 docker
RUN usermod -a -G docker devuser

#Setup dotnet-sdk
RUN echo "Package: *" >> /etc/apt/preferences
RUN echo "Pin: origin \"packages.microsoft.com\"" >> /etc/apt/preferences
RUN echo "Pin-Priority: 1001" >> /etc/apt/preferences
RUN wget https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
RUN apt update && apt install -y dotnet-sdk-7.0

#Import selfsigned certificate for HTTPS support in dotnet
COPY resources/dotnet-devcert.pfx /home/devuser/.aspnet/https/
RUN chown -R devuser:root /home/devuser/.aspnet
RUN dotnet dev-certs https --clean --import /home/devuser/.aspnet/https/dotnet-devcert.pfx -p ""

#Setup the ssh service
RUN service ssh start
EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]
