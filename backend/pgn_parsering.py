import re
import bz2

import chess.pgn

moveRegex = re.compile(r'\d+[.][ \.](\S+) (?:{[^}]*} )?(\S+)')

class GamesFile(object):
    def __init__(self, path):
        if path.endswith('bz2'):
            self.f = bz2.open(path, 'rt')
        else:
            self.f = open(path, 'r')
        self.path = path
        self.i = 0

    def __iter__(self):
        try:
            while True:
                yield next(self)
        except StopIteration:
            return

    def __del__(self):
        try:
            self.f.close()
        except AttributeError:
            pass
    def __next__(self):
        current_entry = {}
        lines_buffer = []

        for line in self.f:
            self.i += 1
            lines_buffer.append(line)

            # Check if line length is less than 2
            if len(line) < 2:
                # Check if at least 2 key-value pairs are collected
                if len(current_entry) >= 2:
                    break
                else:
                    raise RuntimeError("Incomplete key-value pair: " + repr(line))
            else:
                try:
                    # Split the line into key, value, and optional separator
                    key, value, _ = line.split('"')
                except ValueError:
                    # Handle bad line
                    if line.strip() == 'null':
                        pass  # Skip 'null' lines
                    else:
                        raise RuntimeError("Error parsing line: " + repr(line))
                else:
                    current_entry[key[1:-1]] = value

        # Read the next line to check for the end of the file
        next_line = self.f.readline()
        lines_buffer.append(next_line)

        # Check if end of file is reached
        if not next_line:
            raise StopIteration

        # Read and append the next line to maintain consistency
        subsequent_line = self.f.readline()
        lines_buffer.append(subsequent_line)

        return current_entry, ''.join(lines_buffer)

