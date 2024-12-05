# install valac gtk-doc-tools

# shell_tag="v0.9.0"
# git clone -b $shell_tag https://github.com/wmww/gtk-layer-shell.git
# cd gtk-layer-shell
# meson setup -Dexamples=true -Ddocs=true -Dtests=true build
# ninja -C build
# sudo ninja -C build install
# sudo ldconfig
# cd ..
# rm -fr gtk-layer-shell

nwg_look_tag="v0.3.22"
git clone -b $nwg_look_tag https://github.com/nwg-piotr/nwg-displays.git
cd nwg-displays
sudo ./install.sh
cd ..
sudo rm -fr nwg-displays
