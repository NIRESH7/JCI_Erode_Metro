import os
import re
from datetime import datetime
import subprocess

# Configuration
project_root = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
pubspec_path = f"{project_root}/pubspec.yaml"

def get_current_build_number(pubspec_content):
    """Extract the current build number from pubspec.yaml."""
    version_match = re.search(r"version:\s*([\d.]+)\+(\d+)", pubspec_content)
    if version_match:
        return int(version_match.group(2)), version_match.group(1)  # build_number, version
    return None, None

def update_build_number(new_build_number, version, pubspec_content):
    """Update the build number in pubspec.yaml."""
    updated_content = re.sub(
        r"version:\s*([\d.]+)\+(\d+)",
        f"version: {version}+{new_build_number}",
        pubspec_content
    )
    with open(pubspec_path, "w") as file:
        file.write(updated_content)

def get_line_last_modified_date(file_path, line_number):
    """Get the last modified date of a specific line in a file using git."""
    try:
        output = subprocess.check_output(
            ["git", "blame", "-L", f"{line_number},{line_number}", "--date=iso", file_path],
            text=True
        )
        date_match = re.search(r"\((?:[^)]+) (\d{4}-\d{2}-\d{2})", output)
        if date_match:
            return date_match.group(1)
    except subprocess.CalledProcessError:
        pass
    return None

def main():
    if not os.path.exists(pubspec_path):
        print(f"Error: {pubspec_path} not found.")
        return

    # Read pubspec.yaml
    with open(pubspec_path, "r") as file:
        pubspec_content = file.read()

    current_build_number, version = get_current_build_number(pubspec_content)
    if current_build_number is None or version is None:
        print("Error: Could not parse version/build number from pubspec.yaml.")
        return

    print(f"Current build number: {current_build_number}")

    # Locate the line number of the version key
    version_line_number = None
    for i, line in enumerate(pubspec_content.splitlines(), start=1):
        if line.strip().startswith("version:"):
            version_line_number = i
            break

    if version_line_number is None:
        print("Error: Could not locate the version line in pubspec.yaml.")
        return

    # Check if the version line was modified today
    last_modified_date = get_line_last_modified_date(pubspec_path, version_line_number)
    if last_modified_date == datetime.now().strftime("%Y-%m-%d"):
        print("Version line was modified today. Keeping the same build number.")
        return

    # Increment build number
    new_build_number = current_build_number + 1
    print(f"Incrementing build number to: {new_build_number}")
    update_build_number(new_build_number, version, pubspec_content)
    return new_build_number

if __name__ == "__main__":
    main()
