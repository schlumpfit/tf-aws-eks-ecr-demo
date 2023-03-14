FROM ubuntu:22.04

# Create a vscode user to avoid running as root.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID
ARG SHELL=/usr/bin/zsh

# Versions
ARG PYENV_GIT_TAG=v2.3.15
ARG POETRY_VERSION=1.4.0
ARG PYTHON_VERSION=3.10
ARG STARSHIP_VERSION=v1.13.1
ARG FZF_VERSION=0.38.0

ARG AWSCLI_VERSION=2.0.30
ARG TERRAFORM_VERSION=1.4.0
ARG KUBECTL_VERSION=v1.26.0

ENV LOCAL_BIN /home/$USERNAME/.local/bin
ENV LOCAL_SHARE /home/$USERNAME/.local/share
ENV PYENV_ROOT $LOCAL_BIN/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
ENV PATH $LOCAL_BIN:$PATH

# Trade some layers for faster adoptions

# Base Setup
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --assume-yes \
    # Common base
    software-properties-common \
    gnupg2 \
    sudo \
    curl \
    git \
    ssh \
    unzip \
    tar \
    vim \
    tmux \
    zsh \
    # Docker from docker
    apt-transport-https \
    ca-certificates \
    # Python build dependencies
    build-essential \
    llvm \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libffi-dev

# Add user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID --create-home --shell $SHELL $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && mkdir -p $LOCAL_BIN \
    && mkdir -p $LOCAL_SHARE \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/

# Add docker from docker
RUN curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | sudo apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu jammy stable" \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --assume-yes \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin \
    && usermod -aG docker $USERNAME \
    && mkdir -p /home/$USERNAME/.docker \
    && touch /home/$USERNAME/.docker/config.json \
    && chown -R $USER:docker /home/$USERNAME/.docker \
    && ln -s "/var/run/docker-host.sock" "/var/run/docker.sock"

USER $USERNAME
WORKDIR /home/$USERNAME

# Python Pyenv
RUN set -ex \
    && curl https://pyenv.run | PYENV_GIT_TAG=$PYENV_GIT_TAG  bash \
    && pyenv install $PYTHON_VERSION \
    && pyenv global $PYTHON_VERSION \
    && pyenv rehash

# Python Poetry
RUN set -ex \
    && curl -sSL "https://install.python-poetry.org" | POETRY_VERSION=$POETRY_VERSION python3 -

# starship-rs for zsh
RUN set -ex \
    && mkdir -p $LOCAL_SHARE/fonts \
    && curl -SL "https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/CodeNewRoman/Regular/complete/Code%20New%20Roman%20Nerd%20Font%20Complete%20Mono.otf" \
       -o $LOCAL_SHARE/fonts/Code-New-Roman-Nerd-Font-Complete-Mono.otf \
    && echo "eval \"\$(starship init zsh)\"" >> /home/$USERNAME/.zshrc \
    && curl -SLO https://github.com/starship/starship/releases/download/${STARSHIP_VERSION}/starship-x86_64-unknown-linux-gnu.tar.gz \
    && tar -zxf ./starship-x86_64-unknown-linux-gnu.tar.gz --directory $LOCAL_BIN/ \
    && chmod +x $LOCAL_BIN/starship \
    && rm ./starship-x86_64-unknown-linux-gnu.tar.gz

# fzf
RUN set -ex \
    && git clone --depth 1 --branch $FZF_VERSION https://github.com/junegunn/fzf.git /home/$USERNAME/.fzf \
    && /home/$USERNAME/.fzf/install

# AWS cli
RUN set -ex \
    && curl -SL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWSCLI_VERSION}.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && sudo ./aws/install \
    && rm awscliv2.zip

# Terraform cli
RUN set -ex \
    && curl -SL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o "terraform.zip" \
    && unzip terraform.zip \
    && ls -la \
    && chmod +x ./terraform \
    && mv ./terraform $LOCAL_BIN/terraform \
    && rm terraform.zip

# Kubectl cli
RUN set -ex \
    && curl -SL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o "kubectl" \
    && chmod +x kubectl \
    && mv ./kubectl $LOCAL_BIN/kubectl
