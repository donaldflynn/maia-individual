
import argparse

def replace_string_in_file(file_path, old_string, new_string):
    try:
        # Read the original content of the file
        with open(file_path, 'r', encoding='utf-8') as file:
            file_contents = file.read()

        # Replace the specified string
        file_contents = file_contents.replace(old_string, new_string)

        # Write the modified content back to the file
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(file_contents)

        print("File updated successfully!")
    except FileNotFoundError:
        print("The file does not exist. Please check the file path.")
    except Exception as e:
        print(f"An error occurred: {e}")


def main():
    # Create the parser
    parser = argparse.ArgumentParser(description='Replace strings in a text file.')
    # Add the arguments
    parser.add_argument('file_path', type=str, help='The path to the file where strings will be replaced.')
    parser.add_argument('old_string', type=str, help='The string to be replaced.')
    parser.add_argument('new_string', type=str, help='The new string that will replace the old string.')

    # Parse the arguments
    args = parser.parse_args()

    # Perform the replacement
    replace_string_in_file(args.file_path, args.old_string, args.new_string)

if __name__ == "__main__":
    main()