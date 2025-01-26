#!/bin/bash

HOME_DIR="$HOME"
TEST_DIR="$HOME_DIR/test"
ARCHIVED_DIR="$TEST_DIR/archived"
REPORT_FILE="$HOME_DIR/report"

CURRENT_DATETIME=$(date +"%Y-%m-%d_%H-%M-%S")
CURRENT_DATE=$(date +"%Y-%m-%d")

mkdir -p "$ARCHIVED_DIR"

PREVIOUS_FILES=$(find "$TEST_DIR" -maxdepth 1 -type f -name "*.txt" ! -name "*$CURRENT_DATE*.txt")

if [ -n "$PREVIOUS_FILES" ]; then
  ARCHIVE_NAME="$ARCHIVED_DIR/$CURRENT_DATE.tar.gz"
  tar -czf "$ARCHIVE_NAME" $PREVIOUS_FILES
  rm $PREVIOUS_FILES
fi

NEW_FILE="$TEST_DIR/${CURRENT_DATETIME}.txt"
echo "Created on $CURRENT_DATETIME" > "$NEW_FILE"

echo "$(date +"%Y-%m-%d %H:%M:%S") test was created successfully" >> "$REPORT_FILE"
