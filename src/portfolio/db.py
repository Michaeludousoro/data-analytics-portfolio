"""Database connection helpers, shared by every project that queries SQL.

Why this exists:
- We keep SQL in `.sql` files (version-controlled, syntax-highlighted, reviewable),
  not pasted into Python strings. `run_sql_file()` runs one and hands back a
  DataFrame.
- Connection details live in `.env` (gitignored), never in code.
- Every connection pins the session time zone to a fixed `+00:00` offset, so
  `TIMESTAMP` columns come back exactly as they were stored — no surprise DST
  shifts between your machine's locale and the data.
"""

from __future__ import annotations

import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import Engine, create_engine, text

from portfolio.paths import REPO_ROOT


def get_engine(env_var: str = "MFF_DB_URL") -> Engine:
    """Build a SQLAlchemy engine from a connection URL held in an env var.

    `env_var` names the variable in `.env` to read (default the Maven Fuzzy
    Factory database used by project 05).
    """
    load_dotenv(REPO_ROOT / ".env")
    url = os.environ.get(env_var)
    if not url:
        raise RuntimeError(
            f"{env_var} is not set. Copy .env.example to .env and fill it in."
        )
    return create_engine(
        url,
        # runs once when each pooled connection opens
        connect_args={"init_command": "SET time_zone = '+00:00'"},
        # silently re-check a pooled connection before use (MySQL drops idle ones)
        pool_pre_ping=True,
    )


def run_sql_file(
    path: str | Path,
    engine: Engine,
    params: dict | None = None,
) -> pd.DataFrame:
    """Execute the SQL in `path` and return the result as a DataFrame.

    `params` fills named placeholders written as `:name` in the SQL, passed
    safely as bind parameters (never string-formatted into the query).
    """
    sql = Path(path).read_text()
    with engine.connect() as conn:
        return pd.read_sql_query(text(sql), conn, params=params)
