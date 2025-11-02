#!/usr/bin/env bash
# Gopher Hide-and-Seek (3x3 grid)
# You move with n/s/e/w to catch the hidden gopher. Distance hint is shown each turn.
set -euo pipefail

GRID_SIZE=3
px=2; py=2                 # Player starting position (center)
gx=$(( (RANDOM % GRID_SIZE) + 1 ))
gy=$(( (RANDOM % GRID_SIZE) + 1 ))
steps=0
wins=0

print_grid() {
  local y x
  echo
  for (( y=1; y<=GRID_SIZE; y++ )); do
    for (( x=1; x<=GRID_SIZE; x++ )); do
      if (( x==px && y==py )); then
        printf " P "
      else
        printf " . "
      fi
    done
    echo
  done
  echo
}

dist_to_gopher() {
  local dx dy
  dx=$(( gx - px ))
  if (( dx < 0 )); then dx=$(( -dx )); fi
  dy=$(( gy - py ))
  if (( dy < 0 )); then dy=$(( -dy )); fi
  echo $(( dx + dy ))
}

echo "Gopher Hide-and-Seek"
echo "Find the hidden gopher in a ${GRID_SIZE}x${GRID_SIZE} grid. You are 'P'. The gopher is hidden (not shown)."

while true; do
  clear >/dev/null 2>&1 || true
  print_grid
  dist=$(dist_to_gopher)
  echo "Distance to gopher: $dist"
  echo -n "Move (n/s/e/w) or q to quit: "; read -r move
  case "$move" in
    [nN]|north)      if (( py > 1 )); then ((py--)); else echo "Cannot move there."; fi ;;
    [sS]|south)      if (( py < GRID_SIZE )); then ((py++)); else echo "Cannot move there."; fi ;;
    [eE]|east)      if (( px < GRID_SIZE )); then ((px++)); else echo "Cannot move there.";; fi ;;
    [wW]|west)      if (( px > 1 )); then ((px--)); else echo "Cannot move there.";; fi ;;
    [qQ]|quit)      echo "Quitting."      break ;;
    *)      echo "Invalid input. Use n/s/e/w or q to quit.";      ;;
  esac
  ((steps++))
  if (( px==gx && py==gy )); then
    echo "You found the gopher in ${steps} step(s)! Well done."
    ((wins++))
    echo -n "Play again? (y/n): "; read -r resp
    if [[ "$resp" =~ ^[Yy]$ ]]; then
      px=2; py=2
      gx=$(( (RANDOM % GRID_SIZE) + 1 ))
      gy=$(( (RANDOM % GRID_SIZE) + 1 ))
      steps=0
      continue
    else
      break
    fi
  fi
  # Gopher random move
  case $((RANDOM % 4)) in
    0) (( gy > 1 )) && gy=$(( gy - 1 )) ;;
    1) (( gy < GRID_SIZE )) && gy=$(( gy + 1 )) ;;
    2) (( gx < GRID_SIZE )) && gx=$(( gx + 1 )) ;;
    3) (( gx > 1 )) && gx=$(( gx - 1 )) ;;
  esac
done

echo "Game over. Final stats: wins=$wins, steps=$steps"
