import json

STATE_FILE = "state_file.tfstate"

def parse_ips(state_file):
    with open(state_file, "r") as file:
        state = json.load(file)

    outputs = state.get("outputs", {})
    aws_ips = outputs.get("aws_public_ips", {}).get("value", [])
    azure_ips = outputs.get("azure_vm_public_ips", {}).get("value", [])

    # Create dynamic inventory
    inventory = {
        "all": {
            "hosts": {},
            "vars": {}
        }
    }

    # Add AWS hosts with 'ubuntu' as ansible_user
    for idx, ip in enumerate(aws_ips, start=1):
        inventory["all"]["hosts"][f"aws_host_{idx}"] = {
            "ansible_host": ip,
            "ansible_user": "ubuntu"
        }

    # Add Azure hosts with 'adminuser' as ansible_user
    for idx, ip in enumerate(azure_ips, start=1):
        inventory["all"]["hosts"][f"azure_host_{idx}"] = {
            "ansible_host": ip,
            "ansible_user": "adminuser"
        }

    return inventory

if __name__ == "__main__":
    inventory = parse_ips(STATE_FILE)
    inventory_file = "dynamic_inventory.json"
    with open(inventory_file, "w") as file:
        json.dump(inventory, file, indent=4)
    print(f"Inventory written to {inventory_file}")
