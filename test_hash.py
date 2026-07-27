import hashlib

secret = "eouZjmhrLwfGrB6Muck5b4TT2gdqD7RWnQoeBzCAyU"
api_call = "getRecordings"
s = api_call + secret
print(hashlib.sha1(s.encode('utf-8')).hexdigest())
