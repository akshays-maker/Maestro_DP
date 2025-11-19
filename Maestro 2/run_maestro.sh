#!/bin/zsh

maestro test sample_flow.yaml

echo "Do you want to keep the Maestro logs? (y/n): "
read keep_logs

if [[ "$keep_logs" == "n" ]]; then
  rm -rf ~/.maestro/logs
  echo "Logs deleted."
else
  echo "Logs kept."
fi