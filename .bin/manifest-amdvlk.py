#!/usr/bin/env python3
from xml.dom import minidom
from urllib.request import urlopen
from sys import argv

if __name__ == '__main__':
    if len(argv) > 1:
        tag = argv[1]
    else:
        tag = 'master'
    xmlfile = urlopen("https://raw.githubusercontent.com/GPUOpen-Drivers/AMDVLK/" + tag + "/default.xml")
    itemlist = minidom.parse(xmlfile).getElementsByTagName('project')
    for s in itemlist:
        print("_" + s.attributes['name'].value + "_commit" + "=" + s.attributes['revision'].value)
