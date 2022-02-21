#Switch keys for english layout
Open /usr/share/X11/xkb/symbols/us
and switch y and z
You can reload with setxkbmap -layout us, but you should really reset the machine.

# Below works on omen
# GRUB_CMDLINE_LINUX_DEFAULT="quiet nvidia-drm.modeset=1 acpi_osi='Windows 2020' acpi_backlight=vendor udev.log_priority=3 loglevel=3 amd_iommu=off"
