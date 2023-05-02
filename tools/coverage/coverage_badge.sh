
set -o errexit
set -o pipefail
set -o nounset

python tools/coverage/coverage_badge_generator.py
git add coverage_badge.svg