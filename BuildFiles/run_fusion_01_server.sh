#!/bin/bash

# Path to your executable file
EXECUTABLE_PATH="E:/Unity/Fusion01-Dedicated-Server-main/Fusion01-Dedicated-Server-main/BuildFiles/PC/Fusion 01 Dedicated Server"


# Check if the file exists
if [ -f "$EXECUTABLE_PATH" ]; then
    # Make the file executable (if not already executable)
    chmod +x "$EXECUTABLE_PATH"

    # Execute the file in the foreground, replacing the shell with the process
    exec "$EXECUTABLE_PATH"
else
    echo "Executable not found at $EXECUTABLE_PATH"
fi