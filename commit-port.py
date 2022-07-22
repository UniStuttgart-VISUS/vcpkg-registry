import argparse
import os
import subprocess
import json

def check_ret(val):
    if val > 0:
        print(f"error {val}. stopping")
        exit(0)

def get_version_dir(val):
    return f"versions/{val[0]}-"

def get_version_file_name(val):
    dir = get_version_dir(val)
    return f"{dir}/{val}.json"

parser = argparse.ArgumentParser(
    usage="%(prog)s <name>", description="does the weird commit dance to update a the vcpkg port <name>")
parser.add_argument('name', nargs='+', help='the port name')
parser.add_argument('--skip-temp-commit', action='store_true')
args = parser.parse_args()
PORTNAME = args.name[0]
PORTDIR = f"ports/{PORTNAME}"

print(f"looking at {PORTDIR}:")
check_ret(os.system(f"git add {PORTDIR}"))
if not args.skip_temp_commit:
    check_ret(os.system('git commit -m "temp"'))

output = subprocess.run(["git", "rev-parse", f"HEAD:{PORTDIR}"], capture_output=True)
commit_hash = output.stdout.decode("utf-8").strip()

print(f"got hash: {commit_hash}")

with open(f"{PORTDIR}/vcpkg.json", encoding='utf-8') as portfile:
    port_info = json.load(portfile)
    version = port_info['version']
    port_version = port_info['port-version']
    print(f"got version {version} and port-version {port_version}")

version_file_name = get_version_file_name(PORTNAME)
print(f"looking at version {version_file_name}")

if os.path.isdir(get_version_dir(PORTNAME)):
    version_exists = False
    with open(version_file_name, 'r', encoding='utf-8') as version_file:
        j = json.load(version_file)
        for v in j['versions']:
            if v['version'] == version and v['port-version'] == port_version:
                version_exists = True
                print("version already exists, replacing hash")
                v['git-tree'] = commit_hash

    if not version_exists:
        print("adding version")
        j['versions'].append(
            {"version": version, "port-version": port_version, "git-tree": commit_hash})
else:
    os.makedirs(get_version_dir(PORTNAME), exist_ok=True)
    j = {"versions":[{"version": version, "port-version": port_version, "git-tree": commit_hash}]}

#print(f"new version file: {j}")
with open(version_file_name, 'w', encoding='utf-8') as version_file:
    json.dump(j, version_file, indent=2)

with open("versions/baseline.json", 'r', encoding='utf-8') as baseline_file:
    b = json.load(baseline_file)
    if PORTNAME in b['default']:
        print("updating port in baseline")
        b['default'][PORTNAME]['baseline'] = version
        b['default'][PORTNAME]['port-version'] = port_version
    else:
        print("adding port in baseline")
        b['default'][PORTNAME] = {"baseline": version, "port-version": port_version}

with open("versions/baseline.json", 'w', encoding='utf-8') as baseline_file:
    json.dump(b, baseline_file, indent=2)

check_ret(os.system(f"git add versions"))
check_ret(os.system(f"git commit --amend"))
