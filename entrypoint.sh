#!/bin/bash

# Open DuckDB CLI
/analytics/duckdb retail.db

# Keep the container running
tail -f /dev/null