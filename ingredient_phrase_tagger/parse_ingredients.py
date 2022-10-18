#!/usr/bin/env python3

import argparse
import json
import sys
import subprocess
import tempfile

from .training import utils


def _exec_crf_test(input_text, model_path):
    with tempfile.NamedTemporaryFile(mode='w') as input_file:
        input_file.write(utils.export_data(input_text))
        input_file.flush()
        return subprocess.check_output(
            ['crf_test', '--verbose=1', '--model', model_path,
             input_file.name]).decode('utf-8')


def _convert_crf_output_to_json(crf_output):
    return utils.import_data(crf_output)


def parse(path_to_model_file, ingredient_lines):
    crf_output = _exec_crf_test(ingredient_lines, path_to_model_file)
    return _convert_crf_output_to_json(crf_output.split('\n'))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        prog='Ingredient Phrase Tagger',
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-m', '--model-file', required=True)
    parse(parser.parse_args())