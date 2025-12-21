#!/usr/bin/env bash

for protofile in protocols/*.xml; do
	HEADER="${protofile%.xml}.h"
	echo "$protofile -> $HEADER"
	wayland-scanner client-header $protofile $HEADER
done
