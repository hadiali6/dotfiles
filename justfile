all: init_home init_base init_dots install_aur_helper install_cli install_fonts install_gui install_nvidia_drivers install_vm

init_home:
    #!/bin/sh
    cd $HOME
    mkdir -p repos school dev test music desktop documents pictures downloads videos

install_base:
    #!/bin/sh
    sudo pacman -Syu --noconfirm base-devel git cmake meson fastfetch

init_dots:
    #!/bin/sh
    cd $HOME
    mkdir -p repos
    cd repos
    git clone https://github.com/hadiali6/dotfiles
    cd dotfiles
    configs="
    .config/nvim
    .config/tmux
    .config/alacritty
    .config/rofi
    .config/hypr
    .config/waybar
    .bashrc
    .zshrc
    .config/mimeapps.list
    .config/user-dirs.dirs
    "
    for config in $configs; do
        if [ -e "$HOME/$config" ]; then
            echo "$config exists!"
        else
            cp -r "$PWD/$config" "$HOME/$config"
        fi
    done

install_aur_helper:
    #!/bin/sh
    sudo pacman -Syu --noconfirm rustup
    rustup default stable
    cd $HOME
    cd repos
    git clone https://aur.archlinux.org/paru.git
    cd paru
    makepkg -si

install_cli:
    #!/bin/sh
    paru -Syu --noconfirm man-pages man-db neovim tmux tmuxinator zsh fzf lf fd ripgrep eza bat btop ffmpeg tailscaled openssh gdb lldb jq yq wget unzip just mpd mpc ncmpcpp qmk jsregexp scdoc valgrind ly docker
    sudo systemctl enable ly.service

install_fonts:
    #!/bin/sh
    paru -Syu --noconfirm adobe-source-code-pro-fonts noto-fonts noto-fonts-extra noto-fonts-cjk noto-fonts-emoji ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid ttf-ibm-plex ttf-input ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-liberation ttf-mona-sans ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common ttf-roboto

install_gui:
    #!/bin/sh
    paru -Syu --noconfirm hyprland wayland wayland-protocols wlr-protocols plasma-wayland-protocols frog-protocols xorg-server xorg-xrandr wl-clipboard xclip firefox alacritty foot waybar obs code zed emacs feh mpv flameshot grim slurp swww intellij-idea-community-edition qalculate-qt unclutter wlroots wlroots-git webcord-bin awesome-luajit-git picom-git

install_lang:
    #!/bin/sh
    paru -Syu --noconfirm zig clang tcc lua lua51 lua52 lua53 luajit go python uv node deno npm odin sdkman luau

install_nvidia_drivers:
    #!/bin/sh
    paru -Syu --noconfirm nvidia nvidia-settings
    sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3\ quiet\"/GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3\ quiet\ nvidia-drm.modeset=1\"/g" /etc/default/grub
    sudo sed -i "s/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/g" /etc/default/grub

    MODULES_TO_ADD=("nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm")
    MKINITCPIO_CONF="/etc/mkinitcpio.conf"

    if [[ ! -w $MKINITCPIO_CONF ]]; then
        echo "Error: $MKINITCPIO_CONF does not exist or is not writable."
        exit 1
    fi

    cp "$MKINITCPIO_CONF" "$MKINITCPIO_CONF.bak"

    echo "Original $MKINITCPIO_CONF backed up to $MKINITCPIO_CONF.bak"

    MODULES_LINE=$(grep -E '^MODULES=.*' "$MKINITCPIO_CONF")
    if [[ -z $MODULES_LINE ]]; then
        echo "Error: MODULES array not found in $MKINITCPIO_CONF."
        exit 1
    fi

    CURRENT_MODULES=$(echo "$MODULES_LINE" | sed -E 's/^MODULES=\((.*)\)$/\1/')

    UPDATED_MODULES=( $CURRENT_MODULES )

    for MODULE in "${MODULES_TO_ADD[@]}"; do
        if [[ ! " ${UPDATED_MODULES[@]} " =~ " ${MODULE} " ]]; then
            UPDATED_MODULES+=("$MODULE")
        fi
    done

    NEW_MODULES_LINE="MODULES=(${UPDATED_MODULES[*]})"

    sed -i -E "s/^MODULES=.*\$/$NEW_MODULES_LINE/" "$MKINITCPIO_CONF"

    echo "Updated MODULES array in $MKINITCPIO_CONF: $NEW_MODULES_LINE"



install_vm:
    #!/bin/sh
    paru -Syu --noconfirm qemu-full virt-manager virt-viewer vde2 ebtables iptables-nft nftables dnsmasq bridge-utils ovmf swtpm
    cd $HOME/repos/dotfiles
    sudo sed -i "s/#unix_sock_group/unix_sock_group/g" /etc/libvirt/libvirtd.conf
    sudo sed -i "s/#unix_sock_rw_perms/unix_sock_rw_perms/g" /etc/libvirt/libvirtd.conf
    sudo sed -i "s/#user\ =\ \"libvirt-qemu\"/user\ =\ $(whoami)/g" /etc/libvirt/qemu.conf
    sudo sed -i "s/#group\ =\ \"libvirt-qemu\"/group\ =\ $(whoami)/g" /etc/libvirt/qemu.conf
    sudo usermod -a -G kvm,libvirt $(whoami)
    sudo systemctl enable libvirtd
    sudo systemctl start libvirtd
    sudo systemctl restart libvirtd
    sudo virsh net-autostart default
