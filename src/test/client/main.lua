local http = require("socket.http")

r,c = http.request("http://localhost:8080/hoge")
print(r,c)