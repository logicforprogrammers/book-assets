# requires: len(vec1) == len(vec2)
# ensures: len(out) == len(vec1)
# ensures: all i in 0..<len(out): out[i] == vec1[i] + vec2[i]
def vsum(vec1, vec2):
    out = []
    # loopinv: all j in 0..<i: out[j] == vec1[j] + vec2[j]
    for i in range(len(vec1)):
        out.append(vec1[i] + vec2[i])
    return out
