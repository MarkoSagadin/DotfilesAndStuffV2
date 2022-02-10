#Switch keys for english layout

Switch z and y in file

/usr/share/X11/xkb/symbols/us

and reload
setxkbmap -layout us

# Below works on omen
GRUB_CMDLINE_LINUX_DEFAULT="quiet nvidia-drm.modeset=1 acpi_osi='Windows 2020' acpi_backlight=vendor udev.log_priority=3 loglevel=3 amd_iommu=off"
