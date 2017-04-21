import os
import pwd
import sys
import argparse

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
parser.add_argument("pattern", type=str,  default="", nargs='?')
parser.add_argument("dirs", type=str,  default="", nargs='*')
args = parser.parse_args()
print args.action
print args.type
print args.pattern
print args.dirs
