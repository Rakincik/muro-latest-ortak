import os

with open('generate_sessions_sql.py', 'r', encoding='utf-8') as f:
    code = f.read()

code = code.replace('"Status", "Order", "RecordingEnabled"', '"Status", "Order", "RecordingEnabled", "IsFree"')
code = code.replace('3, 0, true', '3, 0, true, false')
code = code.replace('f.write("BEGIN;\\n\\n")', '')
code = code.replace('f.write("COMMIT;\\n")', '')

with open('generate_sessions_sql.py', 'w', encoding='utf-8') as f:
    f.write(code)
