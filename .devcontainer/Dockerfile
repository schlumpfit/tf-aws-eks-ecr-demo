FROM ubuntu:22.04

# Create a vscode user to avoid running as root.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Versions
ARG PYTHON_VERSION=3.10
ARG AWSCLI_VERSION=
ARG TERRAFORM_VERSION=
ARG KUBECTL_VERSION=
ARG STARSHIP_VERSION=

ENV LOCAL_BIN /home/$USERNAME/.local/bin
ENV LOCAL_SHARE /home/$USERNAME/.local/share
ENV PYENV_ROOT $LOCAL_BIN/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
ENV PATH $LOCAL_BIN:$PATH

# Trade some layers for faster adoptions
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && mkdir -p $LOCAL_BIN \
    && mkdir -p $LOCAL_SHARE \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/

# Docker from docker
RUN apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    && curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | sudo apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable" \
    && apt-get update \
    && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    && usermod -aG docker $USERNAME \
    && ln -s "/var/run/docker-host.sock" "/var/run/docker.sock"

# Python build dependencies
RUN apt-get install -y \
    build-essential \
    llvm \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libffi-dev

# Common packages
RUN apt-get install -y \
    curl \
    git \
    unzip \
    tar \
    vim \
    tmux \
    zsh

USER $USERNAME
WORKDIR /home/$USERNAME

# starship-rs for zsh
RUN set -ex \
    && mkdir -p $LOCAL_SHARE/fonts \
    && curl -SL "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/CodeNewRoman/Regular/complete/Code%20New%20Roman%20Nerd%20Font%20Complete%20Mono.otf" \
    -o $LOCAL_SHARE/fonts/Code-New-Roman-Nerd-Font-Complete-Mono.otf \
    && echo "eval \"\$(starship init zsh)\"" >> /home/$USERNAME/.zshrc \
    && curl -SLO https://github.com/starship/starship/releases/download/v1.13.1/starship-x86_64-unknown-linux-gnu.tar.gz \
    && tar -zxf ./starship-x86_64-unknown-linux-gnu.tar.gz --directory $LOCAL_BIN/ \
    && chmod +x $LOCAL_BIN/starship

# Python Pyenv
RUN set -ex \
    && curl https://pyenv.run | bash \
    && pyenv update \
    && pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION \
    && pyenv rehash

# Python Poetry
RUN curl -sSL "https://install.python-poetry.org" | python3 -

# AWS cli
RUN set -ex \
    && curl -SL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install

# Terraform cli
RUN set -ex \
    && curl -SL "https://releases.hashicorp.com/terraform/1.4.0/terraform_1.4.0_linux_amd64.zip" -o "terraform.zip" \
    && unzip terraform.zip \
    && ls -la \
    && chmod +x ./terraform \
    && mv ./terraform $LOCAL_BIN/terraform

# Kubectl cli
RUN set -ex \
    && curl -SL "https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl" -o "kubectl" \
    && chmod +x kubectl \
    && mv ./kubectl $LOCAL_BIN/kubectl
