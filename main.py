import argparse
import io
import os.path
import random


def random_bytes() -> bytes:
    return random.randbytes(512)


def sum_bytes(op1: bytes, op2: bytes) -> int:
    return int.from_bytes(op1, 'little') + int.from_bytes(op2, 'little')


ap = argparse.ArgumentParser()

# Add the arguments to the parser
ap.add_argument("-f", "--floppy_file", required=True,
   help="Path to floppy file")
ap.add_argument("-m", "--mode", required=True,
   help="Work mode (write 2 sectors is 'sw' or sum check 'sc'")
args = vars(ap.parse_args())

if __name__ == '__main__':
    file = args['floppy_file']
    mode = args['mode']
    if mode == 'sw':
        total_bytes = 1_474_560
        with open(file, 'wb') as file:
            op1 = random_bytes()
            op2 = random_bytes()
            file.write(op1)  # first arg
            file.write(op2)  # second arg
            #file.write(int.to_bytes(sum_bytes(op1, op2), byteorder='little', length=1024))
            for _ in range(total_bytes - 1024):
                file.write(b'\x00')
        print("1024 bytes writed to {}".format(file))

    if mode == 'sc':
        with open(file, 'rb') as file:
            sum_sectors = file.read()
            floppy_sum = sum_sectors[1024:2048]
            if sum_bytes(sum_sectors[:512], sum_sectors[512:1024]) == int.from_bytes(floppy_sum, 'little'):
                print('Sum in 3 and 4 sectors is CORRECT')
            else:
                print('Sum in 3 and 4 sectors INCORRECT')
