#!/bin/sh

set -e

. /venv/bin/activate

python -m demoapp.main $@