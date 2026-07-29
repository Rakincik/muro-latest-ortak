import hashlib

meeting_id = "ec6512fa5e8253ab840e99485ba9ccce2e11f594"
print("sha1 of meetingId:", hashlib.sha1(meeting_id.encode()).hexdigest())
