import argparse
import os
from collections import Counter

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--filename", type=str, required=True)
    parser.add_argument("--vocab_size", type=int, required=True)
    args = parser.parse_args()
    count = [['<unk>', -1], ['<s>', -1], ['</s>', -1]]
    data = []
    with open(args.filename, 'r') as f:
        for line in f:
            data += line.strip().split()
    counter = Counter(data)
    count.extend(counter.most_common(args.vocab_size))
    to_file = os.linesep.join(map(lambda x: x[0], count))
    path, filename = os.path.split(args.filename)
    out_file_name = os.path.join(path, "vocab." + filename)
    with open(out_file_name, 'w') as f:
            f.write(to_file)
