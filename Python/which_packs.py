# -*- coding: utf-8 -*-
"""
Created on Sat Jul  7 16:56:22 2018

@author: bjwil
"""

import shutil
import pkgutil

def show_acceptable_modules():
    line = '-' * 100
    print('{}\n{:^30}|{:^20}\n{}'.format(line, 'Module', 'Location', line))
    for entry in pkgutil.iter_modules():
        print('{:30}| {}'.format(entry[1], entry[0].path))

show_acceptable_modules()

