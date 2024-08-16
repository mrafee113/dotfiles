#!/usr/bin/env python

import os
import sys
import shutil

import yaml

dotfiles_base_dir = "/home/francis/Studio/Dotfiles"
branches = ["home", "root"]


def main():
	if len(sys.argv) <= 1:
		print("provide file name")
		exit(1)

	filename = sys.argv[1]
	with open(filename) as file:
		all_data = yaml.safe_load(file)

	for branch_name in branches:
		if branch_name != "root":
			data = all_data[1]["elink"]
		else:
			data = all_data[2]["sudo"][0]["elink"]

		for src, value in data.items():
			if isinstance(value, dict):
				path = value["path"]
				glob = value.get("glob", False)
			else:
				path = value
				glob = False

			src = src.replace("$HOME", "/home/francis")
			src = os.path.abspath(os.path.expanduser(os.path.expandvars(src)))
			dst = os.path.join(dotfiles_base_dir, path)

			if not os.path.exists(dst):
				print(f"{src} -> {dst}")
				if not os.path.exists(src):
					print("source doesn't exist")
				elif os.path.islink(src):
					print("source is link")
				else:
					print(f"{glob=}")
				print()


if __name__ == "__main__":
	main()
