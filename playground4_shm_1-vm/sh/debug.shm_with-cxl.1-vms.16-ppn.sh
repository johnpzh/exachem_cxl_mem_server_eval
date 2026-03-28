#!/bin/bash
echo "Waiting 30s or attach to PID $$ on $(hostname)"
sleep 30    # or the infinite loop from above
exec /root/mnt/shared/install/tamm/bin/ExaChem "$@"