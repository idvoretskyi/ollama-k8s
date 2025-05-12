#!/bin/bash

# Forward the call to the script in the scripts folder
"$(dirname "$0")/scripts/test-api.sh" "$@"
