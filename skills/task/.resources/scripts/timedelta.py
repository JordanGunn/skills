#!/usr/bin/env python3
"""
timedelta.py - Compute time offsets from a base RFC3339 timestamp.

Deterministic time delta utility for task management.
No external APIs. No locale dependence.

Usage:
    python timedelta.py --from 2026-01-09T17:23:10Z --days 7
    python timedelta.py --from 2026-01-09T17:23:10Z --days -3 --hours 2
    python timedelta.py --now --days 14

Output:
    2026-01-16T17:23:10Z
"""

import argparse
import sys
from datetime import datetime, timedelta, timezone


def parse_rfc3339(timestamp: str) -> datetime:
    """Parse RFC3339 timestamp to datetime."""
    timestamp = timestamp.replace("Z", "+00:00")
    try:
        return datetime.fromisoformat(timestamp)
    except ValueError as e:
        raise ValueError(f"Invalid RFC3339 timestamp: {timestamp}") from e


def format_rfc3339(dt: datetime) -> str:
    """Format datetime as RFC3339 UTC."""
    utc_dt = dt.astimezone(timezone.utc)
    return utc_dt.strftime("%Y-%m-%dT%H:%M:%SZ")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Compute time offsets from a base RFC3339 timestamp"
    )
    parser.add_argument(
        "--from",
        dest="from_time",
        type=str,
        help="Base RFC3339 timestamp (e.g., 2026-01-09T17:23:10Z)"
    )
    parser.add_argument(
        "--now",
        action="store_true",
        help="Use current UTC time as base"
    )
    parser.add_argument(
        "--days",
        type=int,
        default=0,
        help="Days to add (negative to subtract)"
    )
    parser.add_argument(
        "--hours",
        type=int,
        default=0,
        help="Hours to add (negative to subtract)"
    )
    parser.add_argument(
        "--minutes",
        type=int,
        default=0,
        help="Minutes to add (negative to subtract)"
    )

    args = parser.parse_args()

    if args.now:
        base_dt = datetime.now(timezone.utc)
    elif args.from_time:
        try:
            base_dt = parse_rfc3339(args.from_time)
        except ValueError as e:
            print(f"Error: {e}", file=sys.stderr)
            return 1
    else:
        print("Error: Must specify --from <timestamp> or --now", file=sys.stderr)
        return 1

    delta = timedelta(days=args.days, hours=args.hours, minutes=args.minutes)
    result_dt = base_dt + delta

    print(format_rfc3339(result_dt))
    return 0


if __name__ == "__main__":
    sys.exit(main())
