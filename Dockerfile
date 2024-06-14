FROM archlinux:base-devel AS base

WORKDIR /usr/local/bin

RUN sed -i 's/# ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf && \
  pacman -Syyu --noconfirm && \
  pacman -S --noconfirm ansible

FROM base AS diego

RUN useradd -m -G wheel -s /bin/bash diego && \
  sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/g' /etc/sudoers

FROM diego

USER diego

ENV USER=diego

WORKDIR /home/diego

RUN mkdir playbook

COPY --chown=diego . ./playbook

RUN ansible-galaxy install -r ./playbook/requirements.yaml

CMD ["ansible-playbook", "playbook/setup.yaml", "--vault-password-file", "playbook/vaultpass"]
