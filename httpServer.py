# Simple HTTP Server to access the files of the current folder
# It will use the index.html as the main page
import http.server
import socketserver

PORT = 8080 # Changed the port HTTP is serving
Handler = http.server.SimpleHTTPRequestHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print("serving at port",PORT)
    httpd.serve_forever()
