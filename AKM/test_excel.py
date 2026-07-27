import openpyxl
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
file_path = os.path.join(script_dir, "akademikmasa.xlsx")
wb = openpyxl.load_workbook(file_path, data_only=True)
s2 = wb['Sayfa2']
rows = list(s2.iter_rows(values_only=True))

for i, r in enumerate(rows[:5]):
    print(f"Row {i+1}: {r}")
