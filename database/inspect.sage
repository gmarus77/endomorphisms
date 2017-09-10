"""
 *  Generates endomorphism data from a colon-separated list.
 *
 *  Copyright (C) 2016-2017
 *            Edgar Costa      (edgarcosta@math.dartmouth.edu)
 *            Davide Lombardo  (davide.lombardo@math.u-psud.fr)
 *            Jeroen Sijsling  (jeroen.sijsling@uni-ulm.de)
 *
 *  See LICENSE.txt for license details.
"""

# Inspects endomorphism representations in a list by pretty-printing a dummy
import os, shutil

inputfile = 'gce_genus3_nonhyperelliptic_endos.txt'

# Index of the representations:
index = 2
# A priori boring output:
boring = ["[[-1,1],[[[-1,1],[[['I',[-1,1],1,1]],[1,-1],['RR'],'undef']]]]"]

entries = _index_dict_['entries'] - 1
geom = 0
base = -1
structure = _index_dict_['structure'] - 1
factors_QQ = _index_dict_['factors_QQ']
desc_ZZ = _index_dict_['desc_ZZ']
desc_ZZ_index = _index_dict_['index']

interesting = 0
with open(inputfile) as inputstream:
    for line in inputstream:
        linestrip = line.rstrip()
        linesplit = linestrip.split(':')
        if not linesplit[index] in boring:
            L = eval(linesplit[index])
            # All interesting cases:
            if True:
            # Geometrically simple:
            #if len(L[entries][geom][structure][factors_QQ]) == 1 and not any("M" in string for string in L[entries][geom][structure][2]):
            #if len(L[entries][geom][structure][factors_QQ]) == 1 and any("M" in string for string in L[entries][geom][structure][2]):
            # Non-geometrically simple:
            #if len(L[entries][base][structure][factors_QQ]) == 1 and not any("M" in string for string in L[entries][geom][structure][2]) and not (len(L[entries][geom][structure][factors_QQ]) == 1 and not any("M" in string for string in L[entries][geom][structure][2])):
            # Three distinct geometric factors:
            #if len(L[entries][geom][structure][factors_QQ]) == 3:
            # Two distinct geometric factors:
            #if len(L[entries][geom][structure][factors_QQ]) == 2:
            # Two distinct geometric factors and index divisibility:
            #if (len(L[entries][geom][structure][factors_QQ]) == 2) and (L[entries][geom][structure][desc_ZZ][desc_ZZ_index] % 2 == 0):
                interesting += 1
                print ""
                print linesplit[0:index]
                print L
                print pretty_print_lattice_description(L, g = 3)
print ""
print "Total number of entries:"
print interesting