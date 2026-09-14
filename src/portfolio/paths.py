"""Filesystem paths, always resolved from the repository root.

Import these instead of writing relative paths like "../../data/raw" in a
notebook. Relative paths break as soon as you move a notebook or launch
Jupyter from a different folder; these do not.
"""

from pathlib import Path

# __file__ is .../data-analytics-portfolio/src/portfolio/paths.py
# .parents[0] = portfolio/, [1] = src/, [2] = the repo root.
REPO_ROOT = Path(__file__).resolve().parents[2]

PROJECTS_DIR = REPO_ROOT / "projects"


def project_dir(name: str) -> Path:
    """Return the folder for one project, e.g. project_dir("05-marketing-funnel")."""
    path = PROJECTS_DIR / name
    if not path.exists():
        raise FileNotFoundError(f"No project folder at {path}")
    return path
