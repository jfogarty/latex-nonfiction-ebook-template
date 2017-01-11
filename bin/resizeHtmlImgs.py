#!/usr/bin/env python
#make executable in bash chmod +x PyRun
# Rescales all img elements in the html book page to make them look nice.
# htlatex has no good method to rescale all images and scalebox is
# apparently ignored.  Crude, but it works.
import sys, re

source = sys.stdin.read()
def multi(by):
  def handler(m):
    updated = float(m.group(2)) * by
    return m.group(1) + str(updated)
  return handler

print re.sub(r'((?:width|height)=["\'])(\d+\.\d+)', multi(1.9), source)

