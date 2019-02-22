# Kiosk / Dashboard for Raspberry Pi

Configures, using Ansible, a Raspberry Pi with a locked down desktop and browser to point at a single dashboard URL.
Useful for a build monitor or wallboard display.

[![Build Status](https://travis-ci.org/bdellegrazie/rpi-dashboard.svg?branch=master)](https://travis-ci.org/bdellegrazie/rpi-dashboard)

## Features

* Selectable Browser (Chromium, Epiphany, Firefox, Midori)
* Configurable refresh of the browser (every 5 minutes by default)
* Configurable on/off times for the display (default 0700-1800)
* Configurable full screen display size (default 1920x1080)
* Configurable use of DPMS to power down the screen during off hours (default off)
* Systemd logs directed to alternate virtual terminal (VT12) for easy diagnosis
* Optionally disables apt safety measures for faster installs (default off)

## Using with a Raspberry PI

1. Install pipenv (assuming Python 3) and create a python virtual environment in which to run Ansible
2. Run Ansible Galaxy to retrieve the external roles
3. Add an inventory entry for your Raspberry PI (ansible/inventory/hosts)
4. Run Ansible against the Raspberry PI

```
pip3 install pipenv
pipenv install --three
pipenv shell
mkdir ansible/galaxy_roles
ansible-galaxy -r ansible/requirements.yml -p ansible/galaxy_roles install
ansible-playbook -i ansible/inventory ansible/site.yml
```

## Installation Notes

It is easier to setup the Pi on a wired connection.
Wifi is possible but you need to:
1. Manually configure the Wifi
2. Update the inventory to use the correct IP / host as needed
3. Run Ansible as above

## Settings

Modify group\_vars as needed. Each role has its own defaults, the following are common settings:

| *Setting* | *Description* | *Default* |
|---------|-------------|---------|
| `debian_apt_squid_proxy_client` | Install Debian's Squid Proxy Client - used to speed up installs for development | `false` |
| `debian_apt_unsafe_fast` | See _Speeding up Apt_ below | `false` on Pi, `true` on vagrant |
| `wireless_country_code` | Wireless Country Code for channel limits | `GB` |
| `wireless_networks` | Dict, Key is the Access Point Name, value is the PSK, see example below | `{}` |
| `keyboard_layout` | Country layout for keyboard (vagrant only) | `gb` |
| `timesync_pool_zone` | Country code for the NTP pool zone to use | `uk` |
| `timesync_ntp` | NTP servers | 0, 1, 2, 3 of the specific NTP pool zone, disabled on Vagrant |
| `kiosk_url` | URL to use for the Kiosk | `https://www.google.co.uk/` |
| `kiosk_environment` | Dictionary of environment variables set when running the browser, useful for proxy configuration | `{}` |
| `kiosk_browser` | Browser to use, one of chromium, epiphany, firefox or midori | `epiphany` |

Extra settings and their defaults can be seen in `ansible/roles/kiosk/defaults/main.yml`

### Example wireless configuration

```
---
wireless_networks:
  'MyWifi': 'MyPassword'
```

If desired, this value could be encrypted using Ansible Vault

### Speeding up Apt

Apt, the package manager for Raspberry Pi's Raspbian is extremely slow and heavy on I/O due to safety measures to ensure the reliability and recovery of the package database.

If the Pi has no other function than this repo can be used to restore a Pi from nothing so its becomes worth disabling APT's safety checks and simply going as fast
as possible.

The safety measures can be disabled by setting `debian_apt_unsafe_fast: true` in the Pi's group\_vars or host\_vars. They are disabled on vagrant by default


## Contributing / Testing with Vagrant

1. Install Vagrant
2. Install pipenv and create a python virtual environment in which to run Ansible and Vagrant `pipenv install --dev --three`
3. Run `vagrant up`

Not all roles will execute on Vagrant (timesync is skipped)
