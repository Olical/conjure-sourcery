FROM cimg/base:2020.01

RUN mkdir -p ~/bin
RUN curl -L https://github.com/neovim/neovim/releases/download/v0.4.3/nvim.appimage -o nvim.appimage
RUN chmod +x ./nvim.appimage
RUN ./nvim.appimage --appimage-extract
RUN ln -s ~/project/squashfs-root/usr/bin/nvim ~/bin/nvim 
