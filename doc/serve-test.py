#!/usr/bin/env python3
"""
HTTP server for testing v86 with large disk images.
Supports range requests (HTTP 206) so browsers can fetch disk images in chunks.
"""

import http.server
import socketserver
import os
import sys


class _LimitedFile:
    """Wraps a file and limits reads to `length` bytes."""
    def __init__(self, f, length):
        self._f = f
        self._remaining = length

    def read(self, n=-1):
        if self._remaining <= 0:
            return b''
        if n < 0 or n > self._remaining:
            n = self._remaining
        data = self._f.read(n)
        self._remaining -= len(data)
        return data

    def close(self):
        self._f.close()


class RangeRequestHandler(http.server.SimpleHTTPRequestHandler):

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Accept-Ranges', 'bytes')
        super().end_headers()

    def send_head(self):
        path = self.translate_path(self.path)

        if os.path.isdir(path):
            return super().send_head()

        range_header = self.headers.get('Range')
        if not range_header:
            return super().send_head()

        try:
            f = open(path, 'rb')
        except OSError:
            self.send_error(404, "File not found")
            return None

        try:
            file_len = os.fstat(f.fileno()).st_size
            parts = range_header.replace('bytes=', '').split('-')
            start = int(parts[0]) if parts[0] else 0
            end = int(parts[1]) if len(parts) > 1 and parts[1] else file_len - 1

            if start < 0 or start > end or end >= file_len:
                f.close()
                self.send_error(416, "Requested Range Not Satisfiable")
                return None

            length = end - start + 1
            self.send_response(206)
            self.send_header("Content-Type", self.guess_type(path))
            self.send_header("Content-Range", f"bytes {start}-{end}/{file_len}")
            self.send_header("Content-Length", str(length))
            self.end_headers()

            f.seek(start)
            return _LimitedFile(f, length)

        except Exception as e:
            f.close()
            self.send_error(500, str(e))
            return None

    def log_message(self, fmt, *args):
        print(f"{self.address_string()} {fmt % args}")


def serve(port=8000, directory=None):
    if directory:
        os.chdir(directory)

    with socketserver.TCPServer(("", port), RangeRequestHandler) as httpd:
        httpd.allow_reuse_address = True
        print(f"Serving on http://localhost:{port}")
        print(f"Open: http://localhost:{port}/doc/v86-loader.html")
        print("Ctrl+C to stop")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\nStopped.")


if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
    directory = sys.argv[2] if len(sys.argv) > 2 else None
    serve(port, directory)
