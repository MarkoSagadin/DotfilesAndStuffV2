str="SSID              SECURITY   BARS  IN-USE
A1_303A           WPA2       ▂▄▆_
dlink             WPA1 WPA2  ▂▄▆_  *
HUAWEI-e88C       WPA1 WPA2  ▂▄▆_
Andonovi          WPA2       ▂▄▆_
Blizoo            WPA1 WPA2  ▂▄▆_
A1-8D5F           WPA2       ▂▄__
Julian            WPA2       ▂▄__
HUAWEI-e88C       WPA1 WPA2  ▂▄__
VIVACOM_FiberNetasdasdasdads  WPA2       ▂▄__
c6a09ddc          WPA2       ▂▄__
TP_LINK_C7C6E2    WPA1 WPA2  ▂___
A1_A59C40         WPA1 WPA2  ▂___
TP-LINK_C7C6E2    WPA1 WPA2  ▂___
C-Net Service     WPA1 WPA2  ▂___"

echo "$str" |
	sed '/^--/d' |
	sed 1d |
	sed -E "s/WPA*.?\S/~~/g" |
	sed "s/~~ ~~/~~/g;s/802\.1X//g;s/--/~~/g;s/  *~/~/g;s/~  */~/g;s/_/ /g" |
	sed -E "s/(.*)/~\1/g" |
	sed "s/▂▄▆█/󰤨/g" |
	sed "s/▂▄▆ /󰤥/g" |
	sed "s/▂▄  /󰤢/g" |
	sed "s/▂   /󰤟/g" |
	sed -E "s/(.*)\*/ 󰁔\1/g" |
	sed "s/[ \t]*$//" |
	column -t -s '~'
