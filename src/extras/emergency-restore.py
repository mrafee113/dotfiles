#!/usr/bin/env python

import os
import sys
import shutil

import yaml

backup_dir = "/home/francis/Bedroom/Backups/dotfiles-2024-08-14"
if not os.path.isdir(backup_dir):
	print(f"backup dir ({backup_dir}) doesn't exist")
	exit(1)

restore_dir = "/home/francis/Studio/Dotfiles"
if not os.path.isdir(restore_dir):
	print(f"restore dir ({restore_dir}) doesn't exist")
	exit(1)

dotfiles_base_dir = "/home/francis/Studio/Dotfiles"


def main():
	if len(sys.argv) <= 1:
		print("provide file name and branch name")
		exit(1)

	if len(sys.argv) <= 2:
		print("provide branch name")
		exit(1)

	filename = sys.argv[1]
	branch_name = sys.argv[2]
	with open(filename) as file:
		data = yaml.safe_load(file)

	source = os.path.join(backup_dir, branch_name)
	if not os.path.isdir(source):
		print(f"source dir ({source}) doesn't exist")
		exit(1)

	if branch_name != "root":
		data = data[1]["elink"]
	else:
		data = data[2]["sudo"][0]["elink"]

	for src, value in data.items():
		if isinstance(value, dict):
			path = value["path"]
			glob = value.get("glob", False)
			submodule = value.get("submodule", False)
			exclude = value.get("exclude", False)
		else:
			path = value
			glob = submodule = exclude = False

		src = os.path.abspath(os.path.expanduser(os.path.expandvars(src)))

		if (
			os.path.islink(src)
			or glob is not False
			or submodule is not False
			or exclude is not False
		):
			continue

		dst = os.path.join(dotfiles_base_dir, path)
		print(dst)
		os.makedirs(os.path.dirname(dst), exist_ok=True)
		if os.path.isfile(src):
			shutil.copy2(src, dst)
		elif os.path.isdir(src):
			shutil.copytree(src, dst)
		else:
			print("wtf??")


if __name__ == "__main__":
	main()
