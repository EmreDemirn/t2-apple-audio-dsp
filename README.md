## Testing Arch Linux userspace audio configuration on  MacBook Pro 13 2020 T2.

Thanks to chadmed, lemmyg and Arch Linux.

The project has been adjusted to test Arch Linux audio workflow on a MacBook Pro 16 2020 with T2 audio driver.

New FIRs were created measuring the MacBook Pro 16 with UMIK-1 mic and manually created FIRs of EQ filters using REW.
used 2019 MBP FIRs

## Installation instructions

First follow [t2-audio](https://wiki.t2linux.org/guides/audio-config) instructions and install pipewire.


### 1 - Arch Linux

Install the following dependecies:

```sh
sudo pacman -Syu
sudo pacman -S pipewire pipewire-audio pipewire-pulse pipewire-jack libpipewirev
sudo pacman -S wireplumber lsp-plugins swh-plugins
```

Clone the git branch and install the FIRs config:

```sh
git clone -b speakers_162 https://github.com/EmreDemirn/t2-apple-audio-dsp.git
cd t2-apple-audio-dsp
bash install.sh
```

### 2

To restart pipewire:

```sh
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### 3

Reboot and open the audio settings.
"Apple Audio Driver Speakers" should be at 100% and "MacBook Pro T2 DSP Speakers (4-CH Rev.)" selected as main volumen control. Usually at 75% max.
Do not select "Apple Audio Driver Speakers" directly as the audio will be send directly to the speakers without any adjustment.

## Uninstall

### Arch Linux

```sh
bash uninstall.sh
```


### Disclaimer
This project has been create to share the settings with [T2 kernel team](https://wiki.t2linux.org/). Note that the project is still under working in progress and may not be safe for general usage. Misconfigured settings in userspace could damage speakers permanently.

Dont expect performance as macOS this just increases the speaker quality just a little 

Thanks
