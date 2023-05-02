import logging
import os


#logger = logging.getLogger(__name__)

SVG_TEMPLATE = '''
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="96" height="20">
    <linearGradient id="b" x2="0" y2="100%"><stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
        <stop offset="1" stop-opacity=".1"/>
    </linearGradient>
    <clipPath id="a">
        <rect width="96" height="20" rx="3" fill="#fff"/>
    </clipPath>
    <g clip-path="url(#a)">
        <path fill="#555" d="M0 0h61v20H0z"/>
        <path fill="{color}" d="M61 0h35v20H61z"/>
        <path fill="url(#b)" d="M0 0h96v20H0z"/>
    </g>
    <g fill="#fff" text-anchor="middle" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="110">
        <text x="315" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="510">coverage</text>
        <text x="315" y="140" transform="scale(.1)" textLength="510">coverage</text>
        <text x="775" y="150" fill="#010101" fill-opacity=".3" transform="scale(.1)" textLength="250">{percentage}%</text>
        <text x="775" y="140" transform="scale(.1)" textLength="250">{percentage}%</text>
    </g>
</svg>
'''


def create_svg(percentage):
    if percentage >= 95:
        color = "#4c1"
    elif 90 <= percentage < 95:
        color = "#a3c51c"
    elif 75 <= percentage < 90:
        color = "#dfb317"
    elif percentage < 75:
        color = "#e05d44"
    else:
        color = "#9f9f9f"

    return SVG_TEMPLATE.format(percentage=percentage, color=color)


def process_data():
    coverage_command = r'genhtml coverage/lcov.info --output=coverage --dark-mode | grep -oP "\d+\.\d+"'
    value = float(os.popen(coverage_command).read())
    if not value:
        raise ValueError("Unable to find percentage")
    coverage = round(value)
    badge_data = create_svg(coverage)

    with open("coverage_badge.svg", "w", encoding="utf-8") as badge_file:
        badge_file.write(badge_data)


if __name__ == "__main__":
    process_data()
    print("Coverage badge generated")
