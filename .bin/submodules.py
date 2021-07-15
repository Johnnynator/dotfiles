#!/usr/bin/env python3
import git
import argparse

def basename (arg):
	pos = arg.rfind("/")
	if pos > -1:
		arg = arg[pos+1:]
	pos = arg.rfind(".")
	if pos > -1:
		arg = arg[:pos]
	return arg

def getUrls (repo):
	for submodule in repo.submodules:
		if submodule.url.startswith("https://github.com"):
			url = submodule.url
			if url.endswith(".git"):
				url=url[:-4]
			print(url + "/archive/${_" + basename(submodule.path).replace('-', '_') + "_commit}.tar.gz")
		elif submodule.url.startswith("https://chromium.googlesource.com"):
			# https://chromium.googlesource.com/webm/libvpx/+archive/3a38edea2cd114d53914cab017cab2e43a600031.tar.gz
			print(submodule.url + "/+archive/${_" + basename(submodule.path).replace('-', '_') + "_commit}.tar.gz")
		elif submodule.module().remote().url.startswith("https://invent.kde.org"):
				url = submodule.module().remote().url
				if url.endswith(".git"):
						url=url[:-4]
				name=basename(submodule.path).replace('-', '_')
				print(f"{url}/-/archive/${{_{name}_commit}}/{name}-${{_{name}_commit}}.tar.gz")
		else:
            print(f"Suburl: {submodule.url}")
            print(f"Remurl: {submodule.module().remote().url}")
			print("Unknown URL, don't know how to rewrite")
			exit(1)

def getCommits (repo):
	for submodule in repo.submodules:
		print("_" + basename(submodule.path).replace('-', '_') + "_commit=" + submodule.hexsha)

def constructPostExtract (repo):
	print("post_extract() {")
	for sub in repo.submodules:
		print("\trmdir -v ${wrksrc}/" + sub.path)
		print("\tmv ${wrksrc}/../" + basename(sub.url) + "-${_" + basename(sub.path).replace('-', '_') + "_commit} ${wrksrc}/" + sub.path)
	print("}")

parser = argparse.ArgumentParser(description='Print some git submodule infos')
parser.add_argument('path', nargs=1, help='path to a git repo')
parser.add_argument('-p', '--print-post-extract', dest='post_extract', action='store_const', const=True, default=False, help='print post_extract function for template')
parser.add_argument('--no-urls', dest='print_urls', action='store_const', const=False, default=True, help='print no distfile urls')
args = parser.parse_args()

repo = git.Repo(args.path[0])
conf = repo.config_reader()
if(args.post_extract):
	constructPostExtract(repo)
else:
	getCommits(repo)
	if(args.print_urls):
		getUrls(repo)
