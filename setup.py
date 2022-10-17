#!/usr/bin/env python3
import sys

from setuptools import setup, find_packages

import ingredient_phrase_tagger

setup(name='ipt',
      version='0.0.0.dev0',
      description=('Extract structured data from ingredient phrases using '
                   'conditional random fields'),
      author='The New York Times Company',
      author_email='',
      license='Apache 2.0',
      install_requires=[],
      python_requires='>=3',
      packages=find_packages(),
      package_dir={'ingredient_phrase_tagger': 'ingredient_phrase_tagger'})
