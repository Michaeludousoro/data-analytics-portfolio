"""One visual style shared by every chart in the portfolio.

Call `apply_house_style()` once near the top of a notebook. Every figure
after that inherits the same fonts, colours, spacing and grid, so the
five case studies look like they belong together.
"""

from __future__ import annotations

import matplotlib as mpl
import matplotlib.pyplot as plt

# A restrained, colour-blind-safe categorical palette (blue, orange, green,
# red, purple, grey). Enough for most business charts; if you need more than
# six categories, that is usually a sign to group the long tail into "Other".
PALETTE = ["#2f6f9f", "#e1812c", "#3a923a", "#c03d3e", "#8d69b8", "#7f7f7f"]


def apply_house_style() -> None:
    """Set portfolio-wide matplotlib defaults."""
    mpl.rcParams.update(
        {
            "figure.figsize": (8, 4.5),
            "figure.dpi": 110,        # crisp in the notebook
            "savefig.dpi": 200,       # crisp when exported for the site
            "savefig.bbox": "tight",
            "axes.spines.top": False,   # drop the top/right box lines
            "axes.spines.right": False,
            "axes.grid": True,
            "grid.alpha": 0.25,        # faint grid, stays in the background
            "axes.titlesize": 13,
            "axes.titleweight": "bold",
            "axes.titlelocation": "left",  # left-aligned titles read like headlines
            "axes.labelsize": 11,
            "font.size": 10,
            "legend.frameon": False,
        }
    )
    plt.rcParams["axes.prop_cycle"] = mpl.cycler(color=PALETTE)
