#!/usr/bin/env python3
"""
time.py - Output current UTC time in RFC3339 format.

Deterministic time utility for task management.
No external APIs. No locale dependence.

Usage:
    python time.py
    
Output:
    2026-01-09T17:23:10Z
"""

import sys
from datetime import datetime, timezone


def get_utc_now_rfc3339() -> str:
    """Return current UTC time in RFC3339 format."""
    now = datetime.now(timezone.utc)
    return now.strftime("%Y-%m-%dT%H:%M:%SZ")


def main() -> int:
    print(get_utc_now_rfc3339())
    return 0


if __name__ == "__main__":
    sys.exit(main())
