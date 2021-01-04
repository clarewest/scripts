#!/usr/bin/env python
import argparse
import sys
import json

# import relevant library
PY3 = sys.version > '3'

if PY3:
    import urllib.request as urllib2
else:
    import urllib2

# choose required data
SERVER_URL = "https://www.ebi.ac.uk/pdbe/api/"

STRUCDOM = "/structural_domains"
SCOP = "mappings/scop"

# connect to server and request file 
def make_request(url, data):
    request = urllib2.Request(url)

    try:
        url_file = urllib2.urlopen(request, data)
    except urllib2.HTTPError as e:
        if e.code == 404:
            with open("class_error.log","w") as log:
                log.write("[NOTFOUND %d] %s\n" % (e.code, url))
        else:
            with open("class_error.log","w") as log:
                log.write("[ERROR %d] %s\n" % (e.code, url))

        return None

    return url_file.read().decode()

def get_request(url, arg, pretty=False):
    full_url = "%s/%s/%s?pretty=%s" % (SERVER_URL, url, arg, str(pretty).lower())

    return make_request(full_url, None)

if __name__ == '__main__':

    pdb=sys.argv[1]
    chain=sys.argv[2]
    full_pdb="%s_%s" % (pdb,chain)
    full_pdb=full_pdb.upper()
    response = get_request(SCOP, sys.argv[1])

    if response:
        entry = json.loads(response)
        for key in entry[pdb]['SCOP'].keys():
            if any(map['chain_id']==chain for map in entry[pdb]['SCOP'][key]['mappings']):
                scop_class=entry[pdb]['SCOP'][key]['sccs']
                with open(full_pdb+'.sccs','w') as f:
                    f.write("%s %s\n" % (full_pdb,scop_class))


