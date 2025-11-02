#!/usr/bin/env bash

set -euo pipefail

# Simple Whack-a-Mole game in bash
#
# The "mole" appears randomly in one of three positions:
#  (L)eft, (M)iddle, (R)ight. Press the corresponding key
#  before the next mole appears to score a hit.
#
# ──────────────────────────────
#
# Usage:
#   ./wac_a_mole.sh
#
# The game runs for 5 rounds. Your score is displayed at the end.
#
POS=("left" "middle" "right")
KEYS=("l" "m" "r")
SCORE=0
TOTAL_ROUNDS=5

function draw_board() {
    local mole=$1
    echo "          __"
    case $mole in
        0) echo "   /   V   \\" ;; 
        1) echo "   |  L  M  R |" ;; 
        2) echo "   \\   ^   /" ;; 
        *) echo "   |        |" ;; 
    esac
    echo ""
}

function play_round() {
    local round=$1
    local idx=$((RANDOM % 3))
    draw_board "$idx"
    echo -n "Round $round: Hit mole? (${KEYS[@]}) "
    read -t 1 -n1 input
    echo ""
    if [[ $input == "${KEYS[$idx]}" ]]; then
        echo "Hit!"
        SCORE=$((SCORE + 1))
    else
        echo "Miss!"
    fi
    echo ""
}

for ((i=1; i<=TOTAL_ROUNDS; i++)); do
    play_round $i
done

echo "Game over! Your score: $SCORE out of $TOTAL_ROUNDS."

