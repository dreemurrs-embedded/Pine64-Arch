#!/usr/bin/python3

import dbus
import sys

bus = dbus.SystemBus()

manager = dbus.Interface(bus.get_object('org.ofono', '/'),
					'org.ofono.Manager')
modems = manager.GetModems()
path = modems[0][0]
action = sys.argv[1]

if action == "pre":
    enable = 1
else:
    enable = 0

print("Setting fast dormancy for modem %s..." % path)
radiosettings = dbus.Interface(bus.get_object('org.ofono', path),
						'org.ofono.RadioSettings')

radiosettings.SetProperty("FastDormancy", dbus.Boolean(enable));
