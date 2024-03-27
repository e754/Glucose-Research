import subprocess

# List of scripts to be executed in order
scripts = [
    "src/2_cohorts/2_cohort_selection.py",
    "src/2_cohorts/3_CONSORT_diagram.ipynb",
    "src/2_cohorts/4_tableOne.py",
]

for script in scripts:
    if script.endswith(".py"):
        subprocess.call(["python3", script])
    elif script.endswith(".ipynb"):
        subprocess.call(["jupyter", "nbconvert", "--execute", script])
