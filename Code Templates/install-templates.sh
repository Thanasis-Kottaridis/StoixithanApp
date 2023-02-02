#!/usr/bin/env sh

# Configuration
XCODE_TEMPLATE_DIR=$HOME'/Library/Developer/Xcode/Templates/Custom Templates'
SCRIPT_DIR="."

# Copy file templates into the local XCode template directory
xcodeTemplate () {
  echo "==> Copying up Xcode file templates..."
  echo $SCRIPT_DIR

  if [ -d "$XCODE_TEMPLATE_DIR" ]; then
    rm -R "$XCODE_TEMPLATE_DIR"
  fi
  mkdir -p "$XCODE_TEMPLATE_DIR"

  cp -R $SCRIPT_DIR/*.xctemplate "$XCODE_TEMPLATE_DIR"
}

xcodeTemplate

echo "==> ... success!"
echo "==> Templates have been set up. In Xcode, select 'New File...' and scroll down to 'Custom Templates' section to use them."
