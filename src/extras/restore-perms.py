#!/usr/bin/env python

import os

import yaml

dotfiles_base_dir = "/home/francis/Studio/Dotfiles"
perms_file = "/home/francis/Studio/Dotfiles/data/private/perms.yaml"


def main():
	with open(perms_file) as file:
		data = yaml.safe_load(file)

	for src, value in data.items():
		src = os.path.join(dotfiles_base_dir, perms_file)

		uid, gid = value["uid"], value["gid"]
		# os.chown(src, uid, gid)
		print(f"os.chown({src}, {uid}, {gid})")

		mode = int(value["mode"], base=8)
		# os.chmod(src, mode)
		print(f"os.chmod({src}, {mode})")


if __name__ == "__main__":
	if os.geteuid() != 0:
		print(
			"You need to have root privileges to run this script.\nPlease try again using sudo."
		)
		exit(1)
	main()
