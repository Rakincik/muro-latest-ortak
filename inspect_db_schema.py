import subprocess

# Run a query to inspect table schemas and counts of active courses
cmd_courses = 'docker exec -i muro_mng_postgres psql -U $POSTGRES_USER -d $POSTGRES_DB -c "\d \\"Courses\\""'
cmd_sessions = 'docker exec -i muro_mng_postgres psql -U $POSTGRES_USER -d $POSTGRES_DB -c "\d \\"Sessions\\""'

try:
    print("Courses Table Schema:")
    print(subprocess.check_output(cmd_courses, shell=True, text=True))
    print("\nSessions Table Schema:")
    print(subprocess.check_output(cmd_sessions, shell=True, text=True))
except Exception as e:
    print(f"Error inspecting schema: {e}")
