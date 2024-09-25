#!/usr/bin/env python3
#
# Very simple HTTP server in python for logging requests
# usage: ./server.py [<port>]
#
from http.server import BaseHTTPRequestHandler, HTTPServer
import socketserver
import cgi
import os

PORT = 8000
upload_form = '''\
    <html><body>
    <h1>Upload File</h1>
    <form enctype="multipart/form-data" method="post">
    <p>File: <input type="file" name="file"/></p>
    <p><input type="submit" value="Upload"/></p>
    </form>
    </body></html>
'''

class ServerHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        try:
            if self.path == '/':
                # List files and show upload form
                files = os.listdir('.')
                files_list = '<ul>'
                for f in files:
                    files_list += '<li><a href="/{}">{}</a></li>'.format(f, f)
                files_list += '</ul>'
                response = '<html><body>{}<hr>{}</body></html>'.format(files_list, upload_form)
                self.send_response(200)
                self.send_header('Content-type', 'text/html')
                self.end_headers()
                self.wfile.write(response.encode())
            else:
                f = open(os.curdir + os.sep + self.path, 'rb')
                self.send_response(200)
                # Set the appropriate Content-type header
                if self.path.endswith('.html'):
                    self.send_header('Content-type', 'text/html')
                elif self.path.endswith('.jpg') or self.path.endswith('.jpeg'):
                    self.send_header('Content-type', 'image/jpeg')
                elif self.path.endswith('.png'):
                    self.send_header('Content-type', 'image/png')
                elif self.path.endswith('.gif'):
                    self.send_header('Content-type', 'image/gif')
                elif self.path.endswith('.js'):
                    self.send_header('Content-type', 'application/javascript')
                elif self.path.endswith('.css'):
                    self.send_header('Content-type', 'text/css')
                else:
                    self.send_header('Content-type', 'application/octet-stream')
                self.end_headers()
                self.wfile.write(f.read())
                f.close()
        except IOError:
            self.send_error(404, 'File Not Found: %s' % self.path)

    def do_HEAD(self):
        pass

    def do_POST(self):
        r, info = self.deal_post_data()
        print((r, info, "by:", self.client_address))
        f = '''\
            <html><body>
            <h1>Upload Result Page</h1>
            <hr>
            {}
            <br><a href="/">back</a>
            </body></html>
        '''.format(info)
        self.send_response(200)
        self.end_headers()
        self.wfile.write(f.encode())

    def deal_post_data(self):
        ctype, pdict = cgi.parse_header(self.headers.get('Content-Type'))
        if ctype == 'multipart/form-data':
            pdict['boundary'] = bytes(pdict['boundary'], "utf-8")
            pdict['CONTENT-LENGTH'] = int(self.headers.get('Content-Length'))
            fs = cgi.FieldStorage(
                fp=self.rfile,
                headers=self.headers,
                environ={
                    'REQUEST_METHOD': 'POST',
                    'CONTENT_TYPE': self.headers.get('Content-Type'),
                },
                keep_blank_values=True
            )
        else:
            return (False, "Unexpected POST request")
        if 'file' in fs:
            fs_up = fs['file']
            filename = os.path.basename(fs_up.filename)
            with open(filename, 'wb') as o:
                o.write(fs_up.file.read())
            return (True, "File '{}' upload success!".format(filename))
        else:
            return (False, "No file uploaded")

Handler = ServerHandler

httpd = socketserver.TCPServer(("", PORT), Handler)

print("Serving at port", PORT)
httpd.serve_forever()
