#!/bin/bash

cat > index.html <<EOF
<h1>Hello, World</h1>
<p>server_port: ${server_port}</p>
EOF

echo "current path: $(pwd)"
python3 -m http.server ${server_port} --directory . &