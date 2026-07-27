import os
import subprocess
import sys
from pathlib import Path
import increment_build_number

# Configuration
project_root = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode("utf-8").strip()
env_file = ".env.production"
debug_symbols_path = f"{project_root}/build/app/outputs/symbols"
android_app_id = "1:706439036840:android:ed3352a4b42447f5d4a79d"
ios_issuer_id = ""
ios_api_key = ""  # Add the private key in project_root/private_keys folder
production = True
changelog_path = f"{project_root}/android/fastlane/metadata/android/en-US/changelogs"

def run_command(command:list, shell=False):
    """
    Runs the OS related command and exits the script if the command fails.
    """
    try:
        subprocess.run(command, shell=shell, check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")
        sys.exit(1)

def flutter_clean_and_get():
    run_command(["flutter", "clean"])
    run_command(["flutter", "pub", "get"])

def build_android(build_number: int = None, output: str = None):
    flutter_clean_and_get()
    build_command = [
        "flutter", "build", output if output else "apk",
        "--release",
        # f"--dart-define-from-file={env_file}",
        # f"-PenvFile={env_file}",
        "--obfuscate",
        f"--split-debug-info={debug_symbols_path}"
    ]
    if output == "apk":
        build_command.insert(3, "--split-per-abi")

    run_command(build_command)
    run_command([
        "firebase", "crashlytics:symbols:upload",
        f"--app={android_app_id}",
        debug_symbols_path
    ])
    # if production:
    #     if not release_notes:
    #         print("Enter the release notes (end with an empty line):")
    #         lines = []
    #         while True:
    #             line = input()
    #             if line:
    #                 lines.append(line)
    #             else:
    #                 break
    #         release_notes = "\n".join(lines)

    #     with open(f"{changelog_path}/{build_number}.txt", "x") as file:
    #         file.write(release_notes)
               
        

def build_ios():
    flutter_clean_and_get()
    run_command([
        "flutter", "build", "ipa", "--release",
        f"--dart-define-from-file={env_file}"
    ])
    ipa_path = Path("build/ios/ipa").glob("*.ipa")
    ipa_file = next(ipa_path, None)
    if ipa_file:
        run_command([
            "xcrun", "altool", "--upload-app", "--type", "ios",
            "-f", str(ipa_file),
            "--apiKey", ios_api_key,
            "--apiIssuer", ios_issuer_id
        ])
    else:
        print("No IPA file found for upload.")
        sys.exit(1)

def main():
    # Run the script to increment build number
    build_number = increment_build_number.main()
    
    # Argument parsing
    platform = None
    output = None
    for arg in sys.argv[1:]:

        if arg.startswith("--platform="):
            platform = arg.split("=")[1]

        elif arg.startswith("--output="):
            output = arg.split("=")[1]

    
    # Fallback to interactive input
    if not platform:
        platform = input("Enter the platform (android/ios): ").strip().lower()
        production = False

    # Validate and execute based on platform
    if platform == "android":
        if not output:
            output = input ("Enter the output (appbundle/apk): ").strip().lower()
        build_android(build_number, output)
    elif platform == "ios":
        build_ios()
    else:
        print("Invalid platform. Please enter either 'android' or 'ios'.")
        sys.exit(1)

if __name__ == "__main__":
    main()
