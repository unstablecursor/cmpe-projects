import os
import pwd
import sys
import argparse
import hashlib
from pprint import pprint

def file_hasher(filepath):
    return hashlib.sha256(open(filepath, 'rb').read()).hexdigest()

#Just (i) sort the hashes of contents of directory,  (ii) concatenate
#   the sorted hashes and  (iii) take a hash of the
#resulting string.  Do this in bottom-up fashion in the directory hierarchy.
def dir_hasher(filepath):
    dir_content = os.listdir(filepath)
    dir_hash = ""
    for fdir in dir_content:
        if os.path.isdir(filepath + "/" + fdir):
            for hashval, direct in alldirectories.items():
                if direct == (filepath + "/" + fdir):
                    dir_hash = dir_hash + hashval
        else:
            dir_hash = dir_hash + file_hasher(filepath + "/" + fdir)
    return hashlib.sha256(dir_hash.encode('utf-8')).hexdigest()


cwd = os.getcwd()
parser = argparse.ArgumentParser()
actions = parser.add_mutually_exclusive_group()
actions.add_argument(
    '-p', '--print', action='store_const', dest='action', const='p', default='p')
actions.add_argument(
    '-c', '--command', action='store', dest='action', type=str)
types = parser.add_mutually_exclusive_group()
types.add_argument(
    '-f', '--file', action='store_const', dest='type', const='f', default='f')
types.add_argument(
    '-d', '--directory', action='store_const', dest='type', const='d')
parser.add_argument("dirs", type=str,  default=[cwd], nargs='*')
args = parser.parse_args()
dirlist = args.dirs
regex = ""
if dirlist[0][0] == '\"':
    regex = dirlist.pop(0)

allfiles = {}
alldirectories = {}

for fullpath in dirlist:
    for root, dirs, files in os.walk(fullpath, topdown=False):
        for fname in files:
            file_path = root + "/" + fname
            file_hash = file_hasher(file_path)
            if file_hash in allfiles:
                allfiles[file_hash].append(file_path)
            else:
                allfiles[file_hash] = [file_path]
        for dname in dirs:
            dir_path = root + "/" + dname
            dir_hash = dir_hasher(dir_path)
            if dir_hash in alldirectories:
                alldirectories[dir_hash].append(dir_path)
            else:
                alldirectories[dir_hash] = [dir_path]

pprint (alldirectories)
pprint (allfiles)
