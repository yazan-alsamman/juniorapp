import os
import re

def remove_comments_from_file(file_path):
    """Remove all comments from a Dart file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        lines = content.split('\n')
        new_lines = []
        in_multiline = False
        multiline_start = None
        
        for i, line in enumerate(lines):
            if in_multiline:
                # Check for end of multiline comment
                end_idx = line.find('*/')
                if end_idx != -1:
                    # Remove the part before */
                    line = line[end_idx + 2:]
                    in_multiline = False
                    multiline_start = None
                else:
                    # Entire line is part of multiline comment, skip it
                    new_lines.append('')
                    continue
            
            # Check for /* style comments
            comment_start = line.find('/*')
            if comment_start != -1:
                comment_end = line.find('*/', comment_start + 2)
                if comment_end != -1:
                    # Remove the comment
                    line = line[:comment_start] + line[comment_end + 2:]
                else:
                    # Multiline comment starts here
                    in_multiline = True
                    multiline_start = comment_start
                    line = line[:comment_start]
            
            # Remove single-line comments (// and ///)
            # But preserve strings
            line_without_comments = ''
            in_string = False
            string_char = None
            i = 0
            while i < len(line):
                char = line[i]
                
                if not in_string:
                    # Check for comment start
                    if i < len(line) - 1:
                        if line[i:i+2] == '//':
                            break
                        elif line[i:i+2] == '/*':
                            comment_end = line.find('*/', i + 2)
                            if comment_end != -1:
                                i = comment_end + 1
                                continue
                            else:
                                in_multiline = True
                                break
                    
                    # Check for string start
                    if char in ['"', "'"]:
                        in_string = True
                        string_char = char
                        line_without_comments += char
                    else:
                        line_without_comments += char
                else:
                    line_without_comments += char
                    if char == string_char and (i == 0 or line[i-1] != '\\'):
                        in_string = False
                        string_char = None
                
                i += 1
            
            line = line_without_comments
            
            # Remove trailing whitespace
            line = line.rstrip()
            
            # Only add non-empty lines or preserve empty lines structure
            new_lines.append(line)
        
        new_content = '\n'.join(new_lines)
        # Remove multiple consecutive empty lines
        new_content = re.sub(r'\n\n\n+', '\n\n', new_content)
        
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        print(f"Processed: {file_path}")
    except Exception as e:
        print(f"Error processing {file_path}: {e}")

def process_directory(directory):
    """Process all Dart files in a directory recursively."""
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                remove_comments_from_file(file_path)

if __name__ == '__main__':
    script_dir = os.path.dirname(os.path.abspath(__file__))
    directory = os.path.join(script_dir, 'lib', 'lib_admin')
    if os.path.exists(directory):
        process_directory(directory)
        print('Done removing comments from all files.')
    else:
        print(f'Directory not found: {directory}')
