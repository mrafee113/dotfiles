#!/usr/bin/env python

import os
import sys
import shutil

import yaml

backup_dir = "/home/francis/Bedroom/Backups/dotfiles-2024-08-14"
if not os.path.isdir(backup_dir):
	os.mkdir(backup_dir)


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

	target = os.path.join(backup_dir, branch_name)
	if os.path.isdir(target):
		shutil.rmtree(target)
	if not os.path.isdir(target):
		os.mkdir(target)

	for file in data:
		if os.path.islink(file):
			continue

		dst = os.path.join(target, file.replace("home/francis/", "")[1:])
		print(dst)
		os.makedirs(os.path.dirname(dst), exist_ok=True)
		if os.path.isfile(file):
			shutil.copy2(file, dst)
		elif os.path.isdir(file):
			shutil.copytree(file, dst)
		else:
			print("wtf??")


if __name__ == "__main__":
	main()
