import subprocess

# List of scripts to be executed in order
scripts = [
    "src/2_cohorts/1_get_data.py",
    "src/2_cohorts/2_cohort_selection.py",
    "src/2_cohorts/3_CONSORT_diagram.ipynb",
    "src/2_cohorts/4_tableOne.py",
    "src/2_cohorts/5_figure2_plot.ipynb",
    "src/4_logReg/Logreg_day1.ipynb",
    "src/5_NegBin/NegBin_code.ipynb",
]

for script in scripts:
    if script.endswith(".py"):
        subprocess.call(["python3", script])
    elif script.endswith(".ipynb"):
        subprocess.call(["jupyter", "nbconvert", "--execute", "--inplace", script])
