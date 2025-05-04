import json
import subprocess
import os

INVENTORY_FILE = "dynamic_inventory.json"
KNOWN_HOSTS_FILE = "/home/sairaj/.ssh/known_hosts"

def add_to_known_hosts(inventory_file):
    with open(inventory_file, "r") as file:
        inventory = json.load(file)

    hosts = inventory.get("all", {}).get("hosts", {})
    for host_data in hosts.values():
        ip = host_data.get("ansible_host")
        print(f"Adding {ip} to known_hosts")
        subprocess.run(["ssh-keyscan", "-H", ip], stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True)
        with open(KNOWN_HOSTS_FILE, "a") as known_hosts:
            subprocess.run(["ssh-keyscan", "-H", ip], stdout=known_hosts, stderr=subprocess.PIPE, check=True)

    print("All hosts added to known_hosts successfully.")

if __name__ == "__main__":
    add_to_known_hosts(INVENTORY_FILE)
