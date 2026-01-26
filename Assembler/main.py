import sys

op_code = {
    "add": 0,
    "sub": 1,
    "or": 2,
    "and": 3,
    "slt": 4,
    "shft": 5,
    "NA": 6,
    "addi": 7,
    "subi": 8,
}

def compile_r(OP, rs1, rs2, rd):
    return (OP << 12) | (rs1 << 8) | (rs2 << 4) | rd

def compile_i(OP, rd, imm8):
    return (OP << 12) | (rd << 8) | imm8

def compile_line(line):
    # strip comments (minimal)
    if '//' in line:
        line = line.split('//', 1)[0]

    line = line.strip()
    if line == "":
        return None

    parts = line.split(",")
    strop = parts[0]

    if strop not in op_code:
        raise ValueError("unknown opcode: " + strop)

    OP = op_code[strop]
    instr = 0

    if strop == "addi" or strop == "subi" or strop == "shft":
        # I-type: op, rd, imm8
        if len(parts) != 3:
            raise ValueError("bad I-type format: " + line)

        a = int(parts[1])  # rd
        b = int(parts[2])  # imm8

        # error checking
        if a < 0 or a > 15:
            raise ValueError("rd out of range (0-15)")
        if b < 0 or b > 255:
            raise ValueError("imm out of range (0-255)")

        instr = compile_i(OP, a, b)

    else:
        # R-type: op, rs1, rs2, rd
        if len(parts) != 4:
            raise ValueError("bad R-type format: " + line)

        a = int(parts[1])  # rs1
        b = int(parts[2])  # rs2
        c = int(parts[3])  # rd

        # error checking
        if a < 0 or a > 15:
            raise ValueError("rs1 out of range (0-15)")
        if b < 0 or b > 15:
            raise ValueError("rs2 out of range (0-15)")
        if c < 0 or c > 15:
            raise ValueError("rd out of range (0-15)")

        instr = compile_r(OP, a, b, c)

    return instr

out = open("game_instr.txt", "w")

filename = "game.asm"
if len(sys.argv) >= 2:
    filename = sys.argv[1]

f = open(filename, "r", encoding="utf-8")

pc = 0
for line in f:
    instr = compile_line(line)
    if instr is None:
        continue  # skip empty lines


    out.write(f"rom[{pc}] = 16'h{instr:04X};\n")
    pc += 1
f.close()
out.close()
