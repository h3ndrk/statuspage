#!/bin/sh

echo "data:$(file -bN --mime-type up.png);base64,$(base64 -w0 up.png)"
echo "data:$(file -bN --mime-type down.png);base64,$(base64 -w0 down.png)"
