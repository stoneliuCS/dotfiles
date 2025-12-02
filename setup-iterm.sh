#!/bin/bash

brew install --cask font-0xproto-nerd-font

PROFILE_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
mkdir -p "$PROFILE_DIR"

cat > "$PROFILE_DIR/0xproto-nerdfont.json" <<'EOF'
{
  "Profiles": [
    {
      "Guid": "A5C5B88E-6D5C-4B5B-9E01-0XPROTO123456",
      "Name": "0xProto Nerd Font Profile",
      "Normal Font": "0xProto Nerd Font Mono 16",
      "Non Ascii Font": "0xProto Nerd Font Mono 16",
      "Use Non-ASCII Font": true
    }
  ]
}
EOF

