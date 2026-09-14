"""Shared helpers for every project in the portfolio.

Keeping common code here (instead of copy-pasting between notebooks) means
all five case studies use the same file paths and the same chart style,
so the finished portfolio reads as one coherent body of work.
"""

from portfolio.db import get_engine, run_sql_file
from portfolio.paths import PROJECTS_DIR, REPO_ROOT, project_dir
from portfolio.viz import PALETTE, apply_house_style

__all__ = [
    "REPO_ROOT",
    "PROJECTS_DIR",
    "project_dir",
    "PALETTE",
    "apply_house_style",
    "get_engine",
    "run_sql_file",
]
